// SPDX-Licens-Identifier: UNLICENSED (not sure what put)

pragma solidity >=0.4.7 <0.9.0;
abstract contract SequentialFunction{
    function verify(bytes32 x,bytes32 y) internal virtual returns (bool);
}
