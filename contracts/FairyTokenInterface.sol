// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Fairy is ERC20{
    
    function mint(address _user, uint amount) public {}
    
    function burn(address _user, uint256 _amount) external virtual {}
}