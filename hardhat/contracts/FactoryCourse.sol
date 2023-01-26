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
        address factoryCourseAddress;
        address factoryCourseOwner;
    }

    // searching the struct data of Course and FactoryCourse using owner address
    mapping(address => factoryCourseStruct) public allCourses;

    // onwer address will be used check and get all NFT collection address / contract address created by owner
    // (onwer address => NFT collection address / contract address)
    mapping(address => address[]) public searchByAddress;

    // number of Courses created
    uint256 public numOfCourse;

    /**
     * @dev constructor to set the owner address of this contract factory
     */
    constructor(address _factoryCourseOwner){
        factoryCourseOwner = _factoryCourseOwner;
    }

    /**
     * @dev function to create new NFT collection
     */
    function CreateCourse(string memory _uri, uint256 _supply , uint _nftPrice) public {
        Course course = new Course(
            _uri,
            _supply,
            _nftPrice,
            address(this)
        );
    
        // Increment the number of Course
        numOfCourse++;

        // Add the new Course to the mapping
        allCourses[msg.sender] = (
            factoryCourseStruct(
                _uri,
                _supply,
                _nftPrice,
                address(this),
                factoryCourseOwner
            )
        );
        // search the profile by using creator address
        searchByAddress[msg.sender].push(address(course));
    }

    // function to withdraw the fund from contract factory
    function withdraw(uint256 amount) external payable {
        if(msg.sender != factoryCourseOwner){
            revert ONLY_ONWER_CAN_CALL_FUNCTION();
        }
        if(getContractBalance() < amount){
            revert NOT_ENOUGH_BALANCE();
        }
        // sending money to contract owner
        (bool success, ) = factoryCourseOwner.call{value: amount}("");
        if(!success){
            revert TRANSFER_FAILED();
        }
    }

    // get the balance of the contract
    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // get the address of this contract
    function getAddressOfContract() public view returns (address) {
        return address(this);
    }

    // get the address of FactoryCourse contract owner
    function getAddressOfFactoryCourseOwner() public view returns (address) {
        return factoryCourseOwner;
    }

    // get all the course NFT addresses deployed by creator address
    function getSearchByAddress(address _creatorAddress) public view returns(address[] memory){
        return searchByAddress[_creatorAddress];
    }

    // receive function is used to receive Ether when msg.data is empty
    receive() external payable {}

    // Fallback function is used to receive Ether when msg.data is NOT empty
    fallback() external payable {}
}