// socket.js
const socketIo = require("socket.io");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const Group = require("../models/chat_group_model");

const setupSocket = (server) => {
    const io = socketIo(server); // Setup socket server

    io.on("connection", (socket) => {
        console.log("New client connected");

        // Join group chat room
        socket.on("joinGroup", (groupId) => {
            socket.join(groupId);
            console.log(`Joined group ${groupId}`);
        });

        // Send message (text, task, or file)
        socket.on("sendMessage", async (messageData) => {
            const { content, taskId, fileUrl, groupId, senderId, type } = messageData;

            // Modify the existing messageData instead of redeclaring it
            messageData.sender = senderId;
            messageData.group = groupId;
            messageData.type = type;

            if (type === "text") {
                messageData.content = content;
            } else if (type === "task") {
                const task = await Task.findById(taskId);
                if (!task) {
                    return socket.emit("error", "Task not found");
                }
                messageData.task = task._id;
            } else if (type === "file") {
                messageData.file = fileUrl;
            }

            // Create a new message
            const message = new Message(messageData);
            await message.save();

            // Broadcast the message to the group
            io.to(groupId).emit("newMessage", message);
        });


        // Add task to a group (same as sendMessage)
        socket.on("addTask", async (taskData) => {
            const { title, description, assignedTo, groupId, senderId } = taskData;

            // Check if the assigned user is part of the group
            const group = await Group.findById(groupId);
            if (!group) {
                return socket.emit("error", "Group not found");
            }

            // Check if the assigned user is in the group members list
            if (!group.members.includes(assignedTo)) {
                return socket.emit("error", "Assigned user is not a member of the group");
            }

            // Create and save the task
            const task = new Task({
                title: title,
                description: description,
                assignedTo: assignedTo,
                createdBy: senderId,
            });

            await task.save();

            // Broadcast task to the group
            io.to(groupId).emit("newTask", task);
        });

        socket.on("disconnect", () => {
            console.log("Client disconnected");
        });
    });
};

module.exports = setupSocket;
