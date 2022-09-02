// SPDX-License-Identifier: MIT

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically by Remix.

contract Bank {
    bool internal locked;

    modifier noReentrant() {
        require(!locked, "NO NO");
        locked = true;
        _;
        locked = false; // executes after function has finished.
    }

    mapping(address => uint256) public balances;

    // icrease the amount that each address has
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // requires the address in question to have more than a balance
    // of zero and sends the money and sets the balance
    function withdraw() public noReentrant {
        uint256 bal = balances[msg.sender];
        require(bal > 0);

        balances[msg.sender] = 0;

        (bool sent, ) = msg.sender.call{value: bal}("");

        require(sent, "Failed to send Ether");
    }
}
