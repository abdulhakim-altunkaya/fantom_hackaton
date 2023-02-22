//SPDX-License-Identifier: MIT

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract OmniaStaking is ERC20Capped {

    //owner related code, 
    //I could use Ownable of OpenZeppelin but I want to make the contract easier to read.
    address public owner;
    error NotOwner(address caller, string message);
    modifier onlyOwner() {
        if(msg.sender != owner) {
            revert NotOwner(msg.sender, "you are not owner");
        }
        _;
    }
    function changeOwner(address _newOwner) external onlyOwner{
        require(_newOwner != address(0), "owner cant be address(0)");
        owner = _newOwner;
    }


    //Here I am choosing a lazy cap token supply strategy
    //10**18 because coin has 18 decimals and I dont want anybody to write 18 zeros when using the contract
    //I am also assigning the owner here.
    constructor(uint cap) ERC20("OmniaStaking", "OMSTAK") ERC20Capped(cap*(10**18)) {
        owner = msg.sender;
    }

    uint[] public sla = [99, 96, 88, 75, 50];

    function claim(uint _yield, )



}