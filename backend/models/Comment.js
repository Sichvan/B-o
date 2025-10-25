const mongoose = require('mongoose');
const commentSchema = new mongoose.Schema({
  content: { type: String, required: true },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  articleUrl: { type: String, required: true },
  isApproved: { type: Boolean, default: false }
}, { timestamps: true });
module.exports = mongoose.model('Comment', commentSchema);