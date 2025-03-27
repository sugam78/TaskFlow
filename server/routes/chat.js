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
            .limit(parseInt(limit))
            .populate("task"); // Populate task details

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
        const userId = req.user;
        const groups = await ChatGroup.find({ members: userId })
            .select("_id name updatedAt")
            .sort({ updatedAt: -1 });

        res.status(200).json(groups);
    } catch (error) {
        res.status(500).json({ message: "Server error", error: error.message });
    }
});


module.exports = router;
