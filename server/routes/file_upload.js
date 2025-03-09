// routes/fileUploadRoutes.js
const express = require("express");
const cloudinary = require("../config/cloudinary_config");
const multer = require("multer");

const router = express.Router();

// Setup multer for file upload
const storage = multer.memoryStorage();
const upload = multer({ storage: storage });

// File upload to Cloudinary
router.post("/api/file/upload", upload.single("file"), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ message: "No file uploaded" });
        }

        // Upload the file to Cloudinary using the buffer
        const result = await cloudinary.uploader.upload_stream(
            {
                resource_type: "auto", // Auto detects file type (image, video, etc.)
                upload_preset: "klrwndix", // Use your preset name here
            },
            (error, result) => {
                if (error) {
                    return res.status(500).json({ message: "File upload failed", error });
                }
                // Return the uploaded file URL
                return res.status(200).json({ url: result.secure_url });
            }
        );

        // Pipe the file buffer to Cloudinary's upload stream
        result.end(req.file.buffer);  // This line ensures the file buffer is passed correctly

    } catch (error) {
        return res.status(500).json({ message: "Internal server error", error });
    }
});

module.exports = router;
