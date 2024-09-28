// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ArbBridge {
    // will use a basic balance check on source and destination
    mapping(address => uint256) tokenBalanceMapping;

    // function initialize() public initializer {
    //     tokenBalanceMapping[address(0)] = address(this).balance;
    // }

    function incrementBalance(address tokenAddress, uint256 amount) internal {
        tokenBalanceMapping[tokenAddress] += amount;
    }

    function transferERC20(address erc20TokenAddr, uint256 amount) private returns (uint256 totalWithdrawn) {
        IERC20 token = IERC20(erc20TokenAddr);
        // Request approval
        require(token.approve(msg.sender, amount), "Err approving withdrawal");
        // withdraw token from user
        token.transferFrom(msg.sender, address(this), amount);
        totalWithdrawn = amount;
    }

    function mint(address erc20TokenAddr, uint256 amount) public payable {
        // require amount is sent
        // burn token
        if (erc20TokenAddr == address(0)) {} else {
            IERC20 token = IERC20(erc20TokenAddr);
            token._burn(msg.sender, amount);
        }
    }
}
