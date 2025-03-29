const express = require("express");
const authRouter = express.Router();
const bcryptjs = require("bcryptjs");
const jwt = require("jsonwebtoken");
const User = require("../models/user_model");
const auth = require("../middlewares/auth");

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


authRouter.post('/api/changePassword', auth, async (req, res) => {
  try {
    const { currentPassword, newPassword} = req.body;

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }
    const isMatch = await bcryptjs.compare(currentPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Current password is incorrect' });
    }
    const hashedPassword = await bcryptjs.hash(newPassword, 8);

    user.password = hashedPassword;
    await user.save();

    res.json({ message: 'Password changed successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
});
module.exports = authRouter;
