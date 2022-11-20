// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "../ResolverBase.sol";
import "./IAddressResolver.sol";

abstract contract AddressResolver is IAddressResolver, ResolverBase {
    // https://github.com/satoshilabs/slips/blob/master/slip-0044.md
    uint256 private constant COIN_TYPE_FIL = 461;

    mapping(uint64 => mapping(bytes32 => mapping(uint256 => bytes))) versionable_addresses;

    /**
     * Sets the address associated with an FNS node.
     * May only be called by the owner of that node in the FNS registry.
     * @param node The node to update.
     * @param a The address to set.
     */
    function setAddr(bytes32 node, address a) external virtual authorised(node) {
        setAddr(node, COIN_TYPE_FIL, addressToBytes(a));
    }

    /**
     * Returns the address associated with an FNS node.
     * @param node The FNS node to query.
     * @return The associated address.
     */
    function addr(bytes32 node) public view virtual returns (address payable) {
        bytes memory a = addr(node, COIN_TYPE_FIL);
        if (a.length == 0) {
            return payable(0);
        }
        return bytesToAddress(a);
    }

    function setAddr(
        bytes32 node,
        uint256 coinType,
        bytes memory a
    ) public virtual authorised(node) {
        emit AddressChanged(node, coinType, a);
        versionable_addresses[recordVersions[node]][node][coinType] = a;
    }

    function addr(bytes32 node, uint256 coinType) public view virtual override returns (bytes memory) {
        return versionable_addresses[recordVersions[node]][node][coinType];
    }

    function supportsInterface(bytes4 interfaceID) public view virtual override returns (bool) {
        return interfaceID == type(IAddressResolver).interfaceId || super.supportsInterface(interfaceID);
    }

    function bytesToAddress(bytes memory b) internal pure returns (address payable a) {
        require(b.length == 20);
        assembly {
            a := div(mload(add(b, 32)), exp(256, 12))
        }
    }

    function addressToBytes(address a) internal pure returns (bytes memory b) {
        b = new bytes(20);
        assembly {
            mstore(add(b, 32), mul(a, exp(256, 12)))
        }
    }
}
