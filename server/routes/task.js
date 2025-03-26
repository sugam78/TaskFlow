const express = require("express");
const ChatGroup = require("../models/chat_group_model");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const User = require("../models/user_model");
const auth = require("../middlewares/auth");

const router = express.Router();

// Create a new task
router.post("/api/createTask", auth, async (req, res) => {
    const { title, description, assignedToEmail, groupId } = req.body;

    const senderId = req.user;

    const assignedTo = await User.findOne({ email: assignedToEmail });
    if (!assignedTo) {
        return res.status(400).json({ message: "Assigned user not found" });
    }

    const group = await ChatGroup.findById(groupId);
    if (!group) {
        return res.status(404).json({ message: "Group not found" });
    }

    if (!group.members.includes(assignedTo._id)) {
        return res.status(400).json({ message: "Assigned user is not a member of the group" });
    }

    // Create new task
    const task = new Task({
        title: title,
        description: description,
        assignedTo: assignedTo._id,
        createdBy: senderId,
    });

    await task.save();

    res.status(201).json(task);
});

router.put("/api/updateTask/:taskId", auth, async (req, res) => {
    try {
        const { taskId } = req.params;
        const { status } = req.body;

        // Validate status
        const validStatuses = ['pending', 'in-progress', 'completed'];
        if (!validStatuses.includes(status)) {
            return res.status(400).json({ message: "Invalid status" });
        }

        const updatedTask = await Task.findByIdAndUpdate(
            taskId,
            { status, updatedAt: Date.now() },
            { new: true }
        );

        if (!updatedTask) {
            return res.status(404).json({ message: "Task not found" });
        }

        res.status(200).json(updatedTask);
    } catch (error) {
        res.status(500).json({ message: "Server error", error });
    }
});

// API to fetch tasks assigned to the authenticated user
router.get("/api/myTasks", auth, async (req, res) => {
    const userId = req.user;

    // Fetch tasks where the user is assigned to them and the task is not completed
    const tasks = await Task.find({
        assignedTo: userId,
        completed: { $ne: true } // Exclude tasks that are completed
    })
    .sort({ createdAt: -1 }) // Sort from newest to oldest
    .exec();

    if (tasks.length === 0) {
        return res.status(404).json({ message: "No tasks found" });
    }

    res.status(200).json(tasks);
});


module.exports = router;
