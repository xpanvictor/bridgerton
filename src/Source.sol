// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.13;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract EthBridge is Initializable, OwnableUpgradeable {
    function initialize() public initializer {}

    function withdrawERC20(address erc20TokenAddr, uint256 amount) private returns (uint256 totalWithdrawn) {
        ERC20Upgradeable token = ERC20Upgradeable(erc20TokenAddr);
        // Request approval
        require(token.approve(msg.sender, amount), "Err approving withdrawal");
        // withdraw token from user
        token.transferFrom(msg.sender, address(this), amount);
        totalWithdrawn = amount;
    }

    function bridge(address baseToken, uint256 amount) public payable {
        // separate zero address
        if (baseToken == address(0)) {
            // native token mint
            amount = msg.value;
        } else {
            amount = withdrawERC20(baseToken, amount);
        }
        // proceed with event logging
    }
}
