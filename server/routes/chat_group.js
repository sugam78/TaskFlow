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
            .populate("members", "_id name email");
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        res.status(200).json(group);
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
        res.status(500).json({message: error.message });
    }
});

router.post("/api/addMember", auth, async (req, res) => {
    try {
        const { userEmail, groupId } = req.body;
        const requestingUserId = req.user;

        const requestingUser = await User.findById(requestingUserId);
        if (!requestingUser) {
            return res.status(404).json({ message: "Requesting user not found" });
        }

        const group = await ChatGroup.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        if (!group.admins.includes(requestingUserId)) {
            return res.status(403).json({ message: "Only admins can add members" });
        }

        const userToAdd = await User.findOne({ email: userEmail });
        if (!userToAdd) {
            return res.status(404).json({ message: "User to add not found" });
        }

        if (group.members.includes(userToAdd._id)) {
            return res.status(400).json({ message: "User is already a member" });
        }

        group.members.push(userToAdd._id);
        await group.save();

        res.status(200).json({ message: "User added to the group successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});
router.post("/api/removeMember", auth, async (req, res) => {
    try {
        const { userEmail, groupId } = req.body;
        const requestingUserId = req.user;

        const requestingUser = await User.findById(requestingUserId);
        if (!requestingUser) {
            return res.status(404).json({ message: "Requesting user not found" });
        }

        const group = await ChatGroup.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        if (!group.admins.includes(requestingUserId)) {
            return res.status(403).json({ message: "Only admins can remove members" });
        }

        const userToRemove = await User.findOne({ email: userEmail });
        if (!userToRemove) {
            return res.status(404).json({ message: "User to remove not found" });
        }

        if (!group.members.includes(userToRemove._id)) {
            return res.status(400).json({ message: "User is not a member" });
        }

        await ChatGroup.findByIdAndUpdate(
                    groupId,
                    { $pull: { members: userToRemove._id } },
                    { new: true }
                );

        res.status(200).json({ message: "User removed from the group successfully" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post("/api/makeAdmin", auth, async (req, res) => {
    try {
        const { userEmail, groupId } = req.body;
        const requestingUserId = req.user;

        const requestingUser = await User.findById(requestingUserId);
        if (!requestingUser) {
            return res.status(404).json({ message: "Requesting user not found" });
        }

        const group = await ChatGroup.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        if (!group.admins.includes(requestingUserId)) {
            return res.status(403).json({ message: "Only admins can change admin" });
        }

        const userToAdmin = await User.findOne({ email: userEmail });
        if (!userToAdmin) {
            return res.status(404).json({ message: "User not found" });
        }
        if (!group.members.includes(userToAdmin._id)) {
            return res.status(400).json({ message: "User is not in group" });
        }
        if (group.admins.includes(userToAdmin._id)) {
            return res.status(400).json({ message: "User is already a admin" });
        }

        group.admins.push(userToAdmin._id);
        await group.save();

        res.status(200).json({ message: "User is now admin" });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

router.post("/api/leaveGroup", auth, async (req, res) => {
    try {
        const { groupId } = req.body;
        const userId = req.user;

        const group = await ChatGroup.findById(groupId);
        if (!group) {
            return res.status(404).json({ message: "Group not found" });
        }

        if (!group.members.includes(userId)) {
            return res.status(400).json({ message: "You are not a member of this group" });
        }

        if (group.admins.includes(userId) && group.admins.length === 1) {
            return res.status(403).json({ message: "You are the only admin. Assign another admin before leaving." });
        }

        await ChatGroup.findByIdAndUpdate(
            groupId,
            { $pull: { members: userId, admins: userId } },
            { new: true }
        );

        res.status(200).json({ message: "You left the group successfully" });

    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});


module.exports = router;