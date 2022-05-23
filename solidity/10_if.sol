// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

/*
Pure functions ensure that they not read or modify the state. 
A function can be declared as pure. 
The following statements if present in the function are considered reading the state and compiler will throw warning in such cases.
*/
contract IfElse{
    function foo(uint x ) public pure returns (uint){
        if(x < 10){
            return 0;
        }else if(x < 20){
            return 1;
        }else{
            return 2;
        }
    }
    function ternary(uint _x) public pure returns(uint){
        return _x < 10 ? 1: 2;
    }
}