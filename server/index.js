require('dotenv').config({ path: './secrets.env' });
const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth.js");
const chatRouter = require("./routes/chat.js");
const taskRouter = require("./routes/task.js");
const profileRouter = require("./routes/profile.js");
const fileUploadRoutes = require("./routes/file_upload.js");
const http = require("http");
const socketHandler = require("./socket/socket.js");

const admin = require("firebase-admin");
const serviceAccount = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
})

const app = express();
const server = http.createServer(app);

const DB = process.env.DB_URI;
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(authRouter);
app.use(chatRouter);
app.use(taskRouter);
app.use(profileRouter);
app.use(fileUploadRoutes);

// WebSocket setup
socketHandler(server);

app.use((req, res, next) => {
    res.status(404).send("Endpoint not found");
});

// MongoDB connection
mongoose.connect(DB, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        console.log("MongoDB connection successful!");
    })
    .catch((e) => {
        console.error("MongoDB connection failed", e);
    });

server.listen(PORT, "0.0.0.0", () => {
    console.log(`Server is running on port ${PORT}`);
});
