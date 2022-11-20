//SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./IPriceOracle.sol";

interface IRegistrarController {
    function valid(string memory name) external view returns (bool);

    function available(string memory name) external view returns (bool);

    function nameExpires(string memory name) external view returns (uint256);

    function rentPrice(string memory name, uint256 duration) external view returns (IPriceOracle.Price memory);

    function register(
        string calldata name,
        address owner,
        uint256 duration,
        address resolver,
        bytes[] calldata data,
        bool reverseRecord
    ) external payable;

    function renew(string calldata name, uint256 duration) external payable;
}
