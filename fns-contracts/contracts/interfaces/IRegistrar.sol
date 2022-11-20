// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "../libs/IERC721Enumerable.sol";

interface IRegistrar is IERC721Enumerable {
    event ControllerAdded(address indexed controller);
    event ControllerRemoved(address indexed controller);
    event NameMigrated(uint256 indexed id, address indexed owner, uint256 expires);
    event NameRegistered(uint256 indexed id, address indexed owner, uint256 expires);
    event NameRenewed(uint256 indexed id, uint256 expires);

    // Returns the expiration timestamp of the specified label hash.
    function nameExpires(uint256 id) external view returns (uint256);

    // Returns true iff the specified name is available for registration.
    function available(uint256 id) external view returns (bool);

    // Get the name of a registered id
    function name(uint256 id) external view returns (string memory);

    /**
     * @dev Register a name.
     */
    function register(
        string calldata name,
        address owner,
        uint256 duration,
        address resolver
    ) external returns (uint256);

    function renew(uint256 id, uint256 duration) external returns (uint256);

    /**
     * @dev Reclaim ownership of a name in FNS, if you own it in the registrar.
     */
    function reclaim(uint256 id, address owner) external;
}
