const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const path = require('path');
const auth = require('basic-auth');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const https = require('https');
const fs = require('fs');

const app = express();
app.use(cors());
app.use(express.json());
// const options = {
//   key: fs.readFileSync('/home/mannminh/ssl/hcmue_edu_vn.key'),
//   cert: fs.readFileSync('/home/mannminh/ssl/star_hcmue_edu_vn_cert.pem')
// };

const pool = mysql.createPool({
  host: 'localhost',
  user: 'chatbot_vle',
  password: 'chatbot_vle',
  database: 'chatbot_vle',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Tạo promise để dùng async/await
const db = pool;

// Kiểm tra kết nối một lần ban đầu
db.query('SELECT 1', (err) => {
  if (err) {
    console.error('❌ Không thể kết nối MySQL:', err.message);
    process.exit(1);
  } else {
    console.log('✅ Đã kết nối tới MySQL');
  }
});

function basicAuth(req, res, next) {
  const credentials = auth(req);
  const USERNAME = 'admin';
  const PASSWORD = 'Vle@123';
  if (!credentials || credentials.name !== USERNAME || credentials.pass !== PASSWORD) {
    res.set('WWW-Authenticate', 'Basic realm="VLE Admin"');
    return res.status(401).send('Access denied');
  }
  next();
}
function handleDisconnect() {
  const db = mysql.createConnection({
    host: 'localhost',
    user: 'chatbot_vle',
    password: 'chatbot_vle',
    database: 'chatbot_vle'
  });

  db.connect((err) => {
    if (err) {
      console.error('❌ Reconnect thất bại, thử lại sau 2s...', err.message);
      setTimeout(handleDisconnect, 2000); // retry sau 2 giây
    } else {
      console.log('✅ Reconnected to MySQL');
    }
  });

  db.on('error', function(err) {
    console.error('💥 MySQL error:', err);
    if (err.fatal) {
      handleDisconnect();
    }
  });

  global.db = db; // nếu bạn cần chia sẻ lại kết nối
}

// Bảo vệ addForm.html bằng Basic Auth
app.get('/dashboard', basicAuth,(req, res) => {
  res.sendFile(path.join(__dirname, '..','frontend','dashboard.html'));
});
app.get('/admin', basicAuth,(req, res) => {
  res.sendFile(path.join(__dirname, '..','frontend','addForm.html'));
});
app.get('/addcate', basicAuth,(req, res) => {
  res.sendFile(path.join(__dirname, '..','frontend','addCat.html'));
});
app.get('/perchat', basicAuth,(req, res) => {
  res.sendFile(path.join(__dirname, '..','frontend','perchat.html'));
});
// app.get('/',  (req, res) => {
//   res.sendFile(path.join(__dirname, '..','frontend','SearchForm.html'));
// });
app.use(express.static(path.join(__dirname,'..', 'frontend')));
//Lấy danh mục
app.get('/api/filters', (req, res) => {
  db.query(
    'SELECT id, ten from danhmuc',
    (err, rows) => {
      if (err) return res.status(500).send(err);
      const danhmuc = [...new Set(rows.map(r => r.ten))];
      const id = [...new Set(rows.map(r => r.id))];
      // const cauhoi = [...new Set(rows.map(r => r.cauhoi))];
      res.json({ id, danhmuc: rows });
    }
  );
});
app.get('/api/loaddanhmuc', (req, res) => {
  db.query('SELECT id, ten FROM danhmuc', (err, rows) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Lỗi truy vấn danh mục' });
    }
    res.json(rows);
  });
});
app.post('/api/danhmuc', (req, res) => {
  const { ten } = req.body;
  if (!ten) {
    return res.status(400).json({ success: false, message: 'Thiếu tên danh mục' });
  }
  db.query('INSERT INTO danhmuc (ten) VALUES (?)', [ten], (err, result) => {
    if (err) {
      return res.status(500).json({ success: false, message: 'Lỗi thêm danh mục' });
    }
    res.json({ success: true, id: result.insertId });
  });
});
// Xóa Danh mục
app.delete('/api/danhmuc/:id', (req, res) => {
  const { id } = req.params;

  db.query('DELETE FROM danhmuc WHERE id = ?', [id], (err, result) => {
    if (err) {
      console.error(err);
      return res
        .status(500)
        .json({ success: false, message: 'Lỗi khi xoá danh mục' });
    }

    res.json({ success: true }); // ✅ Trả về kết quả thành công
  });
});
// Cập nhật Danh mục
app.put('/api/danhmuc/:id', (req, res) => {
  const { id } = req.params;
  const { ten } = req.body;
  console.log(id);
  if (!ten || ten.trim() === '') {
    return res
      .status(400)
      .json({ success: false, message: 'Tên danh mục không được để trống' });
  }

  db.query(
    'UPDATE danhmuc SET ten = ? WHERE id = ?',
    [ten, id],
    (err, result) => {
      if (err) {
        console.error(err);
        return res
          .status(500)
          .json({ success: false, message: 'Lỗi khi cập nhật danh mục' });
      }

      if (result.affectedRows > 0) {
        res.json({ success: true });
      } else {
        res
          .status(404)
          .json({ success: false, message: 'Không tìm thấy danh mục' });
      }
    }
  );
});


// Tìm kiếm
app.post('/api/search', (req, res) => {
  const { cauhoi } = req.body;
  db.query('SELECT * FROM data WHERE cauhoi LIKE ?', [`%${cauhoi}%`], (err, results) => {
    if (err) return res.status(500).send(err);
    res.json(results);
  });
});

// Thêm câu hỏi
app.post('/api/add', (req, res) => {
  const { danhmuc, cauhoi, traloi } = req.body;
  if (!danhmuc || !cauhoi || !traloi) {
    return res.status(400).json({ success: false, message: 'Thiếu danh mục, câu hỏi hoặc trả lời' });
  }
//console.log(danhmuc);
  db.query('SELECT id FROM danhmuc WHERE id = ?', [danhmuc], (err, results) => {
    if (err || results.length === 0) {
      return res.status(500).json({ success: false, message: 'Không tìm thấy danh mục tương ứng' });
    }

    const danhmucId = results[0].id;
    const sql = 'INSERT INTO data (danhmuc, cauhoi, cautraloi) VALUES (?, ?, ?)';
    db.query(sql, [danhmucId, cauhoi, traloi], (err2) => {
      if (err2) {
        return res.status(500).json({ success: false, message: 'Lỗi khi thêm dữ liệu' });
      }
      res.json({ success: true });
    });
  });
});

// Lấy danh sách câu hỏi
app.get('/api/questions', (req, res) => {
  const sql =` 
    SELECT d.id, d.cauhoi, d.cautraloi, dm.ten as danhmuc
    FROM data d
    JOIN danhmuc dm ON d.danhmuc = dm.id;`
  db.query(sql, (err, results) => {
    if (err) return res.status(500).json({ message: 'Lỗi truy vấn' });
    res.json(results);
  });
});

// Xoá câu hỏi
app.delete('/api/questions/:id', (req, res) => {
  const { id } = req.params;
  db.query('DELETE FROM data WHERE id = ?', [id], (err) => {
    if (err) return res.status(500).json({ message: 'Lỗi xoá câu hỏi' });
    res.json({ success: true });
  });
});

// Cập nhật câu hỏi
app.put('/api/questions/:id', (req, res) => {
  const { id } = req.params;
  const { cauhoi, traloi } = req.body;
  db.query('UPDATE data SET cauhoi = ?, cautraloi = ? WHERE id = ?', [cauhoi, traloi, id], (err) => {
    if (err) return res.status(500).json({ message: 'Lỗi cập nhật' });
    res.json({ success: true });
  });
});
//lấy thống kê câu hỏi ng dùng
app.get("/api/getchatuser", (req, res) => {
  const sql = `
    SELECT 
      CASE 
        WHEN ch.danhmuc = 0 THEN 'chatgpt' 
        ELSE dm.ten 
      END AS category,
      COUNT(ch.danhmuc) AS count
    FROM chat_history AS ch
    LEFT JOIN danhmuc AS dm ON dm.id = ch.danhmuc where ch.role='user'
    GROUP BY category
    ORDER BY count DESC;`
  ;
  db.query(sql, (err, results) => {
    if (err) {
      console.error(err);
      return res
        .status(500)
        .json({ success: false, message: "Lỗi khi lấy số liệu chat" });
    }
    res.json(results);
  });
});
app.get("/api/getchatassistant", (req, res) => {
  const sql =` 
    SELECT 
      CASE 
        WHEN ch.danhmuc = 0 THEN 'chatgpt' 
        ELSE dm.ten 
      END AS category,
      COUNT(ch.danhmuc) AS count
    FROM chat_history AS ch
    LEFT JOIN danhmuc AS dm ON dm.id = ch.danhmuc where ch.role='assistant'
    GROUP BY category
    ORDER BY count DESC;`
  ;
  db.query(sql, (err, results) => {
    if (err) {
      console.error(err);
      return res
        .status(500)
        .json({ success: false, message: "Lỗi khi lấy số liệu chat" });
    }
    res.json(results);
  });
});
app.post("/api/add_question_from_group", (req, res) => {
  const { danhmuc, cauhoi, cautraloi, ids } = req.body;

  if (!danhmuc || !cauhoi || !cautraloi || !ids || ids.length === 0) {
    return res.status(400).json({ success: false, message: "Thiếu thông tin" });
  }

  // 1. Thêm vào data
  db.query(
    "INSERT INTO data (danhmuc, cauhoi, cautraloi) VALUES (?, ?, ?)",
    [danhmuc, cauhoi, cautraloi],
    (err, result) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ success: false, message: "Lỗi khi thêm data" });
      }

      const dataId = result.insertId;

      // 2. Lưu mapping
      const values = ids.map((chatId) => [dataId, chatId]);
      db.query(
        "INSERT INTO mapping_data (data_id, chat_history_id) VALUES ?",
        [values],
        (err2) => {
          if (err2) {
            console.error(err2);
            return res
              .status(500)
              .json({ success: false, message: "Lỗi khi tạo mapping" });
          }

          res.json({ success: true, id: dataId });
        }
      );
    }
  );
});
app.get("/api/chat_count_by_hour", (req, res) => {
  db.query(`
    SELECT HOUR(created_at) AS hour, COUNT(*) AS count
     FROM chat_history
     WHERE role = 'user'
     GROUP BY HOUR(created_at)
     ORDER BY HOUR(created_at)`,
    (err, results) => {
      if (err) {
        return res.status(500).send(err);
      }
      res.json(results);
    }
  );
});
app.get("/api/chat_summary", (req, res) => {
  const sql =` 
    SELECT
      (SELECT COUNT(DISTINCT session_id) FROM chat_history) AS total_sessions,
      (SELECT COUNT(*) FROM chat_history WHERE role = 'user') AS total_questions,
      (SELECT COUNT(*) FROM chat_history WHERE role = 'user' AND danhmuc != 0) AS recognized_questions
  ;`

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).send(err);
    }

    const { total_sessions, total_questions, recognized_questions } = results[0];
    const effectiveness = total_questions > 0
      ? Math.round((recognized_questions / total_questions) * 100)
      : 0;

    res.json({
      total_sessions,
      total_questions,
      recognized_questions,
      effectiveness
    });
  });
});
app.get("/api/perchat", (req, res) => {
  const sql = `
    SELECT 
      dm.ten AS danhmuc,
      SUM(CASE WHEN ch.role = 'user' THEN 1 ELSE 0 END) AS user_count,
      SUM(CASE WHEN ch.role = 'assistant' THEN 1 ELSE 0 END) AS assistant_count
    FROM chat_history AS ch
    JOIN danhmuc AS dm ON ch.danhmuc = dm.id
    WHERE ch.danhmuc <> 0
    GROUP BY dm.ten
    ORDER BY dm.ten;
  `;

  db.query(sql, (err, results) => {
    if (err) {
      console.error('Query error:', err);
      return res.status(500).send({ error: 'Database query error' });
    }

    res.json({
      status: 'success',
      data: results
    });
  });
});


app.listen(3000, () => {
  console.log('✅ HTTP Server is running on 0.0.0.0:3000');
});