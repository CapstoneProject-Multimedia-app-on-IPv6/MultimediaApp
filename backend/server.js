const express = require('express'); // Import thư viện Express
const mongoose = require('mongoose'); // Import thư viện Mongoose để tương tác với MongoDB
const bcrypt = require('bcryptjs'); // Import bcryptjs để mã hóa mật khẩu
const jwt = require('jsonwebtoken'); // Import jsonwebtoken để tạo và xác minh token
const cors = require('cors'); // Import CORS để cho phép tương tác giữa các domain khác nhau

const app = express(); // Khởi tạo một ứng dụng Express
const port = 5000; // Đặt cổng mà server sẽ lắng nghe

// Kết nối tới MongoDB
mongoose.connect('mongodb://localhost:27017/multimedia-app');

app.use(cors()); // Cho phép truy cập API từ các domain khác
app.use(express.json()); // Middleware để phân tích các yêu cầu HTTP với dữ liệu JSON

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});
const User = mongoose.model('User', userSchema);

// Đăng ký người dùng
app.post('/register', async (req, res) => {
  const { email, password } = req.body;
  try {
    const hashedPassword = await bcrypt.hash(password, 10); // Mã hóa mật khẩu
    const user = new User({ email, password: hashedPassword }); // Tạo đối tượng người dùng mới
    await user.save(); // Lưu vào MongoDB
    res.status(201).json({ message: 'User created successfully' });
  } catch (error) {
    res.status(400).json({ error: 'Failed to create user' });
  }
});

// Đăng nhập người dùng
app.post('/login', async (req, res) => {
  const { email, password } = req.body;
  try {
    const user = await User.findOne({ email }); // Tìm người dùng trong MongoDB theo email
    if (!user) return res.status(400).json({ error: 'User not found' });

    const isPasswordValid = await bcrypt.compare(password, user.password); // So sánh mật khẩu đã mã hóa
    if (!isPasswordValid) return res.status(400).json({ error: 'Invalid password' });

    const token = jwt.sign({ id: user._id }, 'secretKey', { expiresIn: '1h' }); // Tạo JWT token
    res.status(200).json({ token, user: { email: user.email } });
  } catch (error) {
    res.status(400).json({ error: 'Login failed' });
  }
});

// Khởi động server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});
