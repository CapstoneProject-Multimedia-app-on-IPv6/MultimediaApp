// src/App.js
import React from 'react';
import Login from './components/Login';
import Register from './components/Register';

function App() {
  return (
    <div className="App">
      <h1>Ứng dụng Multimedia</h1>
      <Register />
      <Login />
    </div>
  );
}

export default App;
