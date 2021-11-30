// SPDX-License-Identifier: UNLICENSED (not sure what put)

pragma solidity >=0.4.7 <0.9.0;
import "./SequentialHashing.sol";

contract Referee is HashVerifier{
    //Should be power of 2
    uint8 constant NUM_CHECKPOINTS=1<<3;
    //Has to be even
    uint8 constant NUM_ROUNDS=10;
    uint constant CHALLENGE_RESPONSE_TIMEOUT=5 minutes;
    uint constant CHALLENGE_PERIOD=2 hours;

    struct ChallengeState{
        bool initialized;
        bytes32 firstCheckpoint;
        bytes32 lastCheckpoint;

        bytes32[7] checkpoints;
        uint8 round;
        uint lastChallenge;

    }
    bytes32 private challenge;
    //This stores the challenge and the beacon;
    //TODO: Protect this and beacon getter
    ChallengeState private initialState;

    mapping(address => ChallengeState) private challenges;

    address payable private prover;

    event Challenge(uint8 round, uint8 prevIdx, bytes32[7] checkpoints, address challenger);

    event SubBeacon(bytes32 start, bytes32 beacon, bytes32[7] checkpoints);


    //function RefereeStart() public {
    //    challenge= blockhash(block.number-1);
        //Fix for easier debuging
    //}


    function submitBeacon(bytes32 start, bytes32 _beacon, bytes32[7] memory _checkpoints) public noBeacon{

        initialState=ChallengeState(true,start,_beacon,_checkpoints,0,block.timestamp);
        prover=payable(msg.sender);
	emit SubBeacon(start, _beacon, _checkpoints);
    }

    function postChallenge(uint8 prevIndex,bytes32[7] memory _checkpoints,address challenger) public beaconExists inChallengePeriod  indexInBounds(prevIndex)  {
        ChallengeState memory state=challenges[challenger];

        if(state.initialized==false){
            state=ChallengeState(true,initialState.firstCheckpoint,initialState.lastCheckpoint,initialState.checkpoints,0,block.timestamp);
        }
        if(state.round>=NUM_ROUNDS){
            revert();
        }
        if(state.round%2==0&&msg.sender!=challenger){
            revert();
        }
        if(state.round%2==1&&msg.sender!=prover){
            revert();
        }

        if(prevIndex>0){
            state.firstCheckpoint=state.checkpoints[prevIndex-1];
        }
        if(prevIndex<NUM_CHECKPOINTS-2){
            state.lastCheckpoint=state.checkpoints[prevIndex];
        }
        state.checkpoints=_checkpoints;
        ++state.round;
        state.lastChallenge=block.timestamp;
        challenges[challenger]=state;
	challenges[prover]=state;
        emit Challenge(state.round, prevIndex, _checkpoints, challenger);
    }

    function callTimeout() public {
        ChallengeState memory state=challenges[msg.sender];
        if(state.round%2!=1){
            revert();
        }
        if(block.timestamp-state.lastChallenge>CHALLENGE_RESPONSE_TIMEOUT){
                        selfdestruct(payable(msg.sender));
        }

    }

    function finalChallenge(uint8 prevIndex) public inChallengePeriod indexInBounds(prevIndex)  returns (bool){
        address challenger=msg.sender;
        ChallengeState memory state=challenges[challenger];
        if(state.round!=NUM_ROUNDS){
            revert();
        }

        bytes32 claimedResult;
        bytes32 computedResult;
        bytes32 start;
        if(prevIndex==0){
            start=state.firstCheckpoint;
            claimedResult=state.checkpoints[0];
        }else if(prevIndex==NUM_CHECKPOINTS-2){
            start=state.checkpoints[prevIndex-1];
            claimedResult=state.lastCheckpoint;

        }else{
            start=state.checkpoints[prevIndex-1];
            claimedResult=state.checkpoints[prevIndex];

        }
        bool verified=verify(start,claimedResult);
        if(!verified){

            selfdestruct(payable(challenger));
        }else{
            delete challenges[challenger];
        }
        return verified;



    }

    function getChallenge() public view returns (bytes32){
        return challenge;
    }
      function getBeacon() public view returns (bytes32){
        return initialState.lastCheckpoint;
    }
  function getCheckpoints() public view returns (bytes32[7] memory){
      return challenges[msg.sender].checkpoints;
  }
    function getFirstCheckpoint() public view returns (bytes32){
      return challenges[msg.sender].firstCheckpoint;
  }
   function getLastCheckpoint() public view returns (bytes32){
      return challenges[msg.sender].lastCheckpoint;
  }
    //Modifiers

    modifier noBeacon(){
        if(initialState.initialized==true){
            revert();
        }
        _;
    }
    modifier beaconExists() {
         if(initialState.initialized==false){
            revert();
        }
        _;
    }
    modifier indexInBounds(uint8 prevIndex){
        if(prevIndex>=NUM_CHECKPOINTS-1){
            revert();
        }
        _;
    }
      modifier inChallengePeriod(){
        if(block.timestamp>initialState.lastChallenge+CHALLENGE_PERIOD){
            revert();
        }
        _;
    }









}
