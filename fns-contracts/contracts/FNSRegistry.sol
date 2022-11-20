// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./interfaces/FNS.sol";

/**
 * The FNS registry contract.
 */
contract FNSRegistry is FNS {
    struct Record {
        address owner;
        address resolver;
        uint64 ttl;
    }

    mapping(bytes32 => Record) public records;
    mapping(address => mapping(address => bool)) operators;

    // Permits modifications only by the owner of the specified node.
    modifier authorised(bytes32 node) {
        address rOwner = records[node].owner;
        require(rOwner == msg.sender || operators[rOwner][msg.sender]);
        _;
    }

    /**
     * @dev Constructs a new FNS registry.
     */
    constructor() {
        records[0x0].owner = msg.sender;
    }

    /**
     * @dev Sets the record for a node.
     * @param node The node to update.
     * @param _owner The address of the new owner.
     * @param _resolver The address of the resolver.
     * @param _ttl The TTL in seconds.
     */
    function setRecord(
        bytes32 node,
        address _owner,
        address _resolver,
        uint64 _ttl
    ) external virtual override {
        setOwner(node, _owner);
        _setResolverAndTTL(node, _resolver, _ttl);
    }

    /**
     * @dev Sets the record for a subnode.
     * @param node The parent node.
     * @param label The hash of the label specifying the subnode.
     * @param _owner The address of the new owner.
     * @param _resolver The address of the resolver.
     * @param _ttl The TTL in seconds.
     */
    function setSubnodeRecord(
        bytes32 node,
        bytes32 label,
        address _owner,
        address _resolver,
        uint64 _ttl
    ) external virtual override {
        bytes32 subnode = setSubnodeOwner(node, label, _owner);
        _setResolverAndTTL(subnode, _resolver, _ttl);
    }

    /**
     * @dev Transfers ownership of a node to a new address. May only be called by the current owner of the node.
     * @param node The node to transfer ownership of.
     * @param _owner The address of the new owner.
     */
    function setOwner(bytes32 node, address _owner) public virtual override authorised(node) {
        _setOwner(node, _owner);
        emit Transfer(node, _owner);
    }

    /**
     * @dev Transfers ownership of a subnode keccak256(node, label) to a new address. May only be called by the owner of the parent node.
     * @param node The parent node.
     * @param label The hash of the label specifying the subnode.
     * @param _owner The address of the new owner.
     */
    function setSubnodeOwner(
        bytes32 node,
        bytes32 label,
        address _owner
    ) public virtual override authorised(node) returns (bytes32) {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        _setOwner(subnode, _owner);
        emit NewOwner(node, label, _owner);
        return subnode;
    }

    function setSubnodeResolver(
        bytes32 node,
        bytes32 label,
        address _resolver
    ) public virtual override authorised(node) returns (bytes32) {
        bytes32 subnode = keccak256(abi.encodePacked(node, label));
        if (_resolver != records[subnode].resolver) {
            records[subnode].resolver = _resolver;
            emit NewResolver(subnode, _resolver);
        }
        return subnode;
    }

    /**
     * @dev Sets the resolver address for the specified node.
     * @param node The node to update.
     * @param _resolver The address of the resolver.
     */
    function setResolver(bytes32 node, address _resolver) public virtual override authorised(node) {
        emit NewResolver(node, _resolver);
        records[node].resolver = _resolver;
    }

    /**
     * @dev Sets the TTL for the specified node.
     * @param node The node to update.
     * @param _ttl The TTL in seconds.
     */
    function setTTL(bytes32 node, uint64 _ttl) public virtual override authorised(node) {
        emit NewTTL(node, _ttl);
        records[node].ttl = _ttl;
    }

    /**
     * @dev Enable or disable approval for a third party ("operator") to manage
     *  all of `msg.sender`'s FNS records. Emits the ApprovalForAll event.
     * @param operator Address to add to the set of authorized operators.
     * @param approved True if the operator is approved, false to revoke approval.
     */
    function setApprovalForAll(address operator, bool approved) external virtual override {
        operators[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev Returns the address that owns the specified node.
     * @param node The specified node.
     * @return address of the owner.
     */
    function owner(bytes32 node) public view virtual override returns (address) {
        address addr = records[node].owner;
        if (addr == address(this)) {
            return address(0x0);
        }

        return addr;
    }

    /**
     * @dev Returns the address of the resolver for the specified node.
     * @param node The specified node.
     * @return address of the resolver.
     */
    function resolver(bytes32 node) public view virtual override returns (address) {
        return records[node].resolver;
    }

    /**
     * @dev Returns the TTL of a node, and any records associated with it.
     * @param node The specified node.
     * @return ttl of the node.
     */
    function ttl(bytes32 node) public view virtual override returns (uint64) {
        return records[node].ttl;
    }

    /**
     * @dev Returns whether a record has been imported to the registry.
     * @param node The specified node.
     * @return Bool if record exists
     */
    function recordExists(bytes32 node) public view virtual override returns (bool) {
        return records[node].owner != address(0x0);
    }

    /**
     * @dev Query if an address is an authorized operator for another address.
     * @param _owner The address that owns the records.
     * @param operator The address that acts on behalf of the owner.
     * @return True if `operator` is an approved operator for `owner`, false otherwise.
     */
    function isApprovedForAll(address _owner, address operator) external view virtual override returns (bool) {
        return operators[_owner][operator];
    }

    function _setOwner(bytes32 node, address _owner) internal virtual {
        records[node].owner = _owner;
    }

    function _setResolverAndTTL(
        bytes32 node,
        address _resolver,
        uint64 _ttl
    ) internal {
        if (_resolver != records[node].resolver) {
            records[node].resolver = _resolver;
            emit NewResolver(node, _resolver);
        }

        if (_ttl != records[node].ttl) {
            records[node].ttl = _ttl;
            emit NewTTL(node, _ttl);
        }
    }
}
