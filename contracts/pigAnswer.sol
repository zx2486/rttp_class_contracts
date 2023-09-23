// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./2_Owner.sol";

/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract pig is Owner {
    //And we made pig contract extends Owner, so inside this contract we can use the functions in Owner contract
    uint256 number = 10; //Let us start with 10 credits in this storage

    /**
     * @dev Store value in variable
     * @param num value to store
     */
    function store(uint256 num) public isOwner {
        //number = num;
        number = number + num; //The number will become number + num
    }

    /**
     * @dev Return value
     * @return value of 'number'
     */
    function get() public view returns (uint256) {
        return number; //Tell others the current balance
    }

    function double() public view returns (uint256) {
        uint256 bigNumber = number * 2; //big number will be number *2;
        return bigNumber;
    }

    function take(uint256 num) public isOwner {
        number = number - num; //The number will become number - num
    }
}
