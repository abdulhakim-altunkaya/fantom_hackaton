//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.7;

import "./SafeMath.sol";

contract StakingTKN {
    
    //safemath libray is used to prevent uint overflows.
    using SafeMath for uint256;

    //Mapping to record how much stake an address has deposited.
    //Mapping to record how much rewards an address has(in wei).
    mapping(address => uint256) internal stakes;
    mapping(address => uint256) internal rewards;
    address[] internal stakeholders;
    uint256 internal numberOfTokens;


    //an owner will be defined. The owner will set how many tokens to issue, 
    //and he/she will also distribute the rewards manually.
    //Owner is also a stakeholder. Thats why it is added to the array and mapping.
    address public owner;

    constructor(uint256 _tokenNumber) {
        owner = msg.sender;
        mint(_tokenNumber);
        stakes[msg.sender] = _tokenNumber;
        stakeholders.push(msg.sender);
    }

    //onlyOwner modifier will be used for making sure the account supplying initial tokens is owner.
    //isStakeholder modifier will be used for making sure the account withdrawing stakes are stakeholders.
    //stakeholders must have stakes bigger than 0. That's why we set the condition accordingly.
    modifier onlyOwner(){
        require(msg.sender == owner, "You are not the owner");
        _;
    }
    modifier isStakeholder(address _stakeholder){
        require(stakes[_stakeholder] != 0, "stake doesnot exist");
        _;
    }
    modifier isZero(uint256 _tokenAmount) {
        require(_tokenAmount > 0, "Must be bigger than 0");
        _;
    }
    //this modifier is used with withdraw function to make sure msg.sender cannot withdraw 
    //more than it staked.
    modifier isBigger(address _stakeholder, uint256 _tokenAmount){
        require(_tokenAmount <= stakes[_stakeholder], "Withdrawal must be smaller than Stake");
        _; 
    }

    //Here the owner of the contract, deposits a primary amount of tokens to the contract.
    //We can also view this step as "minting" for simplicity.
    function mint(uint256 _tokenNumber) internal onlyOwner isZero(_tokenNumber) {
        numberOfTokens = numberOfTokens.add(_tokenNumber);
    }

    //STAKING FUNCTION PART
    //First newUser bool will store the result of checkUser function.
    //checkUser function will see if the staking address is new or existing. 
    //This bool data will then be used inside the stake function.
    bool internal newUser = true;
    function checkUser(address _a) internal {
        for(uint256 i = 0; i<stakeholders.length; i++) {
            if(stakeholders[i] == _a) {
                newUser = false;
            }
        }
    }
    function stake(uint256 _tokenAmount) public isZero(_tokenAmount) {
        checkUser(msg.sender);
        if(newUser == true) {
            stakes[msg.sender] = _tokenAmount;
            stakeholders.push(msg.sender);
            numberOfTokens = numberOfTokens.add(_tokenAmount);
        } else {
            stakes[msg.sender] = stakes[msg.sender].add(_tokenAmount);
            numberOfTokens = numberOfTokens.add(_tokenAmount);
        }
    }

    //In withdraw function, I make sure if msg.sender is a stakeholder and if he is withdrawing more than zero.
    //Later I am updating main state variables.
    function withdrawStake(uint256 _tokenAmount) public isStakeholder(msg.sender) isZero(_tokenAmount) isBigger(msg.sender, _tokenAmount){
        if(_tokenAmount == stakes[msg.sender]) {
            //here a transfer function will be used.
            numberOfTokens = numberOfTokens.sub(_tokenAmount);
            stakes[msg.sender] = 0;
            for(uint256 i = 0; i<stakeholders.length; i++){
                if(stakeholders[i] == msg.sender) {
                    stakeholders[i] = stakeholders[stakeholders.length - 1];
                    stakeholders.pop();
                }
            }
        } else {
            numberOfTokens = numberOfTokens.sub(_tokenAmount);
            stakes[msg.sender] = stakes[msg.sender].sub(_tokenAmount);
        }
    }


    //Read functions to see individual and total amount of stakes.
    function getTotalStakeData() public view returns(uint256) {
        return numberOfTokens;
    }

    function getPersonalStakeData() public view isStakeholder(msg.sender) returns(uint256) {
        return stakes[msg.sender];
    }


    //REWARDING PART 1
    // calculateReward will calculate a single stake's reward.
    //calculateRewards will calculate rewards for all stakes. The owner of the contract
    //will manually call this function to make contract less complex.
    function calculateReward(address _stakeholder) internal view returns(uint256) {
        return stakes[_stakeholder]/100;
    }

    function calculateRewards() public onlyOwner {
        for(uint256 i = 0; i < stakeholders.length; i++) {
            address stakeholder = stakeholders[i];
            uint256 reward = calculateReward(stakeholder);
            rewards[stakeholder] = rewards[stakeholder].add(reward);
        }
    }


    //READING REWARDS
    //function returns the reward amount of an individual stake
    function getReward() public view isStakeholder(msg.sender) returns(uint256) {
        return rewards[msg.sender];
    }

    //Find a stakeholder by index number in the stakeholders array
    function getAddress(uint256 _number) public view returns(address) {
        require(_number < stakeholders.length, "Enter smaller number");
        return stakeholders[_number];
    }

    //There is not a withdraw reward function, as it was not requested by the task paper.

}
