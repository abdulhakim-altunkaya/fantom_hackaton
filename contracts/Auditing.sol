// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";

contract Auditing is ERC20Capped {
    
    //EVENTS
    event TokenMinted(address minter, uint amount); 
    event TokenBurned(address burner, uint amount); 
    event TokenTransferred(address receiver, uint amount);
    event TokenDeposited(address sender, uint amount);
    event NewMember(address caller);

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

    //owner can withdraw excess tokens ("profit") to his metamask account.
    function transferToken(uint _amount) external onlyOwner {
        require(balanceOf(address(this)) > 0, "contract doesn't have CONTOR");
        require(msg.sender == tx.origin, "contracts cannot withdraw");
        require(msg.sender != address(0), "real addresses can withdraw");
        _transfer(address(this), msg.sender, _amount*(10**18));
        emit TokenTransferred(msg.sender, _amount);
    }

    //Contract must have enough tokens. So that people can come and buy tokens for auditing service. 
    uint lastReplenishment = block.timestamp;
    function replenishTreasury(uint _amount) external onlyOwner {
        require( block.timestamp > lastReplenishment + 15 seconds, "Replenishment cannot be often");//in production: 5 days
        require(_amount < 2000, "Replenishment must be limited amount");
        lastReplenishment = block.timestamp;
        _mint(address(this), _amount*(10**18));
    }

    //view functions
    function getTotalSupply() external view returns(uint) {
        return totalSupply() / (10**18);
    }
    function getCAddress() external view returns(address) {
        return address(this);
    }
    function getYourBalance() external view returns(uint) {
        return balanceOf(msg.sender) / (10**18);
    }
    function getCBalToken() external view returns(uint) {
        return balanceOf(address(this)) / (10**18);
    }
    function getCBalEther() external view returns(uint) {
        return address(this).balance;
    }

    //3.PAYMENT OPERATIONS
    uint fee = 1;
    function changeFee(uint _fee) external onlyOwner {
        fee = _fee;
    }
    
    function makePayment() external returns(bool) {
        require(balanceOf(msg.sender) >= fee, "you don't have CONTOR");
        require(msg.sender == tx.origin, "contracts cannot withdraw");
        require(msg.sender != address(0), "real addresses can withdraw");
        _transfer(msg.sender, address(this), fee*(10**18));
        emit TokenDeposited(msg.sender, fee);
        return true;
    }
    //Currently the pool of CONTOR/FTM is not based on orderbook model.
    //For that reason there is fixed price which is 12 Contor for 1 FTM
    function buyToken() external payable {
        require(balanceOf(address(this)) >= 1000, "contract does not have enough CONTOR");
        require(msg.sender == tx.origin, "only accounts can buy tokens, not contracts");
        require(msg.sender != address(0), "real addresses can buy");
        //here the buyer send amount(with decimals) to the contract by using msg.value
        require(msg.value == 1*(10**18), "deposit is 1 FTM" ); 
        _transfer(address(this), msg.sender, 12*(10**18));
        emit TokenTransferred(msg.sender, 12);
    }



    //4.MEMBERSHIP OPERATIONS
    modifier isMember() {
        if(membersMapping[msg.sender] == true) {
            revert("already a member");
        }
        _;
    }

    mapping(address => bool) internal membersMapping;
    function becomeMember() external isMember {
        require(balanceOf(msg.sender) >= 10, "you must have at least 10 CONTOR");
        require(msg.sender == tx.origin, "only accounts can become member, not contracts");
        require(msg.sender != address(0), "address 0 cant become member");
        _transfer(msg.sender, address(this), 10*(10**18));
        membersMapping[msg.sender] = true;
        emit NewMember(msg.sender);
    }

    function checkMembership() external view returns(bool) {
        return membersMapping[msg.sender];
    }
    function leaveMembership() external {
        require(msg.sender == tx.origin, "only accounts remove membership");
        require(msg.sender != address(0), "address 0 is already not a member");
        membersMapping[msg.sender] = false;
    }

}
