// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract Lottery is VRFConsumerBaseV2 {
    address private owner;
    uint256 constant TICKETPRICE = 0.1 ether;
    mapping(address => uint256) public participantTickets;
    address[] private participantList;
    uint256 public totalTickets;

    VRFCoordinatorV2Interface private immutable vrfCoordinator;
    bytes32 private immutable keyHash;
    uint64 private immutable subscriptionId;

    uint256 private requestId;
    uint256 private randomWord;

    event TicketPurchased(address indexed buyer, uint256 ticketNumber);
    event WinnerSelected(address indexed winner, uint256 prizeMoney);
    event RandomNumberRequest(uint256 requestId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier validTicketPurchase() {
        require(msg.value == TICKETPRICE, "Please send exactly 0.1 ether");
        _;
    }

    constructor(
        address _vrfCoordinator,
        bytes32 _keyHash,
        uint64 _subscriptionId
    ) VRFConsumerBaseV2(_vrfCoordinator) {
        require(
            _vrfCoordinator != address(0),
            "Invalid VRF Coordinator address"
        );
        require(_keyHash != bytes32(0), "Invalid key hash");
        require(_subscriptionId > 0, "Invalid subscription ID");

        owner = msg.sender;
        vrfCoordinator = VRFCoordinatorV2Interface(_vrfCoordinator);
        keyHash = _keyHash;
        subscriptionId = _subscriptionId;
    }

    function buyTicket() public payable validTicketPurchase {
        require(
            participantTickets[msg.sender] == 0,
            "You already bought a ticket"
        );

        totalTickets++;
        participantTickets[msg.sender] = totalTickets;
        participantList.push(msg.sender);

        emit TicketPurchased(msg.sender, totalTickets);
    }

    function getAllParticipants() public view returns (address[] memory) {
        return participantList;
    }

    function requestRandomness() public onlyOwner {
        require(participantList.length > 0, "No participants in the list");
        requestId = vrfCoordinator.requestRandomWords(
            keyHash,
            subscriptionId,
            3, // Confirmations
            100000, // Callback gas limit
            1 // Number of words
        );
        emit RandomNumberRequest(requestId);
    }

    function fulfillRandomWords(
        uint256,
        uint256[] memory randomWords
    ) internal override {
        randomWord = randomWords[0];
        selectWinner();
    }

    function selectWinner() private {
        require(
            address(this).balance >= totalTickets * TICKETPRICE,
            "Insufficient funds for payout"
        );
        uint256 winnerIndex = randomWord % totalTickets;
        address winnerAddress = participantList[winnerIndex];
        uint256 prizeMoney = address(this).balance;

        payable(winnerAddress).transfer(prizeMoney);
        emit WinnerSelected(winnerAddress, prizeMoney);

        resetLottery();
    }

    function resetLottery() private {
        delete participantList;
        totalTickets = 0;
    }
}
