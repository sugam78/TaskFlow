const express = require("express");
const ChatGroup = require("../models/chat_group_model");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const User = require("../models/user_model");
const auth = require("../middlewares/auth");

const router = express.Router();

// Helper function to convert emails to user IDs
const getUserIdsByEmails = async (emails) => {
    const users = await User.find({ email: { $in: emails } });
    return users.map(user => user._id);
};

// Create new group
router.post("/api/createGroup",auth, async (req, res) => {
    const { name, memberEmails } = req.body;

    // Convert emails to user IDs
    const memberIds = await getUserIdsByEmails(memberEmails);

    const group = new ChatGroup({
        name: name,
        members: memberIds,
    });

    await group.save();
    res.status(201).json(group);
});

// Create a new message (text, task, or file)
router.post("/api/sendMessage", auth, async (req, res) => {
    const { content, taskId, fileUrl, groupId, type } = req.body;
    const sender = req.user;

    if (!sender) {
        return res.status(400).json({ message: "Sender not found" });
    }

    const group = await ChatGroup.findById(groupId);

    if (!group) {
        return res.status(404).json({ message: "Group not found" });
    }

    let messageData = {
        sender: sender._id,
        group: group._id,
        type: type,
    };

    if (type === 'text') {
        messageData.content = content;
    } else if (type === 'task') {
        const task = await Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ message: "Task not found" });
        }
        messageData.task = task._id; // Attach task to message
    } else if (type === 'file') {
        messageData.file = fileUrl;
    }

    const message = new Message(messageData);
    await message.save();

    // Add message to group's messages array
    group.messages.push(message._id);
    await group.save();

    res.status(200).json(message);
});




module.exports = router;
