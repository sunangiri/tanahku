const Web3 = require("web3");
const contractAbi = require("./CertificateRegistryABI.json");
const contractAddress = "0x3f6518844fb95cc0693bf05a0a0F144d7DEDA699";
const privateKey = "xxx";
const rpcUrl = "https://rpc-amoy.polygon.technology";

const web3 = new Web3(new Web3.providers.HttpProvider(rpcUrl));

const account = web3.eth.accounts.privateKeyToAccount(privateKey);
web3.eth.accounts.wallet.add(account);

const contract = new web3.eth.Contract(contractAbi, contractAddress);

async function mintNFT(tokenUri, name, description, urlLocation) {
  try {
    const result = await contract.methods.mintNFT(tokenUri, name, description, urlLocation).send({ from: account.address, gas: 3000000 }); // tentukan gas limit yang sesuai di sini
    // console.log("Token berhasil diciptakan dengan ID:", result.events.Transfer.returnValues.tokenId);
    return result.events.Transfer.returnValues.tokenId;
  } catch (error) {
    // console.error("Gagal membuat token:", error);
    return false;
  }
}

async function updateTokenMetadata(tokenId, name, description, image, urlLocation) {
  try {
    await contract.methods.updateTokenMetadata(tokenId, name, description, image, urlLocation).send({ from: account.address, gas: 3000000 });
    // console.log("Metadata token berhasil diperbarui.");
    return true;
  } catch (error) {
    console.error("Gagal memperbarui metadata token:", error);
    return false;
  }
}

async function getTokenMetadata(tokenId) {
  try {
    const metadata = await contract.methods.getTokenMetadata(tokenId).call();
    // console.log("Metadata token:", metadata);
    return metadata;
  } catch (error) {
    // console.error("Gagal mendapatkan metadata token:", error);
    return false;
  }
}

async function setAllowedAddress(operator, allowed) {
  try {
    await contract.methods.setAllowedAddress(operator, allowed).send({ from: account.address, gas: 3000000 });
    // return allowed ? true : false;
    return true;
  } catch (error) {
    console.error("Gagal mengatur alamat yang diizinkan:", error);
    return false;
  }
}

// Panggil fungsi di sini
(async () => {
  // console.log(await mintNFT("ppp", "ppp", "ppp", "ppp"));
  // console.log(await updateTokenMetadata("8", "xdddM KhhhHOIRUL RISQI", "xKkiki", "xipfs://ddddd", "xkopololo"));
  // console.log(await getTokenMetadata("2"));
  // console.log(await setAllowedAddress("0x714cb1145218871faebd55de36dbe7053cc9c74d", false));
})();

module.exports = { mintNFT, updateTokenMetadata, setAllowedAddress, getTokenMetadata };
