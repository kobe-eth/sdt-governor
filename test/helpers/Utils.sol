// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity 0.8.15;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

import {WETH} from "solmate/tokens/WETH.sol";
import {MockERC20, ERC20} from "solmate/test/utils/mocks/MockERC20.sol";
import {SafeTransferLib} from "solmate/utils/SafeTransferLib.sol";
import {FixedPointMathLib} from "solmate/utils/FixedPointMathLib.sol";

interface IWETH {
    function approve(address spender, uint256 amount) external;

    function deposit() external payable;

    function withdraw(uint256 amount) external payable;
}

abstract contract UtilsTest is Test {
    address user = address(this);
    address user1 = address(0xCAFE);
    address user2 = address(0xBEEF);
    address user3 = address(0xCACA0);
}
