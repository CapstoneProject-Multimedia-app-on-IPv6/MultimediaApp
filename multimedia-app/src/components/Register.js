// src/components/Register.js
import React, { useState } from 'react';
import axios from 'axios';

const Register = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  const handleRegister = async (e) => {
    e.preventDefault();
    try {
      await axios.post('http://localhost:5000/register', {
        email,
        password,
      });
      setMessage('Đăng ký thành công! Hãy đăng nhập.');
    } catch (error) {
      setMessage('Đăng ký thất bại. Hãy thử lại.');
    }
  };

  return (
    <div>
      <h2>Đăng ký</h2>
      <form onSubmit={handleRegister}>
        <div>
          <label>Email:</label>
          <input
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div>
          <label>Mật khẩu:</label>
          <input
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit">Đăng ký</button>
      </form>
      <p>{message}</p>
    </div>
  );
};

export default Register;
