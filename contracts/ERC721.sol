//SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC721Receiver.sol";

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed id);
    event Approval(address indexed owner, address indexed spender, uint indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    mapping(uint => address) internal _ownerOf;
    mapping(address => uint) internal _balanceOf;
    mapping(uint => address) internal _approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceID) external view returns (bool) {
        return interfaceID == type(IERC721).interfaceId || interfaceID == type(IERC165).interfaceId;
    }

/// Returns amount of NFTs owned by the address owner
    function balanceOf(address owner) external view returns (uint balance) {
        require(owner != address(0), "ERC721: Owner == address(0)");
        return _balanceOf[owner];
    }

    function ownerOf(uint tokenId) external view returns (address owner) {
        owner = _ownerOf[tokenId];
        require(owner != address(0), "ERC721: Owner == address(0)");
    }

/// By calling this func caller sets the permission to operator to either take control of all of caller NFTs or to revoke that permission
    function setApprovalForAll(address operator, bool _approved) external {
        isApprovedForAll[msg.sender][operator] = _approved;
        emit ApprovalForAll(msg.sender, operator, _approved);
    }

    function approve(address to, uint tokenId) external {
        address owner = _ownerOf[tokenId];
        require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "ERC721: Not authorized");
        _approvals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function getApproved(uint tokenId) external view returns (address operator) {
        require(_ownerOf[tokenId] != address(0), "ERC721: token does not exist");
        return _approvals[tokenId];
    }

/// This function checks whether spender is owner of token ID or whether spender has permission to spend the token
    function _isApprovedOrOwner(address owner, address spender, uint tokenId) internal view returns (bool) {
       return (
        spender == owner ||
        isApprovedForAll[owner][spender] ||
        spender == _approvals[tokenId]
       );
    }

    function transferFrom(address from, address to, uint tokenId) public {
        require(from == _ownerOf[tokenId], "ERC721: from != owner");
        require(to != address(0), "ERC721: Can not transfer to address 0");
        require(_isApprovedOrOwner(from, msg.sender, tokenId), "ERC721: Not authorized");
        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[tokenId] = to;
        delete _approvals[tokenId];
        emit Transfer(from, to, tokenId);
    }

/// This function is similar to transferFrom() with difference if to is a contract we will have to call the funcion IERC721Receiver.onERC721Received()
    function safeTransferFrom(address from, address to, uint tokenId) external {
        transferFrom(from, to, tokenId);
        // Returns 4 bytes of interface id
        require(to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, "") == 
            IERC721Receiver.onERC721Received.selector, "ERC721: Unsafe recipient");
    }

/// Similar to above function with difference that as input we are now passing some data
    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external {
        transferFrom(from, to, tokenId);
        // Returns 4 bytes of interface id
        require(to.code.length == 0 ||
            IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) == 
            IERC721Receiver.onERC721Received.selector, "ERC721: Unsafe recipient");
    }
}