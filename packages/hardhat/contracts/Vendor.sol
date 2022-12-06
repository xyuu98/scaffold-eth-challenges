pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(
        address seller,
        uint256 amountOfTokens,
        uint256 amountOfETH
    );

    uint256 public constant tokensPerEth = 100;

    YourToken public yourToken;

    constructor(address tokenAddress) {
        yourToken = YourToken(tokenAddress);
    }

    // ToDo: create a payable buyTokens() function:
    function buyTokens() public payable {
        yourToken.transfer(msg.sender, msg.value * tokensPerEth);
        emit BuyTokens(msg.sender, msg.value, msg.value * tokensPerEth);
    }

    // ToDo: create a withdraw() function that lets the owner withdraw ETH
    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "Not Enough ETH");
        msg.sender.call{value: address(this).balance}("");
    }

    // ToDo: create a sellTokens(uint256 _amount) function:
    function sellTokens(uint256 _amount) external {
        yourToken.transferFrom(msg.sender, address(this), _amount);
        msg.sender.call{value: _amount / tokensPerEth}("");
        emit SellTokens(msg.sender, _amount, _amount / tokensPerEth);
    }
}
