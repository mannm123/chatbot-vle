import os
import logging
from dotenv import load_dotenv
from openai import OpenAI
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi import Request, HTTPException, Depends
from pydantic import BaseModel
from typing import List
import mysql.connector
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from functools import lru_cache
from sentence_transformers import SentenceTransformer
import numpy as np
from fastapi.responses import JSONResponse
from deep_translator import GoogleTranslator
from langdetect import detect


embedding_model = SentenceTransformer('all-mpnet-base-v2')
app = FastAPI()
# Load .env
load_dotenv()
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
# MySQL config
MYSQL_CONFIG = {
    "host": os.getenv("MYSQL_HOST"),
    "user": os.getenv("MYSQL_USER"),
    "password": os.getenv("MYSQL_PASSWORD"),
    "database": os.getenv("MYSQL_DB"),
}
class TranslatePayload(BaseModel):
    text: str
# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
from langdetect import detect

def detect_language(text: str) -> str:
    try:
        lang = detect(text)
        return lang if lang in ("vi", "en") else "vi"
    except Exception as e:
        logger.warning(f"⚠️ Language detection failed: {e}")
        return "vi"
def translate_text(text: str, src: str, dest: str) -> str:
    try:
        if src == dest:
            return text
        return GoogleTranslator(source=src, target=dest).translate(text)
    except Exception as e:
        logger.warning(f"⚠️ Translation failed: {e}")
        return text
# FastAPI
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://vle.hcmue.edu.vn","https://chatbotadmin.hcmue.edu.vn"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Request models
class ChatPayload(BaseModel):
    session_id: str
    messages: List[dict]

# Caching QA

def get_cached_qa_pairs():
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT cauhoi, cautraloi, danhmuc FROM data")
        rows = cursor.fetchall()
        conn.close()
        return rows
    except Exception as e:
        logger.error(f"❌ DB load error: {e}")
        return []
def get_vectorizer_and_matrix():
    qa_pairs = get_cached_qa_pairs()
    questions = [q for q, _, _ in qa_pairs]
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform(questions)
    return vectorizer, tfidf_matrix

def find_best_match(query, qa_pairs, threshold=0.5):
    if not qa_pairs:
        return None, 0.0, None
    vectorizer, tfidf_matrix = get_vectorizer_and_matrix()
    query_vec = vectorizer.transform([query])
    sims = cosine_similarity(query_vec, tfidf_matrix).flatten()
    idx = sims.argmax()
    score = sims[idx]
    return qa_pairs[idx][1], score, idx

def find_best_match_for_single(query, candidate, threshold=0.5):
    """So sánh query với một candidate duy nhất bằng cosine similarity."""
    vectorizer = TfidfVectorizer()
    tfidf_matrix = vectorizer.fit_transform([query, candidate])
    sims = cosine_similarity(tfidf_matrix[0:1], tfidf_matrix[1:2]).flatten()
    score = sims[0]
    return candidate, score



def save_message_to_db(session_id: str, role: str, content: str, danhmuc: int = 0,lang: str = "vi"):
    """
    Lưu tin nhắn cùng danhmuc vào bảng chat_history.
    danhmuc = 0 nếu câu trả lời ngoài knowledge base (từ GPT).
    """
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO chat_history (session_id, role, content, danhmuc,lang) 
            VALUES (%s, %s, %s, %s,%s)
            """,
            (session_id, role, content, danhmuc,lang),
        )
        conn.commit()
        conn.close()
    except Exception as e:
        logger.error(f"❌ DB save error: {e}")



@app.get("/health")
def health():
    return {"status": "ok"}

@app.get("/history/{session_id}")
def get_history(session_id: str):
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT role, content FROM chat_history WHERE session_id = %s ORDER BY created_at ASC",
            (session_id,)
        )
        rows = cursor.fetchall()
        conn.close()
        return {"messages": rows}
    except Exception as e:
        logger.error(f"❌ DB history load error: {e}")
        return {"messages": []}
@app.post("/chat")
async def chat(payload: ChatPayload, request: Request):
    body = await request.body()
    logger.info(f"📦 Payload: {body.decode('utf-8')}")
    session_id = payload.session_id
    user_message = payload.messages[-1]['content']
    user_lang = detect_language(user_message)
    translated_input = translate_text(user_message, src=user_lang, dest="vi") if user_lang != "vi" else user_message
    qa_pairs = get_cached_qa_pairs()
    
    if not qa_pairs:
        return {"response": "Không thể tải dữ liệu từ MySQL."}
    answer, score, matched_index = find_best_match(translated_input, qa_pairs)
    logger.info(f"🔍 TF-IDF score: {score:.2f} | query = {translated_input}")

    # Lưu tin nhắn user
    #save_message_to_db(session_id, "user", user_message)

    if score >= 0.7:
        # Khi match được trong knowledge base
        matched_index = None
        vectorizer, tfidf_matrix = get_vectorizer_and_matrix()
        sims = cosine_similarity(vectorizer.transform([translated_input]), tfidf_matrix).flatten()
        matched_index = sims.argmax()
        danhmuc = qa_pairs[matched_index][2] if matched_index is not None and len(qa_pairs[matched_index]) > 2 else 0
        final_reply = translate_text(answer, src="vi", dest=user_lang) if user_lang != "vi" else answer
        save_message_to_db(session_id, "user", user_message, danhmuc=danhmuc,lang=user_lang)
        save_message_to_db(session_id, "assistant", final_reply, danhmuc=danhmuc,lang=user_lang)
        return {"response": final_reply, "source": "knowledge_base", "similarity": round(score, 2)}
    else:
        fallback_reply_vi = (
            "Câu hỏi này chưa thể trả lời, bạn gửi mail về hotrovle@hcmue.edu.vn, hoặc chờ một thời gian chúng tôi sẽ cập nhật câu trả lời (nếu đang sử dụng tab ẩn danh, bạn vui lòng mở lại tab thường để chúng tôi có thể tìm thấy bạn khi câu hỏi của bạn được đội ngũ quản trị viên giải đáp)."
        )
        final_reply = translate_text(fallback_reply_vi, src="vi", dest=user_lang) if user_lang != "vi" else fallback_reply_vi
        logger.info(user_message)
        save_message_to_db(session_id, "user", user_message, danhmuc=0,lang=user_lang)
        save_message_to_db(session_id, "assistant", final_reply, danhmuc=0,lang=user_lang)

        return {
            "response": final_reply,
            "source": "fallback",
            "similarity": round(score, 2)
        }
@app.get("/chat/grouped-unknown")
def get_grouped_unknown_questions_embedding():
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT id, content AS cauhoi ,lang
            FROM chat_history 
            WHERE danhmuc = 0 AND role = 'user' AND created_at >='2025-06-30' and id NOT IN (SELECT chat_history_id FROM mapping_data)
        """)
        rows = cursor.fetchall()
        conn.close()
    except Exception as e:
        logger.error(f"❌ Lỗi khi tải chat_history: {e}")
        return {"groups": []}

    if not rows:
        return {"groups": []}

    # Encode tất cả câu hỏi
    questions = [row["cauhoi"] for row in rows]
    embeddings = embedding_model.encode(questions)

    groups = []
    for idx, record in enumerate(rows):
        matched_index = None
        best_score = 0.0
        for i, group in enumerate(groups):
            if record.get("lang") != group.get("lang"):
                continue
            sim_score = cosine_similarity(
                embeddings[idx].reshape(1, -1),
                group["embedding"].reshape(1, -1)
            )[0][0]

            if sim_score > best_score:
                best_score = sim_score
                matched_index = i

        if best_score >= 0.8:
            groups[matched_index]["ids"].append(record["id"])
            groups[matched_index]["questions"].append(record["cauhoi"])
            groups[matched_index]["count"] += 1
        else:
            groups.append({
                "representative": record["cauhoi"],
                "count": 1,
                "ids": [record["id"]],
                "questions": [record["cauhoi"]],
                "embedding": embeddings[idx],
                "lang": record.get("lang", "vi")
            })

    # Loại bỏ embedding trước khi trả về
    result = []
    for group in groups:
        lang = group.get("lang", "vi")
        if lang == "en":
            rep_translated = translate_text(group["representative"], src="en", dest="vi")
        else:
            rep_translated = group["representative"]
        result.append({
            "representative": rep_translated,
            "count": group["count"],
            "lang": lang,
            "ids": group["ids"],
            "questions": group["questions"]
        })

    return {"groups": result}
@app.post("/api/translate")
def translate(payload: TranslatePayload):
    text = payload.text
    #detected = detect_language(text)
    target = "en" 

    translated = translate_text(text, src="vi", dest=target)

    return {
        "original": text,
        "detected_language": "vi",
        "translated_language": target,
        "translation": translated
    }