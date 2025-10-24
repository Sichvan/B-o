// backend/routes/auth.js
const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/User');

// --- ĐĂNG KÝ (REGISTER) ---
router.post('/register', async (req, res) => {
  try {
    const { email, password } = req.body;

    // 1. Kiểm tra email và password
    if (!email || !password) {
      return res.status(400).json({ msg: 'Vui lòng nhập email và mật khẩu.' });
    }

    // --- 2. THÊM KIỂM TRA ĐUÔI @gmail.com ---
    if (!email.endsWith('@gmail.com')) {
      return res.status(400).json({ msg: 'Email không đúng định dạng @gmail.com.' });
    }
    // --- KẾT THÚC THÊM ---

    // 3. Kiểm tra xem email đã tồn tại chưa
    let user = await User.findOne({ email });
    if (user) {
      return res.status(400).json({ msg: 'Email đã tồn tại.' });
    }

    // 4. Tạo user mới
    user = new User({ email, password });

    // 5. Mã hóa mật khẩu
    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(password, salt);

    // 6. Lưu user vào DB
    await user.save();

    // 7. Tạo và trả về token
    const payload = {
      user: {
        id: user.id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '7d' },
      (err, token) => {
        if (err) throw err;
        res.status(201).json({
          token,
          user: { id: user.id, email: user.email, role: user.role },
        });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ msg: 'Server Error', error: err.message }); // Luôn trả về JSON
  }
});

// --- ĐĂNG NHẬP (LOGIN) ---
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ msg: 'Vui lòng nhập email và mật khẩu.' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ msg: 'Email hoặc mật khẩu không đúng.' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: 'Email hoặc mật khẩu không đúng.' });
    }

    const payload = {
      user: {
        id: user.id,
        role: user.role,
      },
    };

    jwt.sign(
      payload,
      process.env.JWT_SECRET,
      { expiresIn: '7d' },
      (err, token) => {
        if (err) throw err;
        res.json({
          token,
          user: { id: user.id, email: user.email, role: user.role },
        });
      }
    );
  } catch (err) {
    console.error(err.message);
    res.status(500).json({ msg: 'Server Error', error: err.message }); // Luôn trả về JSON
  }
});

module.exports = router;