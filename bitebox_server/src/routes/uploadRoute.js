const express    = require('express');
const router     = express.Router();
const cloudinary = require('../config/cloudinary');
const upload     = require('../middleware/upload');
const auth       = require('../middleware/auth_middleware');

// POST /upload
router.post('/', auth, upload.single('image'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ message: 'No image provided' });
  }
  try {
    const result = await new Promise((resolve, reject) => {
      const stream = cloudinary.uploader.upload_stream(
        { folder: 'bitebox', resource_type: 'image' },
        (err, result) => (err ? reject(err) : resolve(result))
      );
      stream.end(req.file.buffer);
    });
    return res.status(200).json({ image_url: result.secure_url });
  } catch (err) {
    console.error('upload error:', err.message);
    return res.status(500).json({ message: 'Upload failed' });
  }
});

module.exports = router;
