const socketIo = require("socket.io");
const Message = require("../models/message_model");
const Task = require("../models/task_model");
const User = require("../models/user_model");
const ChatGroup = require("../models/chat_group_model");
const authenticateSocket = require("../middlewares/socket");


const admin = require("firebase-admin");

const sendNotification = async (userId, groupId, chatGroupDetails, senderName) => {
    try {
        const user = await User.findById(userId);
        if (!user || !user.fcmToken) return;

        const payload = {
            notification: {
                title: `New message from ${senderName}`,
                body: `Open to view the message in ${chatGroupDetails.name}`,
            },
            data: {
                screen: 'chatGroupDetails',
                extra: groupId,
            },
            token: user.fcmToken,
        };

        await admin.messaging().send(payload);
    } catch (error) {
        console.error("Error sending notification:", error);
    }
};

const connectedUsers = new Map();

const setupSocket = (server) => {
    const io = socketIo(server);

    io.use(authenticateSocket);

    io.on("connection", (socket) => {
        console.log("New client connected");

        const userId = socket.request.user._id;
        connectedUsers.set(userId, socket.id);

        socket.on("sendMessage", async (messageData) => {
            try {
                const { content, taskId, fileUrl, groupId, type } = messageData;
                const senderId = socket.request.user._id;
                const senderName = socket.request.user.name;

                const group = await ChatGroup.findById(groupId).populate("members");
                if (!group) {
                    return socket.emit("error", "Group not found");
                }

                messageData.sender = senderId;
                messageData.senderName = senderName;
                messageData.group = groupId;
                messageData.type = type;

                if (type === "task") {
                    const task = await Task.findById(taskId);
                    if (!task) return socket.emit("error", "Task not found");
                    messageData.task = task;
                } else if (type === "file") {
                    messageData.file = fileUrl;
                }

                const message = new Message(messageData);
                await message.save();

                group.messages.push(message._id);
                group.updatedAt = Date.now();
                await group.save();

                // Emit real-time event
                for (let [userId, socketId] of connectedUsers) {
                    io.to(socketId).emit("newMessage", {
                        ...message._doc,
                        isCurrentUser: userId.toString() === senderId.toString(),
                    });
                }

                for (let member of group.members) {
                    if (member._id.toString() !== senderId.toString()) {
                        await sendNotification(member._id, groupId, group, senderName);
                    }
                }
            } catch (error) {
                console.error("Error in sendMessage:", error);
            }
        });

        socket.on("disconnect", () => {
            console.log("Client disconnected");
            connectedUsers.delete(userId);
        });
    });
};

module.exports = setupSocket;
