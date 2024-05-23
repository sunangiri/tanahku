const express = require("express");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
const router = express.Router();
const initializeUsers = require("./initUsers");

router.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    // Initialize users
    const users = await initializeUsers();

    // Find the user by username
    const user = users.find((u) => u.username === username);
    if (!user) {
      return res.status(200).json({
        status: false,
        message: "Invalid username or password.",
      });
    }

    // Validate the password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(200).json({
        status: false,
        message: "Invalid username or password.",
      });
    }

    // Generate a JWT token
    const token = jwt.sign({ username: user.username }, process.env.JWT_SECRET, { expiresIn: "1h" });
    res.status(200).json({ status: true, token, username });
  } catch (error) {
    res.status(500).json({ status: false, error: error.message });
  }
});

module.exports = router;
