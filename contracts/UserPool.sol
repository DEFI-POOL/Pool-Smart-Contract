// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/SafeCastUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/introspection/ERC165CheckerUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/SafeERC20Upgradeable.sol";
import "@pooltogether/fixed-point/contracts/FixedPoint.sol";


/** 
@title Users enter the pool by depositing and leave the pool by withdrawing from this contract. 
Assets are deposited into a yield source and the contract exposes interest to Prize Strategy to select winner.  
*/

/**
@notice Accounting is managed using Controlled Tokens, 
whose mint and burn functions can only be called by this contract. 
*/

/// @dev Must be inherited to provide specific yield-bearing asset control, such as Compound cTokens

contract UserPool is OwnableUpgradeable, ReentrancyGuardUpgradeable {

    /// @dev Returns the total underlying balance of all assets. This includes both principal and interest.
    /// @return The underlying balance of assets

    function balance() external returns (uint256) {
        
    }

    /// @notice Deposit assets into the UserPool in exchange for UserPool tokens
    /// @param to The address receiving the newly minted UserPool tokens
    /// @param amount The amount of assets to deposit
    /// @param controlledToken (contract) The address of the type of token the user is minting
    /// @param referrer The referrer of the deposit (optional)

    function depositTo(address to, uint256 amount, address controlledToken, address referrer) {

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

    

}

