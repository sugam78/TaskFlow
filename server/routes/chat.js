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
    const userId = req.user;
    // Convert emails to user IDs
    const memberIds = await getUserIdsByEmails(memberEmails);
    if (!memberIds.includes(userId)) {
                memberIds.push(userId);
            }
    const group = new ChatGroup({
        name: name,
        members: memberIds,
        admins: [userId]
    });

    await group.save();
    res.status(201).json(group);
});

// Create a new message (text, task, or file)
router.post("/api/sendMessage", auth, async (req, res) => {
    const { content, taskId, fileUrl, groupId, type } = req.body;
    const senderId = req.user;
    const sender = await User.findById(senderId);
    console.log(sender);

    if (!sender) {
        return res.status(400).json({ message: "Sender not found" });
    }

    const group = await ChatGroup.findById(groupId);

    if (!group) {
        return res.status(404).json({ message: "Group not found" });
    }

    let messageData = {
        sender: sender._id,
        senderName: sender.name,
        group: group._id,
        type: type,
    };
    console.log(messageData);

    if (type === 'text') {
        messageData.content = content;
    } else if (type === 'task') {
        const task = await Task.findById(taskId);
        if (!task) {
            return res.status(404).json({ message: "Task not found" });
        }
        messageData.task = task;
    } else if (type === 'file') {
        messageData.file = fileUrl;
    }

    const message = new Message(messageData);
    await message.save();

    // Add message to group's messages array
    group.messages.push(message._id);
    group.updatedAt = Date.now();
    await group.save();

    res.status(200).json(message);
});

router.get("/api/getGroup/:groupId", auth, async (req, res) => {
    try {
        const { groupId } = req.params;
        const group = await ChatGroup.findById(groupId)
            .populate("members", "name email");
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        res.status(200).json(group);
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
});

router.get("/api/groupMessages/:groupId", auth, async (req, res) => {
    try {
        const { groupId } = req.params;
        const { page = 1, limit = 20 } = req.query;
        const userId = req.user; 

        const messages = await Message.find({ group: groupId })
            .sort({ timestamp: -1 })
            .skip((page - 1) * limit)
            .limit(parseInt(limit));

        const modifiedMessages = messages.map(msg => ({
            ...msg._doc,
            isCurrentUser: msg.sender.toString() === userId
        }));

        res.status(200).json(modifiedMessages);
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
});



router.get("/api/getMyGroups", auth, async (req, res) => {
    try {
        const userId = req.user._id;
        const groups = await ChatGroup.find({ members: userId })
            .select("_id name updatedAt")
            .sort({ updatedAt: -1 });

        res.status(200).json(groups);
    } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
    }
});


module.exports = router;
