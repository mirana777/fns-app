//SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./interfaces/FNS.sol";
import "./resolvers/AddressResolver.sol";
import "./resolvers/ContentHashResolver.sol";
import "./resolvers/NameResolver.sol";
import "./resolvers/TextResolver.sol";
import "./Multicallable.sol";

/**
 * A simple resolver anyone can use; only allows the owner of a node to set its
 * address.
 */
contract PublicResolver is Multicallable, AddressResolver, ContentHashResolver, NameResolver, TextResolver {
    FNS immutable fns;
    address immutable trustedRegistrarController;
    address immutable trustedReverseRegistrar;

    /**
     * A mapping of operators. An address that is authorised for an address
     * may make any changes to the name that the owner could, but may not update
     * the set of authorisations.
     * (owner, operator) => approved
     */
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Logged when an operator is added or removed.
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    constructor(
        FNS _fns,
        address _trustedRegistrarController,
        address _trustedReverseRegistrar
    ) {
        fns = _fns;
        trustedRegistrarController = _trustedRegistrarController;
        trustedReverseRegistrar = _trustedReverseRegistrar;
    }

    /**
     * @dev See {IERC1155-setApprovalForAll}.
     */
    function setApprovalForAll(address operator, bool approved) external {
        require(msg.sender != operator, "ERC1155: setting approval status for self");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev See {IERC1155-isApprovedForAll}.
     */
    function isApprovedForAll(address account, address operator) public view returns (bool) {
        return _operatorApprovals[account][operator];
    }

    function isAuthorised(bytes32 node) internal view override returns (bool) {
        if (msg.sender == trustedRegistrarController || msg.sender == trustedReverseRegistrar) {
            return true;
        }
        address owner = fns.owner(node);
        return owner == msg.sender || isApprovedForAll(owner, msg.sender);
    }

    function supportsInterface(bytes4 interfaceID)
        public
        view
        override(Multicallable, AddressResolver, ContentHashResolver, NameResolver, TextResolver)
        returns (bool)
    {
        return super.supportsInterface(interfaceID);
    }
}
