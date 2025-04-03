const express = require("express");
const ChatGroup = require("../models/chat_group_model");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const User = require("../models/user_model");
const auth = require("../middlewares/auth");

const router = express.Router();

router.get("/api/groupMessages/:groupId", auth, async (req, res) => {
    try {
        const { groupId } = req.params;
        const { page = 1, limit = 20 } = req.query;
        const userId = req.user;

        const messages = await Message.find({ group: groupId })
            .sort({ timestamp: -1 })
            .skip((page - 1) * limit)
            .limit(parseInt(limit))
            .populate("task");

        const modifiedMessages = messages.map(msg => ({
            ...msg._doc,
            isCurrentUser: msg.sender.toString() === userId
        }));

        res.status(200).json(modifiedMessages);
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
});







module.exports = router;
