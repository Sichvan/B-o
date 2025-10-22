const express = require('express');
const router = express.Router();
const axios = require('axios');

router.get('/', async (req, res) => {
  try {
    const apiKey = process.env.NEWSDATA_API_KEY;

    const apiUrl = `https://newsdata.io/api/1/news?apikey=${apiKey}&language=vi&image=1&size=10`;

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