import express from "express";
import cors from "cors";
import router from "./routes/index.js";
import mongoose from "mongoose";
import path from "path";
import { fileURLToPath } from "url";
import cookieParser from "cookie-parser";
import { startMetricsServer } from "../until/metrics.js";
const app = express();

app.use(express.json());

//handle csp refused to create blob worker
app.use((req, res, next) => {
  res.setHeader(
    "Content-Security-Policy",
    "default-src 'self' blob:; script-src 'self' blob:;"
  );
  next();
});
app.use(cors());
app.use(cookieParser());
// Lấy đường dẫn thư mục hiện tại
const __dirname = path.dirname(fileURLToPath(import.meta.url));
console.log("thu muc hien tai: ", __dirname);
app.use(express.static(path.join(__dirname, "static/build").replace("src", "")));
console.log("Dirbuild: ",path.join(__dirname, "static/build").replace("src", "") );
app.use("/api", router);
mongoose.connect("mongodb+srv://giahuy:user123@cluster0.fno0x.mongodb.net/phim").then(() => {
  console.log("Connect to db success");
});
app.listen(8089, () => {
  console.log("Server is running 8089 port");
  startMetricsServer();
});
//export const viteNodeApp = app;
