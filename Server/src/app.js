import express from "express";
import cors from "cors";
import router from "./routes/index.js";
import mongoose from "mongoose";
import path from "path";
import { fileURLToPath } from "url";
import cookieParser from "cookie-parser";
import upload from "./configs/multerConfig.js";
import uploadController from "./controllers/UploadController.js"
const app = express();

app.use(express.json());

app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self' blob: http://35.240.234.86:8090 http://35.198.228.50:8089/; " +
    "script-src 'self' https://unpkg.com; " + 
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com/; " + 
    "img-src 'self' data: http://35.240.234.86:8090 http://35.198.228.50:8089/; " +
    "media-src 'self' data: http://35.240.234.86:8090 http://35.198.228.50:8089/; " +
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
app.use(
  express.static(path.resolve(__dirname, "../build"), {
    setHeaders: (res, path) => {
      res.removeHeader("Content-Security-Policy");
    },
  })
);

console.log("thu muc hien tai: ", __dirname);

app.use("/api", router);
app.get("*", (req, res) => {
  res.sendFile(path.resolve(__dirname, "../build/index.html"));
});
app.post("/upload", upload.single("file"), uploadController);
mongoose.connect("mongodb+srv://giahuy:user123@cluster0.fno0x.mongodb.net/phim")
        .then(() => {
          console.log("Connect to db success");
              })
        .catch(err => console.error("Failed to connect to DB:", err));
app.listen(8089, () => {
  console.log("Server is running 8089 port");
});








//   res.setHeader(
//     "Content-Security-Policy-Report-Only",
//     "default-src 'self' blob: http://35.240.234.86:8090; img-src 'self' data: http://35.240.234.86:8090;"
// );
