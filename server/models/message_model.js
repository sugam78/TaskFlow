const mongoose = require("mongoose");

const messageSchema = new mongoose.Schema({
    sender: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    senderName: { type: String, required: true },
    group: { type: mongoose.Schema.Types.ObjectId, ref: "ChatGroup", required: true },
    content: { type: String, required: false },
    task: { type: mongoose.Schema.Types.ObjectId, ref: "Task", required: false }, // Store task ID
    file: { type: String, required: false },
    type: {
        type: String,
        enum: ['text', 'task', 'file'],
        required: true,
    },
    timestamp: { type: Date, default: Date.now },
});

const Message = mongoose.model("Message", messageSchema);
module.exports = Message;
