// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IMarketRegistry {
  function registerMarket(
    address _collateral,
    address _market
  ) external returns (bool);

  function withdraw(address _collateral, uint256 _amount) external;

  function getMarket(address _collateral) external view returns (address);

  function getCollateral(address _market) external view returns (address);

  function isMarket(address _market) external view returns (bool);

  function accept(address _participant) external returns (bool);

  function reject(address _participant) external returns (bool);

  function isWhitelisted(address _participant) external view returns (bool);

  function isBlacklisted(address _participant) external view returns (bool);

  function borrow(address _participant, uint256 _amount) external;

  function repay(address _participant, uint256 _amount) external;

  function liquidate(address _participant) external;

  function getCollateral(address _participant) external view returns (uint256);

  function getBorrowed(address _participant) external view returns (uint256);

  function getBorrowingPower(
    address _participant
  ) external view returns (uint256);

  function getLiquidationPrice(
    address _participant
  ) external view returns (uint256);

  function getCollateralizationRatio(
    address _participant
  ) external view returns (uint256);
}
