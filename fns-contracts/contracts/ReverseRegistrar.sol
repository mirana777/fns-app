// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./interfaces/FNS.sol";
import "./interfaces/IReverseRegistrar.sol";
import "./libs/Controllable.sol";
import "./libs/Ownable.sol";
import "./resolvers/NameResolver.sol";

bytes32 constant lookup = 0x3031323334353637383961626364656600000000000000000000000000000000;

// namehash('addr.reverse')
bytes32 constant ADDR_REVERSE_NODE = 0x91d1777781884d03a6757a803996e38de2a42967fb37eeaca72729271025a9e2;

contract ReverseRegistrar is Controllable, IReverseRegistrar {
    FNS public immutable fns;
    NameResolver public defaultResolver;

    event ReverseClaimed(address indexed addr, bytes32 indexed node);
    event DefaultResolverChanged(NameResolver indexed resolver);

    /**
     * @dev Constructor
     * @param _fns The address of the FNS registry.
     */
    constructor(FNS _fns) {
        fns = _fns;
    }

    modifier authorised(address addr) {
        require(
            addr == msg.sender ||
                controllers[msg.sender] ||
                fns.isApprovedForAll(addr, msg.sender) ||
                ownsContract(addr),
            "ReverseRegistrar: Caller is not a controller or authorised by address or the address itself"
        );
        _;
    }

    function setDefaultResolver(address resolver) public override onlyOwner {
        require(address(resolver) != address(0), "ReverseRegistrar: Resolver address must not be 0");
        defaultResolver = NameResolver(resolver);
        emit DefaultResolverChanged(NameResolver(resolver));
    }

    /**
     * @dev Transfers ownership of the reverse FNS record associated with the
     *      calling account.
     * @param _owner The address to set as the owner of the reverse record in FNS.
     * @return The FNS node hash of the reverse record.
     */
    function claim(address _owner) public override returns (bytes32) {
        return claimForAddr(msg.sender, _owner, address(defaultResolver));
    }

    /**
     * @dev Transfers ownership of the reverse FNS record associated with the
     *      calling account.
     * @param addr The reverse record to set
     * @param _owner The address to set as the owner of the reverse record in FNS.
     * @param resolver The resolver of the reverse node
     * @return The FNS node hash of the reverse record.
     */
    function claimForAddr(
        address addr,
        address _owner,
        address resolver
    ) public override authorised(addr) returns (bytes32) {
        bytes32 labelHash = sha3HexAddress(addr);
        bytes32 reverseNode = keccak256(abi.encodePacked(ADDR_REVERSE_NODE, labelHash));
        emit ReverseClaimed(addr, reverseNode);
        fns.setSubnodeRecord(ADDR_REVERSE_NODE, labelHash, _owner, resolver, 0);
        return reverseNode;
    }

    /**
     * @dev Transfers ownership of the reverse FNS record associated with the
     *      calling account.
     * @param _owner The address to set as the owner of the reverse record in FNS.
     * @param resolver The address of the resolver to set; 0 to leave unchanged.
     * @return The FNS node hash of the reverse record.
     */
    function claimWithResolver(address _owner, address resolver) public override returns (bytes32) {
        return claimForAddr(msg.sender, _owner, resolver);
    }

    /**
     * @dev Sets the `name()` record for the reverse FNS record associated with
     * the calling account. First updates the resolver to the default reverse
     * resolver if necessary.
     * @param name The name to set for this address.
     * @return The FNS node hash of the reverse record.
     */
    function setName(string memory name) public override returns (bytes32) {
        return setNameForAddr(msg.sender, msg.sender, address(defaultResolver), name);
    }

    /**
     * @dev Sets the `name()` record for the reverse FNS record associated with
     * the account provided. Updates the resolver to a designated resolver
     * Only callable by controllers and authorised users
     * @param addr The reverse record to set
     * @param _owner The owner of the reverse node
     * @param resolver The resolver of the reverse node
     * @param name The name to set for this address.
     * @return The FNS node hash of the reverse record.
     */
    function setNameForAddr(
        address addr,
        address _owner,
        address resolver,
        string memory name
    ) public override returns (bytes32) {
        bytes32 reverseNode = claimForAddr(addr, _owner, resolver);
        NameResolver(resolver).setName(reverseNode, name);
        return reverseNode;
    }

    /**
     * @dev Returns the node hash for a given account's reverse records.
     * @param addr The address to hash
     * @return The FNS node hash.
     */
    function node(address addr) public pure override returns (bytes32) {
        return keccak256(abi.encodePacked(ADDR_REVERSE_NODE, sha3HexAddress(addr)));
    }

    /**
     * @dev An optimised function to compute the sha3 of the lower-case
     *      hexadecimal representation of an address.
     * @param addr The address to hash
     * @return ret The SHA3 hash of the lower-case hexadecimal encoding of the
     *         input address.
     */
    function sha3HexAddress(address addr) private pure returns (bytes32 ret) {
        assembly {
            for {
                let i := 40
            } gt(i, 0) {

            } {
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
                i := sub(i, 1)
                mstore8(i, byte(and(addr, 0xf), lookup))
                addr := div(addr, 0x10)
            }

            ret := keccak256(0, 40)
        }
    }

    function ownsContract(address addr) internal view returns (bool) {
        try Ownable(addr).owner() returns (address owner) {
            return owner == msg.sender;
        } catch {
            return false;
        }
    }
}
