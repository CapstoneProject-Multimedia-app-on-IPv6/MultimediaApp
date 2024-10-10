const express = require('express');
const musicController = require('../../controllers/musicController');

const router = express.Router();

router.get('/play-music/:id', musicController.playMusic);

module.exports = router;
