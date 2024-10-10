const express = require('express');
const connectDB = require('./config/db');

const authRoutes = require('./routes/authRoutes');
const musicRoutes = require('./routes/musicRoutes');

const app = express();
const port = 5000;

// Kết nối tới MongoDB
connectDB();

// Các cấu hình khác cho Express
app.use(express.json());

// Kết nối các route cho tính năng phát nhạc và xác thực người dùng với ứng dụng chính
app.use('/music', musicRoutes);
app.use('/auth', authRoutes);

const host = '::'; // Lắng nghe trên tất cả giao diện IPv6
app.listen(port, host, () => {
  console.log(`Server is running on IPv6`);
});
