module.exports = function (req, res, next) {
  if (req.user.role !== 'admin') {
    return res.status(403).json({ msg: 'Truy cập bị cấm. Yêu cầu quyền Admin.' });
  }
  next();
};
