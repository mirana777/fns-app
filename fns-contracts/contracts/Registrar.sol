// SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./interfaces/FNS.sol";
import "./interfaces/IRegistrar.sol";
import "./libs/ERC721.sol";
import "./libs/ERC721Enumerable.sol";
import "./libs/Ownable.sol";

contract Registrar is IRegistrar, ERC721Enumerable, Ownable {
    // A map of expiry times
    mapping(uint256 => uint256) public expiries;
    // The FNS registry
    FNS public fns;
    // The namehash of the TLD this registrar owns (eg, .fil)
    bytes32 public baseNode;
    // A map of addresses that are authorised to register and renew names.
    mapping(address => bool) public controllers;
    uint256 public constant GRACE_PERIOD = 90 days;

    mapping(uint256 => string) private names;

    string _baseUri;

    constructor(FNS _fns, bytes32 _baseNode) ERC721("FNS", "FNS") {
        fns = _fns;
        baseNode = _baseNode;
    }

    modifier live() {
        require(fns.owner(baseNode) == address(this));
        _;
    }

    modifier onlyController() {
        require(controllers[msg.sender]);
        _;
    }

    /**
     * v2.1.3 version of _isApprovedOrOwner which calls ownerOf(tokenId) and takes grace period into consideration instead of ERC721.ownerOf(tokenId);
     * https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.1.3/contracts/token/ERC721/ERC721.sol#L187
     * @dev Returns whether the given spender can transfer a given token ID
     * @param spender address of the spender to query
     * @param tokenId uint256 ID of the token to be transferred
     * @return bool whether the msg.sender is approved for the given token ID,
     *    is an operator of the owner, or is the owner of the token
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view override returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Gets the owner of the specified token ID. Names become unowned
     *      when their registration expires.
     * @param tokenId uint256 ID of the token to query the owner of
     * @return address currently marked as the owner of the given token ID
     */
    function ownerOf(uint256 tokenId) public view override(IERC721, ERC721) returns (address) {
        require(expiries[tokenId] > block.timestamp);
        return super.ownerOf(tokenId);
    }

    // Authorises a controller, who can register and renew domains.
    function addController(address controller) external onlyOwner {
        controllers[controller] = true;
        emit ControllerAdded(controller);
    }

    // Revoke controller permission for an address.
    function removeController(address controller) external onlyOwner {
        controllers[controller] = false;
        emit ControllerRemoved(controller);
    }

    // Set the resolver for the TLD this registrar manages.
    function setResolver(address resolver) external onlyOwner {
        fns.setResolver(baseNode, resolver);
    }

    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseUri = baseURI;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseUri;
    }

    // Returns the expiration timestamp of the specified id.
    function nameExpires(uint256 id) external view override returns (uint256) {
        return expiries[id];
    }

    // Returns true iff the specified name is available for registration.
    function available(uint256 id) public view override returns (bool) {
        // Not available if it's registered here or in its grace period.
        return expiries[id] + GRACE_PERIOD < block.timestamp;
    }

    // Get the name of a registered id
    function name(uint256 id) external view returns (string memory) {
        return names[id];
    }

    /**
     * @dev Register a name.
     * @param _name The name to registry
     * @param _owner The address that should own the registration.
     * @param duration Duration in seconds for the registration.
     */
    function register(
        string calldata _name,
        address _owner,
        uint256 duration,
        address resolver
    ) external override live onlyController returns (uint256) {
        uint256 expireTime = _register(_name, _owner, duration, true, resolver);
        return expireTime;
    }

    /**
     * @dev Register a name, without modifying the registry.
     * @param _name The name to registry
     * @param _owner The address that should own the registration.
     * @param duration Duration in seconds for the registration.
     */
    function registerOnly(
        string calldata _name,
        address _owner,
        uint256 duration
    ) external live onlyController returns (uint256) {
        return _register(_name, _owner, duration, false, address(0));
    }

    function _register(
        string memory _name,
        address _owner,
        uint256 duration,
        bool updateRegistry,
        address resolver
    ) internal returns (uint256) {
        uint256 id = uint256(keccak256(bytes(_name)));
        require(available(id), "not available");
        // Prevent future overflow
        require(block.timestamp + duration + GRACE_PERIOD > block.timestamp + GRACE_PERIOD, "grace period");

        expiries[id] = block.timestamp + duration;
        if (_exists(id)) {
            // Name was previously owned, and expired
            _burn(id);
        }
        names[id] = _name;
        _mint(_owner, id);
        if (updateRegistry) {
            fns.setSubnodeOwner(baseNode, bytes32(id), _owner);
            if (resolver != address(0)) {
                fns.setSubnodeResolver(baseNode, bytes32(id), resolver);
            }
        }

        emit NameRegistered(id, _owner, block.timestamp + duration);

        return block.timestamp + duration;
    }

    function renew(uint256 id, uint256 duration) external override live onlyController returns (uint256) {
        // Name must be registered here or in grace period
        require(expiries[id] + GRACE_PERIOD >= block.timestamp, "grace period");
        // Prevent future overflow
        require(expiries[id] + duration + GRACE_PERIOD > duration + GRACE_PERIOD, "future overflow");

        expiries[id] += duration;
        emit NameRenewed(id, expiries[id]);
        return expiries[id];
    }

    /**
     * @dev Reclaim ownership of a name in FNS, if you own it in the registrar.
     */
    function reclaim(uint256 id, address _owner) external override live {
        require(_isApprovedOrOwner(msg.sender, id), "forbidden");
        fns.setSubnodeOwner(baseNode, bytes32(id), _owner);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable, IERC165) returns (bool) {
        return interfaceId == type(IRegistrar).interfaceId || super.supportsInterface(interfaceId);
    }
}
