// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Auditing is ERC20Capped {
    
    //EVENTS
    event TokenMinted(address minter, uint amount); 
    event TokenBurned(address burner, uint amount); 
    event TokenTransferred(address receiver, uint amount);

    //1. OWNERSHIP OPERATIONS
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

    //CONSTRUCTOR
    constructor(uint cap) ERC20("Contractorium", "CONTOR") ERC20Capped(cap*(10**18)) {
        owner = msg.sender;
        _mint(address(this), 1000*(10**18));
    }

    //2.TOKEN OPERATIONS
    bool public freeMinting = true;
    uint freeMintingAmount = 1;
    function toggleFreeMinting(uint _amount) external onlyOwner {
        freeMinting = !freeMinting;
        freeMintingAmount = _amount;
    }
    //people will mint token for free for a certain time.
    function freeMint() external {
        require(freeMinting == true, "free minting disabled");
        require(msg.sender == tx.origin, "contracts cannot mint");
        require(msg.sender != address(0), "real addresses can mint");
        _mint(msg.sender, freeMintingAmount*(10**18));
        emit TokenMinted(msg.sender, freeMintingAmount);
    }
    function burnToken(uint _amount) external {
        require(balanceOf(msg.sender) > 0, "you don't have CONTOR");
        _burn(msg.sender, _amount*(10**18));
        emit TokenBurned(msg.sender, _amount);
    }
    function transferToken(uint _amount) external onlyOwner {
        require(balanceOf(address(this)) > 0, "contract doesn't have CONTOR");
        require(msg.sender == tx.origin, "contracts cannot withdraw");
        require(msg.sender != address(0), "real addresses can withdraw");
        _transfer(address(this), msg.sender, _amount*(10**18));
        emit TokenTransferred(msg.sender, _amount);
    }
    function getTotalSupply() external view returns(uint) {
        return totalSupply() / (10**18);
    }
    function getContractAddress() external view returns(address) {
        return address(this);
    }
    function getYourBalance() external view returns(uint) {
        return balanceOf(msg.sender) / (10**18);
    }
    function getContractBalance() external view returns(uint) {
        return balanceOf(address(this)) / (10**18);
    }

    //3.PAYMENT OPERATIONS
    uint fee = 5;
    function makePayment() external {
        require(balanceOf(msg.sender) > 0, "you don't have CONTOR");
        require(msg.sender == tx.origin, "contracts cannot withdraw");
        require(msg.sender != address(0), "real addresses can withdraw");
        _transfer(address(this), msg.sender, _amount*(10**18));
        emit TokenTransferred(msg.sender, _amount);
    }

    address[] internal membersArray;
    mapping(address => bool) internal membersMapping;
    function becomeMember(uint amount) external {

    }

    /*
    -withdraw/transfer tokens
    -withdraw fantom */
}
