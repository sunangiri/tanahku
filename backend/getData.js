const express = require("express");
const router = express.Router();
const { getTokenMetadata } = require("./web3");

router.get("/data/:id", async (req, res) => {
  try {
    const tokenId = req.params.id;
    const getMetadata = await getTokenMetadata(tokenId);

    if (!getMetadata) {
      return res.status(500).json({
        status: false,
        message: "Error add data",
      });
    }

    const date = new Date(getMetadata.createdAt * 1000);

    return res.status(200).json({
      status: true,
      message: {
        tokenId: tokenId,
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
