import express from "express";
import upload from "../ServerUpload/configs/multerConfig.js";
import uploadController from "../ServerUpload/Controller/UploadController.js";
import cors from "cors";
import path from "path";
import { fileURLToPath } from "url";

const app = express();
app.use(cors());
const __dirname = path.dirname(fileURLToPath(import.meta.url));
app.use(express.static(path.join(__dirname, "static")));
app.post("/upload", upload.single("file"), uploadController);

app.listen(8090, () => {
  console.log(" Server run in server 8090");
});
