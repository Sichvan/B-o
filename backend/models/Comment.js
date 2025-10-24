const mongoose = require('mongoose');
const commentSchema = new mongoose.Schema({
  content: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  articleUrl: { type: String, required: true }, // Dùng URL của bài báo (từ API)
  isApproved: { type: Boolean, default: false } // Admin phải duyệt
}, { timestamps: true });
module.exports = mongoose.model('Comment', commentSchema);