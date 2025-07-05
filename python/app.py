import os
import logging
from dotenv import load_dotenv
from openai import OpenAI
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import mysql.connector
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from functools import lru_cache
from sentence_transformers import SentenceTransformer
import numpy as np

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

# Logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# FastAPI
app = FastAPI()
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
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



def save_message_to_db(session_id: str, role: str, content: str, danhmuc: int = 0):
    """
    Lưu tin nhắn cùng danhmuc vào bảng chat_history.
    danhmuc = 0 nếu câu trả lời ngoài knowledge base (từ GPT).
    """
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor()
        cursor.execute(
            """
            INSERT INTO chat_history (session_id, role, content, danhmuc) 
            VALUES (%s, %s, %s, %s)
            """,
            (session_id, role, content, danhmuc),
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
    qa_pairs = get_cached_qa_pairs()
    
    if not qa_pairs:
        return {"response": "Không thể tải dữ liệu từ MySQL."}
    answer, score, matched_index = find_best_match(user_message, qa_pairs)

    logger.info(f"🔍 TF-IDF score: {score:.2f} | {user_message}")

    # Lưu tin nhắn user
    #save_message_to_db(session_id, "user", user_message)

    if score >= 0.7:
        # Khi match được trong knowledge base
        matched_index = None
        vectorizer, tfidf_matrix = get_vectorizer_and_matrix()
        sims = cosine_similarity(vectorizer.transform([user_message]), tfidf_matrix).flatten()
        matched_index = sims.argmax()
        danhmuc = qa_pairs[matched_index][2] if matched_index is not None and len(qa_pairs[matched_index]) > 2 else 0
        save_message_to_db(session_id, "user", user_message, danhmuc=danhmuc)
        save_message_to_db(session_id, "assistant", answer, danhmuc=danhmuc)
        return {"response": answer, "source": "knowledge_base", "similarity": round(score, 2)}
    else:
        try:
            context = payload.messages[-3:] if len(payload.messages) > 3 else payload.messages
            completion = client.chat.completions.create(model="gpt-4o-mini", messages=context)

            reply = completion.choices[0].message.content

            # 🔁 Check xem GPT reply có trùng với câu trả lời nào trong knowledge base không
            vectorizer, tfidf_matrix = get_vectorizer_and_matrix()
            reply_vector = vectorizer.transform([reply])
            answer_texts = [q[1] for q in qa_pairs]
            answer_matrix = vectorizer.transform(answer_texts)
            sims = cosine_similarity(reply_vector, answer_matrix).flatten()
            best_match_index = sims.argmax()
            best_score = sims[best_match_index]

            if best_score >= 0.5:
                danhmuc = qa_pairs[best_match_index][2] if len(qa_pairs[best_match_index]) > 2 else 0
            else:
                danhmuc = 0

            # 💾 Lưu lịch sử
            log_conversation(session_id, user_message, reply, danhmuc=danhmuc)

            return {
                "response": reply,
                "source": "gpt",
                "similarity": round(score, 2),
                "matched_answer_similarity": round(best_score, 2)
            }

        except Exception as e:
            logger.error(f"❌ GPT error: {e}")
            return {"response": f"❌ Lỗi khi gọi GPT: {e}", "source": "error"}

@app.get("/chat/grouped-unknown")
def get_grouped_unknown_questions_embedding():
    try:
        conn = mysql.connector.connect(**MYSQL_CONFIG)
        cursor = conn.cursor(dictionary=True)
        cursor.execute("""
            SELECT id, content AS cauhoi 
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
                "embedding": embeddings[idx]
            })

    # Loại bỏ embedding trước khi trả về
    result = []
    for group in groups:
        result.append({
            "representative": group["representative"],
            "count": group["count"],
            "ids": group["ids"],
            "questions": group["questions"]
        })

    return {"groups": result}