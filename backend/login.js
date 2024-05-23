const express = require("express");
const router = express.Router();

router.post("/login", (req, res) => {
  try {
    const { username, password } = req.body;

    if (username == "admin" && password == "admin123") {
      return res.status(200).json({
        status: true,
        username,
      });
    } else {
      return res.status(403).json({
        status: false,
      });
    }
  } catch (error) {
    return res.status(500).json({
      status: false,
      error,
    });
  }
});

module.exports = router;
