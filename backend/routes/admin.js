const express = require('express');
const router = express.Router();
const User = require('../models/User');
const auth = require('../middleware/auth');
const adminAuth = require('../middleware/adminAuth');


router.get('/users', [auth, adminAuth], async (req, res) => {
  try {
    const users = await User.find({ role: { $ne: 'admin' } }).select('-password');
    res.json(users);
  } catch (err) {
    console.error(err.message);
    res.status(500).send('Server Error');
  }
});


router.delete('/users/:id', [auth, adminAuth], async (req, res) => {
  try {
    const user = await User.findById(req.params.id);

    if (!user) {
      return res.status(404).json({ msg: 'Không tìm thấy người dùng' });
    }
    if (user.role === 'admin') {
      return res.status(400).json({ msg: 'Không thể xóa tài khoản Admin' });
    }

    await User.findByIdAndDelete(req.params.id);

    res.json({ msg: 'Đã xóa người dùng' });
  } catch (err) {
    console.error(err.message);
    if (err.kind === 'ObjectId') {
      return res.status(404).json({ msg: 'Không tìm thấy người dùng' });
    }
    res.status(500).send('Server Error');
  }
});

module.exports = router;
