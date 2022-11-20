//SPDX-License-Identifier: MIT
pragma solidity >=0.8.17;

import "./interfaces/IPriceOracle.sol";
import "./libs/StringUtils.sol";
import "./libs/Ownable.sol";
import "./libs/IERC165.sol";

// FixedPriceOracle sets a price in FIL
contract FixedPriceOracle is IPriceOracle {
    using StringUtils for *;

    // Rent in base price units by length
    uint256 public immutable price1Letter;
    uint256 public immutable price2Letter;
    uint256 public immutable price3Letter;
    uint256 public immutable price4Letter;
    uint256 public immutable price5Letter;

    constructor() {
        // price1Letter = _rentPrices[0];
        // price2Letter = _rentPrices[1];
        // price3Letter = _rentPrices[2];
        // price4Letter = _rentPrices[3];
        // price5Letter = _rentPrices[4];
        price1Letter = 3 * 1e15;
        price2Letter = 3 * 1e14;
        price3Letter = 3 * 1e13;
        price4Letter = 3 * 1e12;
        price5Letter = 3 * 1e11;
    }

    function price(
        string calldata name,
        uint256 expires,
        uint256 duration
    ) external view override returns (IPriceOracle.Price memory) {
        uint256 len = name.strlen();
        uint256 basePrice;

        if (len >= 5) {
            basePrice = price5Letter * duration;
        } else if (len == 4) {
            basePrice = price4Letter * duration;
        } else if (len == 3) {
            basePrice = price3Letter * duration;
        } else if (len == 2) {
            basePrice = price2Letter * duration;
        } else {
            basePrice = price1Letter * duration;
        }

        return IPriceOracle.Price({ base: basePrice, premium: _premium(name, expires, duration) });
    }

    /**
     * @dev Returns the pricing premium in wei.
     */
    function premium(
        string calldata name,
        uint256 expires,
        uint256 duration
    ) external view returns (uint256) {
        return _premium(name, expires, duration);
    }

    /**
     * @dev Returns the pricing premium in internal base units.
     */
    function _premium(
        string memory, /*name*/
        uint256, /*expires*/
        uint256 /*duration*/
    ) internal view virtual returns (uint256) {
        return 0;
    }

    function supportsInterface(bytes4 interfaceID) public view virtual returns (bool) {
        return interfaceID == type(IERC165).interfaceId || interfaceID == type(IPriceOracle).interfaceId;
    }
}
