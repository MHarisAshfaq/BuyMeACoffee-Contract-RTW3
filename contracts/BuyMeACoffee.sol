//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract BuyMeACoffee {
    // Event to emit on new Memo
    event NewMemo(
        address indexed from,
        uint timestamp,
        string name,
        string message
    );

    // Memo struct
    struct Memo {
        address from;
        uint timestamp;
        string name;
        string message;
    }

    // Address of the contract deployer
    // Marked so that we can withdraw to this address
    address payable owner;

    // list of all memos received from coffee purchase
    Memo[] memos;

    constructor(){
        // store the address of deployer as payable
        // when we withdraw funds, we will withdraw here
        owner = payable(msg.sender);
    }

    /**
     * @dev buy coffee for owner (send an ETH tip and leaves a memo)
     * @param _name name of the coffee purchaser
     * @param _message a nice message from the purchaser
     */
    function buyCoffee(string memory _name, string memory _message) public payable {
        // must accept ETH more than 0
        require(msg.value > 0, "amount should be greater than zero");
        // add memo to storage
        memos.push(Memo(msg.sender,block.timestamp,_name,_message));
        // Emit a NewMemo event with details about the memo
        emit NewMemo(msg.sender,block.timestamp,_name,_message);
    }

    /**
    * @dev fetches all stored memos
    */
    function getMemos() public view returns(Memo[] memory){
        return memos;
    }

    /**
     * @dev send entire balance in this contract to the owner
     */
    function withdrawTips() public {
        require(owner.send(address(this).balance));
    }
}
