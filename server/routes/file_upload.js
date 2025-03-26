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

        // Function to handle Cloudinary upload and return a Promise
        const uploadToCloudinary = () => {
            return new Promise((resolve, reject) => {
                const uploadStream = cloudinary.uploader.upload_stream(
                    {
                        resource_type: "auto",
                        upload_preset: "klrwndix",
                    },
                    (error, result) => {
                        if (error) {
                            reject(error);  // Reject the Promise in case of error
                        } else {
                            resolve(result);  // Resolve the Promise with the result
                        }
                    }
                );

                // Pipe the file buffer to Cloudinary's upload stream
                uploadStream.end(req.file.buffer);
            });
        };

        // Await the file upload to Cloudinary
        const result = await uploadToCloudinary();

        // Return the uploaded file URL
        return res.status(200).json({ url: result.secure_url });

    } catch (error) {
        return res.status(500).json({ message: "File upload failed", error: error.message });
    }
});

module.exports = router;
