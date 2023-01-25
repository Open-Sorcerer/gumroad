// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Course.sol";

contract FactoryCourse{
    // factory contract onwer
    address private factoryCourseOwner;

    // struct to store all the data of Course ( string uri uint supply uint nftPrice) and FactoryCourse(address factoryCourseOwner) contract
    struct factoryCourseStruct {
        string uri;
        uint supply;
        uint nftPrice;
        address factoryCourseOwner;
    }

    // number of Courses created
    uint256 public numOfCourse;

    constructor(address _factoryCourseOwner){
        factoryCourseOwner = _factoryCourseOwner;

    }

    function CreateCourse(string memory _uri, uint256 _supply , uint _nftPrice) public {
        Course course = new Course(
            _uri,
            _supply,
            _nftPrice
        );
    
        // Increment the number of MultiSigWallet
        numOfCourse++;



    }

}