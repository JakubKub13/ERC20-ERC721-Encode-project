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

}