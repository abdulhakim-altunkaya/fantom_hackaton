// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Auditing {

    address public owner;

    error OwnerError(string message, address caller);
    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert OwnerError("you are not owner", msg.sender);
        }
        _;
    }

    function transferOwnership(address _newOwner) external onlyOwner {
        require(_newOwner != address(0), "owner must be address");
        owner = _newOwner;
    }

    constructor() {
        owner = msg.sender;
    }


    address[] internal membersArray;
    mapping(address => bool) internal membersMapping;
    function becomeMember(uint amount) external {

    }
}
