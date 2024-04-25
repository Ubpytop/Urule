// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartDemocracy {
    address public owner; // Address of the contract owner
    mapping(address => bool) public voters; // Mapping of authorized voters
    mapping(address => bool) public candidateRegistered; // Mapping of registered candidates
    mapping(address => uint256) public candidateVotes; // Mapping of votes received by candidates
    mapping(address => string) public candidateLegislation; // Mapping of proposed legislation by candidates
    mapping(address => string) public candidateMedia; // Mapping of media platforms or campaign messages by candidates
    uint256 public totalVotes; // Total number of votes casted

    event VoterAdded(address indexed voter); // Event emitted when a voter is added
    event CandidateRegistered(address indexed candidate); // Event emitted when a candidate is registered
    event VoteCasted(address indexed voter, address indexed candidate); // Event emitted when a vote is casted
    event MediaUpdated(address indexed candidate, string media); // Event emitted when a candidate updates their media

    /**
     * @dev Constructor function to set the contract owner.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev Modifier to restrict access to the contract owner only.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    /**
     * @dev Adds a voter to the list of authorized voters.
     * @param _voter The address of the voter to be added.
     */
    function addVoter(address _voter) external onlyOwner {
        voters[_voter] = true;
        emit VoterAdded(_voter);
    }

    /**
     * @dev Registers a candidate for election.
     * @param _legislation The candidate's proposed legislation.
     * @param _media The candidate's media platform or campaign message.
     */
    function registerCandidate(string memory _legislation, string memory _media) external {
        require(!candidateRegistered[msg.sender], "Candidate already registered");
        candidateRegistered[msg.sender] = true;
        candidateLegislation[msg.sender] = _legislation;
        candidateMedia[msg.sender] = _media;
        emit CandidateRegistered(msg.sender);
    }

    /**
     * @dev Updates candidate's media information.
     * @param _media The candidate's updated media platform or campaign message.
     */
    function updateMedia(string memory _media) external {
        require(candidateRegistered[msg.sender], "Candidate not registered");
        candidateMedia[msg.sender] = _media;
        emit MediaUpdated(msg.sender, _media);
    }

    /**
     * @dev Casts a vote for a candidate.
     * @param _candidate The address of the candidate being voted for.
     */
    function vote(address _candidate) external {
        require(voters[msg.sender], "You are not authorized to vote");
        require(candidateRegistered[_candidate], "Candidate not registered");
        candidateVotes[_candidate]++;
        totalVotes++;
        emit VoteCasted(msg.sender, _candidate);
    }

    /**
     * @dev Retrieves the vote count for a specific candidate.
     * @param _candidate The address of the candidate.
     * @return The number of votes received by the candidate.
     */
    function getVoteCount(address _candidate) external view returns (uint256) {
        require(candidateRegistered[_candidate], "Candidate not registered");
        return candidateVotes[_candidate];
    }
}