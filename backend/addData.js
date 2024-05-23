const express = require("express");
const multer = require("multer");
const fetch = require("node-fetch");
const FormData = require("form-data");
const fs = require("fs");
const router = express.Router();
const { mintNFT, getTokenMetadata } = require("./web3");
require("dotenv").config();
const authenticateToken = require("./auth");

const upload = multer({ dest: "uploads/" });

router.post("/add", authenticateToken, upload.single("file"), async (req, res) => {
  try {
    const file = req.file;
    const name = req.body.name;
    const description = req.body.description;
    const urlLocation = req.body.urlLocation;

    const pinataMetadata = {
      name: name,
    };

    const data = new FormData();
    data.append("pinataMetadata", JSON.stringify(pinataMetadata));
    data.append("file", fs.createReadStream(file.path), { filename: file.originalname });

    const pinataRes = await fetch("https://api.pinata.cloud/pinning/pinFileToIPFS", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.PINATA_JWT}`,
      },
      body: data,
    });

    const pinataResData = await pinataRes.json();
    const tokenUrl = `https://ipfs.io/ipfs/${pinataResData.IpfsHash}`;
    const create = await mintNFT(tokenUrl, name, description, urlLocation);
    if (!create) {
      return res.status(500).json({
        status: false,
        message: "Error add data",
      });
    }
    const getMetadata = await getTokenMetadata(create);
    const date = new Date(getMetadata.createdAt * 1000);

    return res.status(200).json({
      status: true,
      message: {
        tokenId: create,
        name: getMetadata.name,
        description: getMetadata.description,
        image: getMetadata.image,
        urlLocation: getMetadata.urlLocation,
        creator: getMetadata.creator,
        createdAt: date,
      },
    });
  } catch (error) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
      error,
    });
  }
});

module.exports = router;
