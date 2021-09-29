// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/SafeCastUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/IERC721ReceiverUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/introspection/ERC165CheckerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@pooltogether/fixed-point/contracts/FixedPoint.sol";

import "../external/compound/ICompLike.sol";
import "../registry/RegistryInterface.sol";
import "../reserve/ReserveInterface.sol";
import "../token/TokenListenerInterface.sol";
import "../token/TokenListenerLibrary.sol";
import "../token/ControlledToken.sol";
import "../token/TokenControllerInterface.sol";
import "../utils/MappedSinglyLinkedList.sol";
import "./PrizePoolInterface.sol";


/** 
@title Users enter the pool by depositing and leave the pool by withdrawing from this contract. 
Assets are deposited into a yield source and the contract exposes interest to Prize Strategy to select winner.  
*/

/**
@notice Accounting is managed using Controlled Tokens, 
whose mint and burn functions can only be called by this contract. 
*/

/// @dev Must be inherited to provide specific yield-bearing asset control, such as Compound cTokens

abstract contract UserPool is PrizePoolInterface, OwnableUpgradeable, ReentrancyGuardUpgradeable, TokenControllerInterface, IERC721ReceiverUpgradeable {
    using SafeMathUpgradeable for uint256;
    using SafeCastUpgradeable for uint256;
    using SafeERC20Upgradeable for IERC20Upgradeable;
    using SafeERC20Upgradeable for IERC721Upgradeable;
    using MappedSinglyLinkedList for MappedSinglyLinkedList.Mapping;
    using ERC165CheckerUpgradeable for address;

    /// @dev Emitted when an instance is initialized

    event Initialized(
        address reserveRegistry,
        uint256 maxExitFeeMantissa
    );

    /// @dev Event emitted when controlled token is added
    event ControlledTokenAdded(
        ControlledTokenInterface indexed token
    );

    /// @dev Emitted when reserve is captured.
    event ReserveFeeCaptured(
        uint256 amount
    );

    /// @dev Reserve to which reserve fees are sent
    RegistryInterface public reserveRegistry;

    /// @dev An array of all the controlled tokens
    ControlledTokenInterface[] internal _tokens;

    /// @dev The Prize Strategy that this Prize Pool is bound to.
    TokenListenerInterface public prizeStrategy;

    /// @dev The maximum possible exit fee fraction as a fixed point 18 number.
    /// For example, if the maxExitFeeMantissa is "0.1 ether", then the maximum exit fee for a withdrawal of 100 Dai will be 10 Dai
    uint256 public maxExitFeeMantissa;

    /// @notice Initializes the  UserPool
    /// @param _controlledTokens Array of ControlledTokens that are controlled by this Pool.
    /// @param _maxExitFeeMantissa The maximum exit fee size
  
    function initialize (
        RegistryInterface _reserveRegistry,
        ControlledTokenInterface[] memory _controlledTokens,
        uint256 _maxExitFeeMantissa
    )
        public
        initializer {

        require(address(_reserveRegistry) != address(0), "UserPool/reserveRegistry-not-zero");
        uint256 controlledTokensLength = _controlledTokens.length;
        _tokens = new ControlledTokenInterface[](controlledTokensLength);

        for (uint256 i = 0; i < controlledTokensLength; i++) {
        ControlledTokenInterface controlledToken = _controlledTokens[i];
        _addControlledToken(controlledToken, i);
        }
        __Ownable_init();
        __ReentrancyGuard_init();
        _setLiquidityCap(uint256(-1));

        reserveRegistry = _reserveRegistry;
        maxExitFeeMantissa = _maxExitFeeMantissa;

        emit Initialized(
            address(_reserveRegistry),
            maxExitFeeMantissa
        );
    }

}

