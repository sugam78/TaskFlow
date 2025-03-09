const express = require("express");
const authRouter = express.Router();
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");

//  Sign up route
authRouter.post("/api/signup", async (req, res) => {
    try {
        const { name, email, password } = req.body;

        // Check if a user with the same email already exists
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ error: "User with the same email already exists" });
        }

        // Hash the password
        const hashedPassword = await bcryptjs.hash(password, 8);

        // Create new user
        let user = new User({
            name,
            email,
            password: hashedPassword,
        });

        user = await user.save();

        res.json({
            msg: "User created successfully",
        });
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

//  Login route
authRouter.post("/api/login", async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ msg: "User with this email does not exist" });
        }

        const isMatch = await bcryptjs.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ error: "Wrong password" });
        }

        const token = jwt.sign({ id: user._id }, "passwordKey");
        const responseUser = {
            _id: user._id,
            name: user.name,
            email: user.email,
            token: token,
        };
        res.json(responseUser);
    } catch (e) {
        res.status(500).json({ error: e.message });
    }
});

module.exports = authRouter;
