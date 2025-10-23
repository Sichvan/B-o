require('dotenv').config();
const express = require('express');
const cors = require('cors');
const newsRoutes = require('./routes/news');
const app = express();
const PORT = process.env.PORT || 5000;
app.use(cors());
app.use(express.json());

app.use('/api/news', newsRoutes);
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'Server OK', message: 'Backend News App running!' });
});
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log(`📡 Test API: http://localhost:${PORT}/api/news`);
  console.log(`❤️ Health: http://localhost:${PORT}/health`);
});