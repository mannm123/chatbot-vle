import requests
import time

API_URL = "http://localhost:8000/chat"  # đổi nếu server không chạy local
headers = {"Content-Type": "application/json"}

def send_question(session_id, content):
    payload = {
        "session_id": session_id,
        "messages": [{"role": "user", "content": content}]
    }
    response = requests.post(API_URL, json=payload, headers=headers)
    return response.json()

def chunked(lst, size):
    """Chia list thành các đoạn nhỏ có độ dài size."""
    for i in range(0, len(lst), size):
        yield lst[i:i + size]

def import_and_group_questions(file_path, session_prefix="import_session", session_count=20):
    with open(file_path, "r", encoding="utf-8") as f:
        all_questions = [line.strip() for line in f if line.strip()]

    total = len(all_questions)
    questions_per_session = total // session_count

    sessions = list(chunked(all_questions, questions_per_session))

    # Nếu dư vài câu hỏi do chia không đều
    if len(sessions) > session_count:
        # Gộp phần dư vào phiên cuối cùng
        sessions[session_count - 1].extend(sessions[session_count])
        sessions = sessions[:session_count]

    for i, group in enumerate(sessions):
        session_id = f"{session_prefix}_{i+1:02d}"
        print(f"\n🧾 Session {session_id} - {len(group)} questions")
        for q in group:
            res = send_question(session_id, q)
            print(f"➡️  {q} → ✅ {res.get('response')}")
            time.sleep(0.5)  # tránh spam API

if __name__ == "__main__":
    import_and_group_questions("questions.txt", session_prefix="import20250629")
