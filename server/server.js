const express = require("express");
const app = express();
const cors = require("cors");
require('dotenv').config();
const PORT = process.env.PORT || 8080;
const mongoose = require('mongoose');
const mongoURL = process.env.mongoURL; 
const userRoutes = require('./routes/api/users');
const authRoutes = require('./routes/api/auth');
const musicRoutes = require('./routes/api/musicRoutes');
const {check, validationResult} = require('express-validator');
// database connection


// middlewares
app.use(express.json());
app.use(cors());

// routes
app.use("/api/users", userRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/music", musicRoutes);

mongoose.connect(mongoURL)
.then(() => {
  console.log('Connected to MongoDB successfully');
  
  app.listen(PORT, console.log(`Listening on port ${PORT}...`));
})
.catch((err) => {
  console.error('Failed to connect to MongoDB', err);
});
