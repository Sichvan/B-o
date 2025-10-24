const mongoose = require('mongoose');
const articleSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  imageUrl: { type: String },
  category: { type: String },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User' } // Liên kết tới admin
}, { timestamps: true });
module.exports = mongoose.model('Article', articleSchema);