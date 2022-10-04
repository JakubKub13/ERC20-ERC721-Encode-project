//SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./interfaces/IERC165.sol";
import "./interfaces/IERC721.sol";

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
}