// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.15;

interface GaugeController {
    function accept_transfer_ownership() external;

    function admin() external view returns (address);

    function future_admin() external view returns (address);

    function commit_transfer_ownership(address addr) external;

    function gauge_types(address addr) external view returns (int128);

    function vote_for_gauge_weights(address, uint256) external;

    function change_gauge_weight(address addr, uint256 weight) external;

    function add_gauge(
        address addr,
        int128 gauge_type,
        uint256 weight
    ) external;
}
