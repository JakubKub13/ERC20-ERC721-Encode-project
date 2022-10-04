//SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./ERC721.sol";

contract MyNFT is ERC721 {
    string public constant TOKEN_URI = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    function mint(address to, uint tokenId) external {
        _mint(to, tokenId);
    }

    function burn(uint tokenId) external {
        require(msg.sender == _ownerOf[tokenId], "MyNFT: Not owner");
        _burn(tokenId);
    }

    function tokenURI(uint256 /* tokenId */) public view returns (string memory) {
        // require(_exists(tokenId))
        return TOKEN_URI;
    }
}