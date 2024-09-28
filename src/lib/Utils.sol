// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.26;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

library BridgertonUtils {
    function transferERC20(address erc20TokenAddr, uint256 amount) internal returns (uint256 totalWithdrawn) {
        ERC20Upgradeable token = ERC20Upgradeable(erc20TokenAddr);
        // Request approval
        require(token.approve(msg.sender, amount), "Err approving withdrawal");
        // withdraw token from user
        token.transferFrom(msg.sender, address(this), amount);
        totalWithdrawn = amount;
    }
}
