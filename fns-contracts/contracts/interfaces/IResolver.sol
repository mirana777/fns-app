//SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "../libs/IERC165.sol";
import "../resolvers/IAddressResolver.sol";
import "../resolvers/IContentHashResolver.sol";
import "../resolvers/INameResolver.sol";
import "../resolvers/ITextResolver.sol";

/**
 * A generic resolver interface which includes all the functions including the ones deprecated
 */
interface IResolver is IERC165, IAddressResolver, IContentHashResolver, INameResolver, ITextResolver {
    function setAddr(bytes32 node, address addr) external;

    function setAddr(
        bytes32 node,
        uint256 coinType,
        bytes calldata a
    ) external;

    function setContenthash(bytes32 node, bytes calldata hash) external;

    function setName(bytes32 node, string calldata _name) external;

    function setText(
        bytes32 node,
        string calldata key,
        string calldata value
    ) external;

    function multicall(bytes[] calldata data) external returns (bytes[] memory results);

    function multicallWithNodeCheck(bytes32 nodehash, bytes[] calldata data) external returns (bytes[] memory results);

    function multihash(bytes32 node) external view returns (bytes memory);

    function setContent(bytes32 node, bytes32 hash) external;

    function setMultihash(bytes32 node, bytes calldata hash) external;
}
