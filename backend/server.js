const express = require("express");
const cors = require("cors");
const postRouter = require("./addData");
const getRouter = require("./getData");
const updateRouter = require("./updateData");
const login = require("./login");
require("dotenv").config();

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use("/", postRouter);
app.use("/", getRouter);
app.use("/", updateRouter);
app.use("/", login);

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || "0.0.0.0";

app.listen(PORT, HOST, () => {
  console.log(`Server is running ${HOST}/${PORT}`);
});
