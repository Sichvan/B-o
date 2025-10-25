const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/', async (req, res) => {
  try {
    const apiKey = process.env.NEWSDATA_API_KEY;
    const category = req.query.category;
    const language = req.query.language || 'vi';

    let apiUrl = `https://newsdata.io/api/1/news?apikey=${apiKey}&language=${language}&image=1&size=10`;
    if (category) {
      apiUrl += `&category=${category}`;
    }
    const response = await axios.get(apiUrl);
    res.json(response.data.results);
  } catch (err) {
    console.error("Error fetching from NewsData.io:", err.message);
    if (err.response) {
      console.error("NewsData.io Error Data:", err.response.data);
      res.status(err.response.status).json(err.response.data);
    } else {
      res.status(500).send('Server Error');
    }
  }
});

module.exports = router;