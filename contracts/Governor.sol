// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

import {GaugeController} from "contracts/interfaces/GaugeController.sol";

/// @notice SDT Gauge Controller Governor.
/// @author StakeDAO.
contract Governor {
    GaugeController public constant gaugeController = GaugeController(0x3F3F0776D411eb97Cfa4E3eb25F33c01ca4e7Ca8);
    address public governance = 0xF930EBBd05eF8b25B1797b9b2109DDC9B0d43063;

    ////////////////////////////////////////////////////////////////
    /// --- GAUGE CONTROLLER LOGIC
    ////////////////////////////////////////////////////////////////

    function addGauges(address[] calldata gauges) external {
        require(msg.sender == governance, "!governance");
        uint256 length = gauges.length;

        for (uint256 i; i < length; ++i) {
            gaugeController.add_gauge(gauges[i], 0, 0);
        }
    }

    function changeGaugesWeight(address[] calldata gauges, uint256[] calldata weights) external {
        require(msg.sender == governance, "!governance");
        require(gauges.length == weights.length, "wrong lenght");

        uint256 length = gauges.length;
        for (uint256 i; i < length; ++i) {
            gaugeController.change_gauge_weight(gauges[i], weights[i]);
        }
    }

    /// @notice execute a function
    /// @param _to Address to sent the value to
    /// @param _value Value to be sent
    /// @param _data Call function data
    function execute(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external returns (bool, bytes memory) {
        require(msg.sender == governance, "!governance");
        (bool success, bytes memory result) = _to.call{value: _value}(_data);
        return (success, result);
    }

    ////////////////////////////////////////////////////////////////
    /// --- GOVERNANCE LOGIC
    ////////////////////////////////////////////////////////////////

    function transferControllerOwnership(address _admin) external {
        require(msg.sender == governance, "!governance");
        gaugeController.commit_transfer_ownership(_admin);
    }

    function acceptControllerOwnership() external {
        require(msg.sender == governance, "!governance");

        address future_admin = gaugeController.future_admin();
        require(future_admin == address(this), "Wrong future_admin");

        gaugeController.accept_transfer_ownership();
    }

    function setGovernance(address _newGovernance) external {
        require(msg.sender == governance, "!governance");
        governance = _newGovernance;
    }
}
