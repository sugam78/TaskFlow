const socketIo = require("socket.io");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const User = require("../models/user_model");
const ChatGroup = require("../models/chat_group_model");
const authenticateSocket = require("../middlewares/socket");

const connectedUsers = new Map(); // userId => socketId

const setupSocket = (server) => {
    const io = socketIo(server);

    io.use(authenticateSocket);

    io.on("connection", (socket) => {
        console.log("New client connected");


        const userId = socket.request.user._id;
        connectedUsers.set(userId, socket.id);
        console.log(connectedUsers);

        socket.on("sendMessage", async (messageData) => {
            const { content, taskId, fileUrl, groupId, type } = messageData;
            const senderId = socket.request.user._id;
            const senderName = socket.request.user.name;

            const group = await ChatGroup.findById(groupId);

                if (!group) {
                    return res.status(404).json({ message: "Group not found" });
                }

            messageData.sender = senderId;
            messageData.senderName = senderName;
            messageData.group = groupId;
            messageData.type = type;

            if (type === "task") {
                const task = await Task.findById(taskId);
                if (!task) {
                    return socket.emit("error", "Task not found");
                }
                messageData.task = task;
            } else if (type === "file") {
                messageData.file = fileUrl;
            }

            const message = new Message(messageData);
            await message.save();

            group.messages.push(message._id);
            group.updatedAt = Date.now();
            await group.save();

            for (let [userId, socketId] of connectedUsers) {
                io.to(socketId).emit("newMessage", {
                    ...message._doc,
                    isCurrentUser: userId.toString() === senderId.toString()
                });
            }
        });

        socket.on("disconnect", () => {
            console.log("Client disconnected");
            connectedUsers.delete(userId);
        });
    });
};

module.exports = setupSocket;
