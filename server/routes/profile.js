const express = require("express");
const User = require("../models/user_model");
const auth = require("../middlewares/auth");

const router = express.Router();

router.get("/api/myProfile",auth,async(req,res)=>{
    const userId = req.user;

    const user = await User.findById(userId).select("name email _id");
    if(!user){
        return res.status(404).json({ message: "User not found" });
    }
    return res.json(user);
});

module.exports = router;