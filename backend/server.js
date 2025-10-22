require('dotenv').config();  // Load biến từ .env (NEWS_API_KEY, PORT, v.v.)
const express = require('express');
const cors = require('cors');
const newsRoutes = require('./routes/news');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());  // Cho phép Flutter (emulator/web) gọi API mà không lỗi CORS
app.use(express.json());  // Parse JSON body (nếu sau cần POST)

// Routes
app.use('/api/news', newsRoutes);  // Mount routes: /api/news/ sẽ gọi router.get('/') trong news.js

// Health check endpoint (test server sống)
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'Server OK', message: 'Backend News App running!' });
});

// Xử lý lỗi 404 (nếu gọi route không tồn tại)
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📡 Test API: http://localhost:${PORT}/api/news`);
  console.log(`❤️ Health: http://localhost:${PORT}/health`);
});