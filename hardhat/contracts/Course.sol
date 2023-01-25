// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

error NFT_SOLD_OUT();
error SEND_SUFFICENT_FIL();
error ONLY_ONWER_CAN_CALL_FUNCTION();

contract Course is ERC1155 { 
    // variable to store maximum number of NFT 
    uint public maxSupply;
    // counter to keep track how many NFT are minted
    uint public counter;
    // variable to store the NFT Price;
    uint public nftPrice;
    // variable to store factoryContract Address
    address payable factoryContractAddress;
    // variable to store onwer Address
    address payable owner;

    /**
     * @dev contructor to set the _uri(metadata), maxSupply , Price of NFT 
     * @param _uri get the metadata of NFT
     * @param _supply get the maxSupply, total number of NFT
     * @param _nftPrice get the price of NFT
     */
    constructor(string memory _uri, uint256 _supply , uint _nftPrice, address _factoryContractAddress) ERC1155(_uri){
        _setURI(_uri);
        maxSupply = _supply;
        nftPrice = _nftPrice;
        factoryContractAddress = payable(_factoryContractAddress);
        owner = payable(msg.sender);
    }

    /**
     * @dev nftMint() function to mint and sell 1 NFT
     */
    function nftMint() public payable{
        if(counter+1 > maxSupply){
            revert NFT_SOLD_OUT();
        }
        if(msg.value < nftPrice) {
            revert SEND_SUFFICENT_FIL();
        }
        counter++;
        _mint(msg.sender, 0 , 1, "");
    }

    /**
     * @dev supportCreator() function to mint and sell as many NFT user want NFT
     * @param _num get the amount of NFT user want to mint and BUY
     */
    function supportCreator(uint _num) public payable{
        if(counter + _num > maxSupply){
            revert NFT_SOLD_OUT();
        }
        if(msg.value < nftPrice * _num) {
            revert SEND_SUFFICENT_FIL();
        }
        counter += _num;
        _mint(msg.sender, 0 , _num, "");
    }

    function withdraw() public payable{
         if(msg.sender != owner){
            revert ONLY_ONWER_CAN_CALL_FUNCTION();
        }
        if(getContractBalance() < amount){
            revert NOT_ENOUGH_BALANCE();
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
    

    // receive function is used to receive Ether when msg.data is empty
    receive() external payable {}

    // Fallback function is used to receive Ether when msg.data is NOT empty
    fallback() external payable {}
}

//! no need to add total supply - as even roadgum have one, if a course is good they should be allowed to sell/mint as many nft they want
