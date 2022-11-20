// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

interface INameResolver {
    event NameChanged(bytes32 indexed node, string name);

    /**
     * Returns the name associated with an FNS node, for reverse records.
     * Defined in EIP181.
     * @param node The FNS node to query.
     * @return The associated name.
     */
    function name(bytes32 node) external view returns (string memory);
}
