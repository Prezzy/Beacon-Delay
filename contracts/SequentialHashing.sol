// SPDX-License-Identifier: UNLICENSED (not sure what put)

pragma solidity >=0.4.7 <0.9.0;

import "./SequentialFunction.sol";

contract HashVerifier is SequentialFunction{


    function verify(bytes32 x,bytes32 y) internal pure override returns (bool){
         return hash(x)==y;

    }



    //Unrolled loop for speed improvements (48 gas per hash)
    //Returns keccack^1024(x)
    function hash(bytes32 x) public pure returns (bytes32 r){
        assembly{

            let nextFree:=mload(0x40)
            mstore(0x40,add(nextFree,0x20))

            mstore(nextFree,x)
            for {let n:=0} lt(n,10) {n := add(n,1) } {
            	mstore(nextFree,keccak256(nextFree,0x20))
           	 mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
            	mstore(nextFree,keccak256(nextFree,0x20))
	    }
            mstore(nextFree,keccak256(nextFree,0x20))
            mstore(nextFree,keccak256(nextFree,0x20))
            mstore(nextFree,keccak256(nextFree,0x20))

            r:= keccak256(nextFree,0x20)
    }
    }
    }




