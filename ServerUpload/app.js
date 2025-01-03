import express from "express";
import upload from "../ServerUpload/configs/multerConfig.js";
import uploadController from "../ServerUpload/Controller/UploadController.js";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
app.use(cors({
  origin: "*",
  // credentials: true,
}));

app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self' blob: https://localhost:8090 http://localhost:8090; " +
    "script-src 'self' https://unpkg.com; " + 
    "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com/; " + 
    "img-src 'self' data: https://localhost:8090 http://localhost:8090; " +
    "media-src 'self' data: https://localhost:8090 http://localhost:8090; " +
    "worker-src 'self' blob: *;" +
    "font-src 'self' data: https://fonts.gstatic.com;"
  );
  next();
});

const __dirname = path.dirname(fileURLToPath(import.meta.url));

app.post("/upload", upload.single("file"), uploadController);

app.listen(8090, () => {
  console.log(" Server run in server 8090");
});
