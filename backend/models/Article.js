const mongoose = require('mongoose');

// Danh sách các key thể loại
// Chúng ta dùng key tiếng Anh để đồng bộ với API (nếu sau này bạn muốn gộp)
// và sẽ map sang tiếng Việt ở frontend
const categoryKeys = [
  'top', 'politics', 'world', 'business', 'science', 'entertainment',
  'sports', 'crime', 'education', 'health', 'other', 'technology'
];

const articleSchema = new mongoose.Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  imageUrl: { type: String },
  author: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  language: {
    type: String,
    enum: ['vi', 'en'], // 'vi' cho Tiếng Việt, 'en' cho Tiếng Anh
    required: true,
  },
  category: {
    type: String,
    enum: categoryKeys,
    required: true,
  },
  sourceName: {
    type: String,
    default: 'Tin tức Admin' // Để phân biệt với bài từ API
  }
}, { timestamps: true });

module.exports = mongoose.model('Article', articleSchema);
