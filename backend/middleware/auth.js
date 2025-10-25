const jwt = require('jsonwebtoken');

// Middleware này chỉ đơn giản là xác thực token
// và gán payload (chứa user.id và user.role) vào req.user
module.exports = function (req, res, next) {
  // Lấy token từ header
  const token = req.header('x-auth-token');

  // Kiểm tra nếu không có token
  if (!token) {
    return res.status(401).json({ msg: 'Không có token, truy cập bị từ chối' });
  }

  // Xác thực token
  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded.user; // Gán payload vào req.user
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token không hợp lệ' });
  }
};
