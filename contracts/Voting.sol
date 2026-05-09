// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {

    address public electionCommission;

    struct Voter {
        string name;
        uint age;
        bool voted;
        uint vote;
    }

    struct Candidate {
        uint id;
        string name;
        string party;
        uint voteCount;
    }

    uint public candidatesCount;
    uint public votersCount;

    mapping(address => Voter) public voters;
    mapping(uint => Candidate) public candidates;

    event votedEvent(uint indexed candidateId);

    constructor() {
        electionCommission = msg.sender;
    }

    // REGISTER CANDIDATE
    function addCandidate(
        string memory _name,
        string memory _party
    ) public {

        candidatesCount++;

        candidates[candidatesCount] = Candidate(
            candidatesCount,
            _name,
            _party,
            0
        );
    }

    // REGISTER VOTER
    function registerVoter(
        string memory _name,
        uint _age
    ) public {

        require(_age >= 18, "Must be 18+");

        voters[msg.sender] = Voter(
            _name,
            _age,
            false,
            0
        );

        votersCount++;
    }

    // VOTE
    function vote(uint _candidateId) public {

        require(!voters[msg.sender].voted, "Already voted");

        require(
            _candidateId > 0 &&
            _candidateId <= candidatesCount,
            "Invalid candidate"
        );

        voters[msg.sender].voted = true;

        voters[msg.sender].vote = _candidateId;

        candidates[_candidateId].voteCount++;

        emit votedEvent(_candidateId);
    }

    // GET WINNER
    function getWinner() public view returns (string memory) {

        uint winningVoteCount = 0;
        uint winningCandidateId = 0;

        for(uint i = 1; i <= candidatesCount; i++) {

            if(candidates[i].voteCount > winningVoteCount) {

                winningVoteCount = candidates[i].voteCount;

                winningCandidateId = i;
            }
        }

        return candidates[winningCandidateId].name;
    }
}