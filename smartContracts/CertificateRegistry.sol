// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.3.0/contracts/utils/Counters.sol";

contract CertificateRegistry is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct NFTMetadata {
        string name;
        string description;
        string image;
        string urlLocation;
        address creator;
        uint256 createdAt;
    }

    mapping(uint256 => NFTMetadata) private _tokenMetadata;
    mapping(address => bool) private _allowedMinters;
    mapping(address => bool) private _allowedEditors;

    constructor() ERC721("Sertifikat Tanah", "ATR/BPN") {}

    // Fungsi untuk membuat NFT baru
    function mintNFT(string memory tokenURI, string memory name, string memory description, string memory urlLocation) public returns (uint256) {
        require(_allowedMinters[msg.sender], "Minting not allowed");
        
        _tokenIds.increment(); 

        uint256 newTokenId = _tokenIds.current(); 
        _mint(msg.sender, newTokenId); 
        _setTokenURI(newTokenId, tokenURI); 
        _tokenMetadata[newTokenId] = NFTMetadata(name, description, tokenURI, urlLocation, msg.sender, block.timestamp);

        return newTokenId;
    }

    // Fungsi untuk memperbarui metadata NFT
    function updateTokenMetadata(uint256 tokenId, string memory name, string memory description, string memory image, string memory urlLocation) public {
        require(_exists(tokenId), "Token does not exist"); 
        require(_isApprovedOrOwner(_msgSender(), tokenId), "Caller is not owner nor approved"); 
        
        require(_allowedEditors[msg.sender], "Only allowed address can update metadata"); 

        _tokenMetadata[tokenId] = NFTMetadata(name, description, image, urlLocation, _tokenMetadata[tokenId].creator, block.timestamp); 
    }

    // Fungsi untuk mendapatkan metadata NFT
    function getTokenMetadata(uint256 tokenId) public view returns (string memory name, string memory description, string memory image, string memory urlLocation, address creator, uint256 createdAt) {
        require(_exists(tokenId), "Token does not exist");
        return (_tokenMetadata[tokenId].name, _tokenMetadata[tokenId].description, _tokenMetadata[tokenId].image, _tokenMetadata[tokenId].urlLocation, _tokenMetadata[tokenId].creator, _tokenMetadata[tokenId].createdAt); // Mengembalikan metadata token dan waktu penciptaan
    }

    // Fungsi untuk mengatur address yang diizinkan untuk minting dan mengedit metadata
    function setAllowedAddress(address operator, bool allowed) public onlyOwner {
        _allowedMinters[operator] = allowed; 
        _allowedEditors[operator] = allowed; 
    }

    // Fungsi untuk memeriksa apakah address diizinkan untuk melakukan minting
    function isAllowedMinter(address minter) public view returns (bool) {
        return _allowedMinters[minter]; 
    }

    // Fungsi untuk memeriksa apakah address diizinkan untuk mengedit metadata
    function isAllowedEditor(address editor) public view returns (bool) {
        return _allowedEditors[editor]; 
    }
}
