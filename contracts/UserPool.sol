// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeCast.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";



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

    /// @dev Reserve to which reserve fees are sent
    address public reserveRegistry;

    /// @dev The maximum possible exit fee fraction as a fixed point 18 number.
    /// For example, if the maxExitFeeMantissa is "0.1 ether", then the maximum exit fee for a withdrawal of 100 Dai will be 10 Dai
    uint256 public maxExitFee;

    /// @dev Address of controlled tokens
    address internal _tokens;

    /// @dev Event emitted when the Liquidity Cap is set
    event LiquidityCapSet(
        uint256 liquidityCap
    );

    /// @dev Emitted when an instance is initialized
    event Initialized(
        address reserveRegistry,
        uint256 maxExitFee
    );

    /// @notice Initializes the User Pool
    /// @param _controlledTokens Address ControlledToken that is controlled by this User Pool.
    /// @param _maxExitFee The maximum exit fee size where applicable
    /// @dev Reserve to which reserve fees are sent
    
    constructor (address _reserveRegistry, uint256 _maxExitFee, address _controlledToken) {

        require(address(_reserveRegistry) != address(0), "reserveRegistry must not be address 0");
        reserveRegistry = _reserveRegistry;
        maxExitFee = _maxExitFee;

        emit Initialized(
            address(_reserveRegistry),
            maxExitFee
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

   
    /// @dev Returns the total underlying balance of all assets. This includes both principal and interest.
    /// @return The underlying balance of assets

    function balance() external returns (uint256) {
        
    }

    /// @notice Deposit assets into the UserPool in exchange for UserPool tokens
    /// @param to The address receiving the newly minted UserPool tokens
    /// @param amount The amount of assets to deposit
    /// @param controlledToken (contract) The address of the type of token the user is minting

    function depositTo(address to, uint256 amount, address controlledToken ) external nonReentrant {

    }

    /// @notice Withdraw assets from the UserPool instantly.  A fairness fee may be charged for an early exit.
    /// @param from The address to redeem tokens from.
    /// @param amount The amount of tokens to redeem for assets.
    /// @param controlledToken (contract) The address of the token to redeem
    /// @param maximumExitFee The maximum exit fee the caller is willing to pay.  This should be pre-calculated by the calculateExitFee() fxn.
    /// @return The actual exit fee paid

    function withdrawInstantlyFrom(address from, uint256 amount, address controlledToken,  uint256 maximumExitFee) {

    }

    /// @notice Updates the Prize Strategy when tokens are transferred between holders.
    /// @param from The address the tokens are being transferred from (0 if minting)
    /// @param to The address the tokens are being transferred to (0 if burning)
    /// @param amount The amount of tokens being trasferred

    function beforeTokenTransfer(address from, address to, uint256 amount) {

    }

    /// @notice Called by the prize strategy to award prizes.
    /// @dev The amount awarded must be less than the awardBalance()
    /// @param to The address of the winner that receives the award
    /// @param amount The amount of assets to be awarded
    /// @param controlledToken (contract) The address of the asset token being awarded

    function award(address to, uint256 amount, address controlledToken) {

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

    /// @notice Called to mint controlled tokens.  Ensures that token listener callbacks are fired.
    /// @param to The user who is receiving the tokens
    /// @param amount The amount of tokens they are receiving
    /// @param controlledToken (contract) The token that is going to be minted
    /// @param referrer The user who referred the minting

    function _mint(address to, uint256 amount, address controlledToken, address referrer) {

    }

    /// @notice Calculates the early exit fee for the given amount
    /// @param from The user who is withdrawing
    /// @param controlledToken The type of collateral being withdrawn
    /// @param amount The amount of collateral to be withdrawn
    /// @return exitFee The exit fee
    /// @return burnedCredit The user's credit that was burned

    function calculateEarlyExitFee(address from, address controlledToken, uint256 amount) {

    }

    /// @notice Estimates the amount of time it will take for a given amount of funds to accrue the given amount of credit.
    /// @param _principal The principal amount on which interest is accruing
    /// @param _interest The amount of interest that must accrue
    /// @return durationSeconds The duration of time it will take to accrue the given amount of interest, in seconds.
    
    function estimateCreditAccrualTime(address _controlledToken, uint256 _principal, uint256 _interest) {

    }

    /// @notice Burns a users credit.
    /// @param user The user whose credit should be burned
    /// @param credit The amount of credit to burn
    /// @dev To be called inside _burn function

    function _burnCredit(address user, address controlledToken, uint256 credit) {

    }

    /// @notice Returns the credit balance for a given user.  Not that this includes both minted credit and pending credit.
    /// @param user The user whose credit balance should be returned
    /// @return The balance of the users credit

    function balanceOfCredit(address user, address controlledToken) {
        
    }

    /// @notice Allows the Governor to set a cap on the amount of liquidity that he pool can hold
    /// @param _liquidityCap The new liquidity cap for the prize pool
  
    function setLiquidityCap(uint256 _liquidityCap) {

    }

    /// @dev To be called inside setLiquidityCap.

    function _setLiquidityCap(uint256 _liquidityCap) internal {

    }

    /// @notice Sets the prize strategy of the UserPool.  Only callable by the owner.
    /// @param _prizeStrategy The new prize strategy

    function _setPrizeStrategy() {

    }

    /// @dev Gets the current time as represented by the current block
    /// @return The timestamp of the current block

    function _currentTime() internal virtual view returns (uint256) {

    }

    /// @notice The total of all controlled tokens
    /// @return The current total of all tokens

    function accountedBalance() {

    }

    /// @dev Checks if the UserPool can receive liquidity based on the current cap
    /// @param _amount The amount of liquidity to be added to the Prize Pool
    /// @return True if the UserPool can receive the specified amount of liquidity

    function _canAddLiquidity(uint256 _amount) internal view returns (bool) {

    }

    /// @notice Returns the ERC20 asset token used for deposits.
    /// @return The ERC20 asset token
  
    function _token() internal virtual view returns (IERC20Upgradeable);

    


}

