// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./libs/ERC165.sol";
import "./resolvers/IVersionableResolver.sol";

abstract contract ResolverBase is ERC165, IVersionableResolver {
    mapping(bytes32 => uint64) public recordVersions;

    function isAuthorised(bytes32 node) internal view virtual returns (bool);

    modifier authorised(bytes32 node) {
        require(isAuthorised(node));
        _;
    }

    /**
     * Increments the record version associated with an FNS node.
     * May only be called by the owner of that node in the FNS registry.
     * @param node The node to update.
     */
    function clearRecords(bytes32 node) public virtual authorised(node) {
        recordVersions[node]++;
        emit VersionChanged(node, recordVersions[node]);
    }

    function supportsInterface(bytes4 interfaceID) public view virtual override returns (bool) {
        return interfaceID == type(IVersionableResolver).interfaceId || super.supportsInterface(interfaceID);
    }
}
