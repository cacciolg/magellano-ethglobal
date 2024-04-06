// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

import {SafeMath} from "@openzeppelin/contracts/utils/math/Math.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

import {IMarketRegistry} from "./interfaces/IMarketRegistry.sol";

// Errors
// ====================================================
error MarketRegistry__NeedsMoreThanZero();
error MarketRegistry__TransferFailed();
error MarketRegistry__InsufficientBalance()

contract MarketRegistry is IMarketRegistry, ReentrancyGuard {
  // Types
  // ====================================================
  /// @dev Library for safe math operations
  using SafeMath for uint256;

  // State Variables
  // ====================================================
  /// @dev The ERC20 pointer of USDC token
  IERC20 private immutable i_collateralToken;

  /// @dev Total amount of collateral deposited
  uint256 private _totalSupply;

  /// @dev Amount of collateral deposited by user
  mapping(address user => uint256 amount) private s_collateralBalance;

  // Events
  // ====================================================
  /// @dev Emitted when user deposits collateral
  event CollateralDeposited(address indexed user, uint256 amount);

  // Modifiers
  // ====================================================
  /// @dev Checks if amount is more than zero
  modifier moreThanZero(uint256 amount) {
    if (amount == 0) {
      revert MarketRegistry__NeedsMoreThanZero();
    }
    _;
  }

  /// @dev Checks if the balance is sufficient to withdraw
  modifier sufficientBalance(address user, uint256 amount) {
    if (s_collateralBalance[user] < amount) {
      revert MarketRegistry__InsufficientBalance();
    }
    _;
  }

  // Functions
  // ====================================================
  /// @dev Constructor for MarketRegistry contract which takes USDC token address
  constructor(address usdcAddress) {
    i_collateralToken = IERC20(usdcAddress);
  }

  // External Functions
  // ====================================================

  /**
   *
   * @dev Deposits collateral to the contract
   * @param amount Amount of collateral to be deposited
   * @notice This function will transfer the amount of _token from caller to contract
   */
  function depositCollateral(
    uint256 amount
  ) external moreThanZero(amount) nonReentrant {
    _totalSupply += amount;
    s_collateralBalance[msg.sender] += amount;

    // Before this you should have approved the amount
    // This will transfer the amount of  _token from caller to contract
    bool success = i_collateralToken.transferFrom(
      msg.sender,
      address(this),
      amount
    );

    if (!success) {
      revert MarketRegistry__TransferFailed();
    }

    emit CollateralDeposited(msg.sender, amount);
  }

  /*
   * @param amount: The amount of collateral you're redeeming
   * @notice This function will redeem your collateral.
   * @notice This function will transfer the amount of _token from contract to caller
   */
  function redeemCollateral(
    uint256 amount
  ) external moreThanZero(amount) sufficientBalance(msg.sender, amount) nonReentrant {
    _totalSupply -= amount;
    s_collateralBalance[msg.sender] -= amount;

    // This will transfer the amount of _token from contract to caller
    bool success = i_collateralToken.transfer(msg.sender, amount);

    if (!success) {
      revert MarketRegistry__TransferFailed();
    }
  }

  // External View & Pure Functions
  // ====================================================

  /**
   * @dev Returns the total amount of collateral deposited
   */
  function totalSupply() external view returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev Returns the amount of collateral deposited by user
   * @param user Address of the user
   */
  function collateralBalanceOf(address user) external view returns (uint256) {
    return s_collateralBalance[user];
  }

  /**
   * @dev Returns the address of the collateral token
   */
  function collateralToken() external view returns (address) {
    return address(i_collateralToken);
  }
}
