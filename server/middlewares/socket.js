
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");

const authenticateSocket = async (socket, next) => {
    try {
        const token = socket.handshake.auth.token;
        if (!token) {
            return next(new Error("Authentication error"));
        }

        const decoded = jwt.verify(token, "passwordKey");
        const user = await User.findById(decoded.id);

        if (!user) {
            return next(new Error("User not found"));
        }

        socket.request.user = user;
        next();
    } catch (error) {
        next(new Error("Authentication error"));
    }
};

module.exports = authenticateSocket;
