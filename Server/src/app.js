import express from "express";
import cors from "cors";
import router from "./routes/index.js";
import mongoose from "mongoose";
import path from "path";
import { fileURLToPath } from "url";
import cookieParser from "cookie-parser";

const app = express();

app.use(express.json());

app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self' blob: https://35.197.156.82:8090 http://localhost:8090; " +
    "script-src 'self' https://unpkg.com; " + 
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com/; " + 
    "img-src 'self' data: https://35.197.156.82:8090 http://localhost:8090; " +
    "media-src 'self' data: https://35.197.156.82:8090 http://localhost:8090; " +
    "worker-src 'self' blob: *;" +
    "font-src 'self' data: https://fonts.gstatic.com;"
  );
  next();

});

app.use(cors({
	origin: "*",
	credentials: true,
}));

app.use(cookieParser());
const __dirname = path.dirname(fileURLToPath(import.meta.url));
app.use(express.static(path.join(__dirname, "../static")));
console.log("thu muc hien tai: ", __dirname);

app.use("/api", router);

mongoose.connect("mongodb+srv://giahuy:user123@cluster0.fno0x.mongodb.net/phim")
        .then(() => {
          console.log("Connect to db success");
              })
        .catch(err => console.error("Failed to connect to DB:", err));
app.listen(8089, () => {
  console.log("Server is running 8089 port");
});