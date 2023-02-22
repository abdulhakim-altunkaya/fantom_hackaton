//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/b2970b96e5e2be297421cd7690e3502e49f7deff/contracts/token/ERC20/IERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/b2970b96e5e2be297421cd7690e3502e49f7deff/contracts/utils/Counters.sol";

contract Foundation {
    //1.OWNER CODE BLOCK
    //"owner" of the contract has "secretarial" role
    address internal owner;
    error NotOwner(string message, address caller);
    modifier onlyOwner(){
        if(msg.sender != owner) {
            revert NotOwner("you are not owner",  msg.sender);
        }
        _;
    }
    constructor() {
        owner = msg.sender;
    }
    function renounceOwnership(address _newOwner) external onlyOwner {
        owner = _newOwner;
    }

    // 2. KEY STATE VARIABLES
    mapping(address => bool) public memberMapping;
    address[] internal memberArray;

    //3.BECOMING A MEMBER
    //3.1 Membership Check
    modifier onlyMember(){
        bool status;
        for(uint i=0; i <memberArray.length; i++) {
            if(memberArray[i] == msg.sender) {
                status = true;
            }
        }
        require(status == true, "you are not a member");
        _;
    }

    //3.2 Membership Function
    // To become a member, people need to pay 10 Aurora Token to this contract.
    //However, the payment part will be disabled so that Hackaton evaluators can test contract.
    //Aurora coin address is hardcoded here, however, in future version, it can replaced with NEAR coin.
    function becomeMember() external payable {
        bool status = false;
        for(uint i=0; i<memberArray.length; i++) {
            if(memberArray[i] == msg.sender) {
                status = true;
            }
        }
        require(status == false, "you are already a member");
        //IERC20 auroraCoin = IERC20(0x8bec47865ade3b172a928df8f990bc7f2a3b9f79);
        //uint _amount = 10*(10**18); 
        //auroraCoin.transfer(address(this), _amount);
        memberArray.push(msg.sender);
        memberMapping[msg.sender] = true;
    }

    //4.FOUNDATION GRANT & CHARITY PROGRAM
    //4.1 Key Variables
    using Counters for Counters.Counter;
    Counters.Counter private _programIdCounter;
    string[] internal waitingProposals;
    string[] internal proposalPassed; 
    string[] internal proposalRejected;
    string internal mainProposal;

    //4.2 proposal submission function. Only Members
    function makeProgramProposal(string calldata _programName) external onlyMember {
        waitingProposals.push(_programName);
    } 

    //5.2VOTING INITIATION CONTRACT
    //Main Proposal is chosen according to whatever comes first principle. That's why it is waitingProposals[0]
    //onlyOwner is disabled so that hackaton evaluators can call this function
    uint public votingStartTime;
    function chooseMainProposal() external /*onlyOwner*/ {
        mainProposal = waitingProposals[0];
        for(uint i = 0; i < waitingProposals.length-1; i++) {
            waitingProposals[i] = waitingProposals[i+1];
        }
        waitingProposals.pop();
        votingStartTime = block.timestamp;
    }


    //6.VIEW FUNCTIONS:
    //6.1 waiting, passed, rejected proposals
    function getAllPro() external view returns(string[] memory) {
        return waitingProposals;
    }
    function getAllProPassed() external view returns(string[] memory) {
        return proposalPassed;
    }
    function getAllProRejected() external view returns(string[] memory) {
        return proposalRejected;
    }
    function getMembershipStatus() external view returns(string memory) {
        if(memberMapping[msg.sender] == true) {
            return "you are member";
        } else {
            return "you are not member";
        }
    }

    //6.2 balance of the contract
    function getBalance() external view returns(uint) {
        return (address(this).balance);
    }

    //6.3 contract address and owner
    function getDetails() external view returns(address, address) {
        return(owner, address(this));
    }

    //7. VOTING PROCESS ON THE MAIN PROPOSAL
    //y: yes votes, n: no votes
    uint internal y;
    uint internal n;
    mapping(address => bool) public votingStatus;
    address[] internal voters;
    function voteYes() external onlyMember {
        require(votingStatus[msg.sender] == false, "you have already voted");
        require(block.timestamp < votingStartTime + 20 minutes, "voting period has ended");
        votingStatus[msg.sender] = true;
        voters.push(msg.sender);
        y++;
    }
    function voteNo() external onlyMember {
        require(votingStatus[msg.sender] == false, "you have already voted");
        require(block.timestamp < votingStartTime + 20 minutes, "voting period has ended");
        votingStatus[msg.sender] = true;
        voters.push(msg.sender);
        n++;
    }
    function getVotingStatus() external view returns(bool) {
        return votingStatus[msg.sender];
    }

    //9. VOTING RESULTS OF THE MAIN PROPOSAL
    //this struct is to save voting results in resultsMapping after closing the voting.
    // And getRecordStruct function is used to details of a voting session.
    struct ResultStruct {
        string proposalName;
        uint yesV;
        uint noV;
        uint totalV;
    }
    ResultStruct record;
    mapping(uint => ResultStruct) internal resultsMapping;

    function getRecordStruct(uint id) external view returns(ResultStruct memory) {
        return resultsMapping[id];
    }

    //8.CLOSING VOTING SESSION
    //no need to reset votingStartTime here. 
    function closeVoting() external /*onlyOwner*/ {
        uint totalVotes = y + n;
        uint percentage1 = y*100;
        uint percentage2 = percentage1/totalVotes;
        if(percentage2 >= 60) {
            proposalPassed.push(mainProposal);
        } else {
            proposalRejected.push(mainProposal);
        }
        record = ResultStruct(mainProposal, y, n, totalVotes);
        uint programId = _programIdCounter.current();
        _programIdCounter.increment();
        resultsMapping[programId] = record;
    }
    //reset the table for next voting
    function resetTable() external /*onlyOwner*/ {
        n=0;
        y=0;
        mainProposal = "";
        for(uint i=0; i <voters.length; i++) {
            votingStatus[voters[i]] = false;
        }
        delete voters;
    }
    


    //12. GRANT RECIPIENTS
    //Recipients will receive their grants in AURORA token
    //Therefore we are hardcoding AURORA address here. However, in future it can replaced with NEAR token.
    address[] internal grantRecipientsArray;
    mapping(address => uint) grantRecipientMapping;
    error AlreadyBeneficiary(string message, address beneficiary);
    modifier isBeneficiary(address _beneficiary) {
        for(uint i=0; i<grantRecipientsArray.length; i++) {
            if(grantRecipientsArray[i] == _beneficiary) {
                revert AlreadyBeneficiary("already beneficiary", _beneficiary);
            }
        }
        _;
    }
    function addBeneficiary(address _receiver) external /*onlyOwner*/ isBeneficiary(_receiver) {
        grantRecipientsArray.push(_receiver);
    }
    function sendGrant(address _receiver, uint _amount) external onlyOwner {
        require(transferEnabled == true, "transfer is disabled");
        IERC20 token = IERC20(0x8bec47865ade3b172a928df8f990bc7f2a3b9f79);
        token.transfer(_receiver, _amount);
        grantRecipientMapping[_receiver] += _amount;
    }
    function sendGrantAuto(uint _amount) external onlyOwner {
        require(transferEnabled == true, "transfer is disabled");
        IERC20 token = IERC20(0x8bec47865ade3b172a928df8f990bc7f2a3b9f79);
        for(uint i=0; i<grantRecipientsArray.length; i++) {
            token.transfer(grantRecipientsArray[i], _amount);
            grantRecipientMapping[grantRecipientsArray[i]] += _amount;
        }
    }



    //15. SAFETY PRECAUTION FOR TRANSFER FUNCTIONS
    bool public transferEnabled =  false;
    function toggleTransfer() external onlyOwner {
        transferEnabled = !transferEnabled;
    }

    //10. LEAVING THE MEMBERSHIP
    //we are removing the msg.sender in an orderly way.
    function leaveMembership() external onlyMember {
        uint memberIndex;
        for(uint i=0; i<memberArray.length; i++) {
            if(memberArray[i] == msg.sender) {
                memberIndex = i;
                break;
            }
        }
        for(uint i = memberIndex; i < memberArray.length -1; i++) {
            memberArray[i] = memberArray[i+1];
        }
        memberArray.pop();
        memberMapping[msg.sender] = false;
    }

    //11. REMOVING ANY MEMBER 
    //owner can remove a member to prevent exploitation
    function removeMember(address _member) external onlyOwner {
        uint memberIndex;
        for(uint i=0; i<memberArray.length; i++) {
            if(memberArray[i] == _member) {
                memberIndex = i;
                break;
            }
        }
        for(uint i = memberIndex; i < memberArray.length -1; i++) {
            memberArray[i] = memberArray[i+1];
        }
        memberArray.pop();
        memberMapping[_member] = false;
    }

    //owner can withdraw all the ether inside the contract
    function withdraw() external onlyOwner {
        require(transferEnabled == true, "transfer is disabled");
        (bool success, ) = owner.call{value: address(this).balance}("");
        require(success, "you are not owner");
    }


    fallback() external payable {}
    receive() external payable {}



}