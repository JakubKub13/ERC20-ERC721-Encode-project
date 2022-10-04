//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MyERC20 is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    constructor() ERC20("MyERC20Token", "MERC20") {
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function mint(address _to, uint256 _amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "MyERC20: Caller is not a minter");
        _mint(_to, _amount);
    }
}