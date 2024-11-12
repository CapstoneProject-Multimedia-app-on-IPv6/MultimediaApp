const fs = require('fs');
const path = require('path');

const musicDirectory = path.join(__dirname, '../music');

// Phát nhạc
exports.playMusic = (req, res) => {
  const musicId = req.params.id;
  const musicPath = path.join(musicDirectory, `${musicId}.mp3`);

  fs.stat(musicPath, (err) => {
    if (err) {
      return res.status(404).json({ error: 'Music not found' });
    }

    res.setHeader('Content-Type', 'audio/mpeg');
    const readStream = fs.createReadStream(musicPath);
    readStream.pipe(res);
  });
};