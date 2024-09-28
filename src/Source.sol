// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "./lib/Utils.sol";

/**
 * @title Source bridge contract
 * @author xpanvictor
 * @notice Imp
 * The contract needs some form of queue to ensure a FIFO batch of txns to be handled,
 * this way, we can avoid skipped txns.
 */
contract EthBridge is Initializable, OwnableUpgradeable {
    // will use a basic balance check on source and destination
    mapping(address => uint256) tokenBalanceMapping;

    function initialize() public initializer {
        tokenBalanceMapping[address(0)] = address(this).balance;
    }

    function incrementBalance(address tokenAddress, uint256 amount) internal {
        tokenBalanceMapping[tokenAddress] += amount;
    }

    function bridge(address baseToken, uint256 amount) public payable {
        // separate zero address
        if (baseToken == address(0)) {
            // native token mint
            amount = msg.value;
        } else {
            amount = BridgertonUtils.transferERC20(baseToken, amount);
        }
        // TODO: proceed with event logging
        incrementBalance(baseToken, amount);
    }

    // Withdraw fn through owner only
    function withdraw(address baseToken, address to, uint256 amount) public onlyOwner {}
}
