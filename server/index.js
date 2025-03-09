require('dotenv').config({ path: './secrets.env' });

const express = require("express");
const mongoose = require("mongoose");
const authRouter = require("./routes/auth.js");

const app = express();
const DB = process.env.DB_URI;
const PORT = 3000;

app.use(express.json());
app.use(authRouter);

app.use((req, res, next) => {
    res.status(404).send("Endpoint not found");
});


mongoose.connect(DB).then(()=>{
    console.log("Connection Success");
}).catch((e)=>{
    console.log(e);
});

app.listen(PORT,"0.0.0.0",()=>{
    console.log(`connected to port ${PORT}`);
});