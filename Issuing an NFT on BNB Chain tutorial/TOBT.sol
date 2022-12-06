// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

/** @title BSCNFT */ 
contract TOBT is ERC721, Pausable, Ownable {

    /* Property Variables */

    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIdCounter;
    string private _baseTokenURI = "https://www.binance.info/bapi/asset/v1/public/wallet-direct/babt/metadata/";

    uint256 public MINT_PRICE = 0.0005 ether;  //Change this value as per your requirement

    /** @dev Constructor to set Name and Initials for NFT
             and increment token counter 
     */
    constructor() ERC721("TechOps Bound Token", "TOBT") {
        // Start token ID at 1. By default is starts at 0.
        _tokenIdCounter.increment();
    }

    /** @dev Withdraw Tokens 
     */
    function withdraw() public onlyOwner() {
        require(address(this).balance > 0, "Balance is zero");
        payable(owner()).transfer(address(this).balance);
    }

    /** @dev Pause NFT Function
      */
    function pause() public onlyOwner {
        _pause();
    }
    /** @dev Unpause NFT Function
      */
    function unpause() public onlyOwner {
        _unpause();
    }

    /** @dev Function to Mint NFTs
      */

    function safeMint(address to) public payable {

        // Check if enough amount of Ethers are passed
        require(msg.value >= MINT_PRICE, "Not enough ether sent.");
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    /** @dev Function to set the URI of the NFT
      */


  function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return
            bytes(_baseTokenURI).length > 0
                ? string(abi.encodePacked(_baseTokenURI, tokenId.toString()))
                : "";
    }


    /** @dev The following functions are overrides required by Solidity.
      */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}