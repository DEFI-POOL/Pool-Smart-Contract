// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "./FairyTokenInterface.sol";



/** 
@title Users enter the pool by depositing and leave the pool by withdrawing from this contract. 
Assets are deposited into a yield source and the contract exposes interest to Prize Strategy to select winner.  
*/

/**
@notice Accounting is managed using Controlled Tokens, 
whose mint and burn functions can only be called by this contract. 
*/

/// @dev Must be inherited to provide specific yield-bearing asset control, such as Compound cTokens

contract UserPool is Ownable, ReentrancyGuard {

    using SafeMath for uint256;
    using SafeCast for uint256;
    using SafeERC20 for IERC20;


    /// @dev The total amount of funds that the pool can hold.
    uint256 public liquidityCap;

    /// @notice The total supply of Fairy tokens.
    uint256 private _totalSupply;

    /// @dev Reserve to which reserve fees are sent
    address public reserveRegistry;

// Remember to update these addresses to actual contract address. Below are just place holder addresses.
/// ==========================================================================
    /// @dev Contract address of controlled Fairytoken. 
    Fairy fairyContract;
    address internal _token = 0x0fC5025C764cE34df352757e82f7B5c4Df39A836;

    /// @dev Contract address of the underlining asset.
    address internal _BaseAsset = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    /// @dev  Address that receives all depostis and supplies it to yield source.
    address depositReserve = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
/// ==========================================================================


    /// @dev Event emitted when the Liquidity Cap is set
    event LiquidityCapSet(
        uint256 liquidityCap
    );

    /// @dev Emitted when an instance is initialized
    event Initialized(
        address reserveRegistry
    );

    /// @dev Event emitted when assets are deposited
    event Deposited(
        address to,
        uint256 amount
    );

    /// @notice Initializes the User Pool.
    /// @param _reserveRegistry Reserve to which reserve fees are sent.
    /// @dev Reserve to which reserve fees are sent.
    
    constructor (address _reserveRegistry) {

        require(address(_reserveRegistry) != address(0), "reserveRegistry must not be address 0");
        reserveRegistry = _reserveRegistry;

        emit Initialized(
            address(_reserveRegistry)
        );
    }

    /// @notice Allows the Governor to set a cap on the amount of liquidity that the pool can hold
    /// @param _liquidityCap The new liquidity cap for the prize pool
    function setLiquidityCap(uint256 _liquidityCap) external onlyOwner {
        _setLiquidityCap(_liquidityCap);
    }

    function _setLiquidityCap(uint256 _liquidityCap) internal {
        liquidityCap = _liquidityCap;
        emit LiquidityCapSet(_liquidityCap);
    }

    
    /// @notice Deposit assets into the UserPool in exchange for FairyTokens as tickets.

    function depositToPool() external nonReentrant  canAddLiquidity(msg.value){
        require(msg.value > 0, "You must send in some ether to join the pool");
        payable(depositReserve).transfer(msg.value);

        _mintFairyToDepositor(msg.sender, msg.value);

        emit Deposited(msg.sender, msg.value);
    }

    function _mintFairyToDepositor(address to, uint256 amount) internal {
        _mint(to, amount);
    }

    function _mint(address to, uint256 amount) internal {
        fairyContract = Fairy(_token);
        fairyContract.mint(to, amount);
    }

    function depositReserveBalance() public view returns (uint) {
        return depositReserve.balance;
    }

    /// @dev Function modifier to ensure the deposit amount does not exceed the liquidity cap (if set)
    modifier canAddLiquidity(uint256 _amount) {
        require(_canAddLiquidity(_amount), "UserPool/exceeds-liquidity-cap");
        _;
    }

    /// @dev Checks if the UserPool can receive liquidity based on the current cap.
    /// @param _amount The amount of liquidity to be added to the UserPool.
    /// @return True if the UserPool can receive the specified amount of liquidity
    function _canAddLiquidity(uint256 _amount) internal view returns (bool) {
        uint256 tokenTotalSupply = _totalSupply;
        return (tokenTotalSupply.add(_amount) <= liquidityCap);
    }

    /// @notice Withdraw assets from the UserPool instantly.
    /// @param from The address to redeem tokens from.
    /// @param amount The amount of tokens to redeem for assets.

    function withdrawFromPool(address from, uint256 amount) public {

    }
    
    function _burn(address from, uint256 amount) internal {
        fairyContract = Fairy(_token);
        fairyContract.burn(from, amount);
    }

    /// @notice Called by the prize strategy to award prizes.
    /// @dev The amount awarded must be less than the awardBalance()
    /// @param to The address of the winner that receives the award
    /// @param amount The amount of assets to be awarded
    /// @param controlledToken (contract) The address of the asset token being awarded

    function award(address to, uint256 amount, address controlledToken) public {

    }

    /// @notice Returns the balance that is available to award.
    /// @dev captureAwardBalance() should be called first
    /// @return The total amount of assets to be awarded for the current prize

    function awardBalance() {
        
    }

    /// @notice Captures any available interest as award balance.
    /// @dev This function also captures the reserve fees.
    /// @return The total amount of assets to be awarded for the current prize

    function captureAwardBalance() {

    }



}

