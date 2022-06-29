// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.15;

import "contracts/Governor.sol";
import "test/helpers/Constant.sol";
import {UtilsTest} from "test/helpers/Utils.sol";

contract GovernorTest is UtilsTest {
    Governor governor;
    GaugeController gaugeController;

    function setUp() public {
        governor = new Governor();
        gaugeController = GaugeController(MainnetAddresses.GAUGE_CONTROLLER);

        // Transfer Ownership
        vm.prank(gaugeController.admin());
        gaugeController.commit_transfer_ownership(address(governor));

        vm.prank(governor.governance());
        governor.acceptControllerOwnership();
    }

    function testInit() public {
        assertEq(governor.governance(), MainnetAddresses.STAKE_DAO_MULTISIG_2);
        assertEq(address(governor.gaugeController()), address(gaugeController));
    }

    function testAddMultipleGauges() public {
        address[] memory fakeGauges = new address[](2);
        fakeGauges[0] = address(0xCAFE);
        fakeGauges[1] = address(0xBEEF);

        // Since Gauge isn't added, those should revert.
        vm.expectRevert();
        gaugeController.gauge_types(address(0xCAFE));

        vm.expectRevert();
        gaugeController.gauge_types(address(0xBEEF));

        // Impersonate Multisig.
        vm.prank(governor.governance());
        governor.addGauges(fakeGauges);

        // Confirm that gauges were added by checking types, should not revert.
        assertEq(gaugeController.gauge_types(address(0xCAFE)), 0);
        assertEq(gaugeController.gauge_types(address(0xBEEF)), 0);
    }

    function testAddGaugesPrivilegeWithRandomAddress() public {
        address[] memory fakeGauges = new address[](2);
        fakeGauges[0] = address(0xCAFE);
        fakeGauges[1] = address(0xBEEF);

        vm.expectRevert("!governance");
        governor.addGauges(fakeGauges);

        vm.expectRevert("!governance");
        governor.execute(address(0xCAFE), 0, "");

        vm.expectRevert("!governance");
        governor.transferControllerOwnership(address(0xCAFE));

        vm.expectRevert("!governance");
        governor.setGovernance(address(0xCAFE));

        vm.expectRevert("!governance");
        governor.acceptControllerOwnership();
    }

    function testSetGovernanceAddress() public {
        // Impersonate Multisig.
        vm.prank(governor.governance());
        governor.setGovernance(address(0xCAFE));

        assertEq(governor.governance(), address(0xCAFE));
    }

    function testTransferControllerOwnership() public {
        // Impersonate Multisig.
        vm.prank(governor.governance());
        governor.transferControllerOwnership(address(0xCAFE));

        assertEq(gaugeController.future_admin(), address(0xCAFE));

        vm.prank(address(0xCAFE));
        gaugeController.accept_transfer_ownership();

        assertEq(gaugeController.admin(), address(0xCAFE));
    }
}
