// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.25;

// import "../src/UniswapV3Pool.sol";
// import "forge-std/Test.sol";
// import {ERC20Mock} from "lib/openzeppelin-contracts/contracts/mocks/token/ERC20Mock.sol";

// contract UniswapV3PoolTest is Test {
//     ERC20Mock token0;
//     ERC20Mock token1;
//     UniswapV3Pool pool;

//     bool transferInMintCallback = true;
//     bool transferInSwapCallback = true;

//     struct TestCaseParams {
//         uint256 wethBalance;
//         uint256 usdcBalance;
//         int24 currentTick;
//         int24 lowerTick;
//         int24 upperTick;
//         uint128 liquidity;
//         uint160 currentSqrtP;
//         bool transferInMintCallback;
//         bool transferInSwapCallback;
//         bool mintLiqudity;
//     }

//     function setUp() public {
//         token0 = new ERC20Mock();
//         token1 = new ERC20Mock();
//     }

//     function testMintSuccess() public {
//         TestCaseParams memory params = TestCaseParams({
//             wethBalance: 1 ether,
//             usdcBalance: 5000 ether,
//             currentTick: 85176,
//             lowerTick: 84222,
//             upperTick: 86129,
//             liquidity: 1517882343751509868544,
//             currentSqrtP: 5602277097478614198912276234240,
//             transferInMintCallback: true,
//             transferInSwapCallback: true,
//             mintLiqudity: true
//         });

//         (uint256 poolBalance0, uint256 poolBalance1) = setupTestCase(params);

//         uint256 expectedAmount0 = 0.99897661834742528 ether;
//         uint256 expectedAmount1 = 5000 ether;
//         assertEq(poolBalance0, expectedAmount0, "incorrect token0 deposited amount");
//         assertEq(poolBalance1, expectedAmount1, "incorrect token1 deposited amount");

//         assertEq(token0.balanceOf(address(pool)), expectedAmount0);
//         assertEq(token1.balanceOf(address(pool)), expectedAmount1);

//         bytes32 positionKey = keccak256(abi.encodePacked(address(this), params.lowerTick, params.upperTick));
//         uint128 posLiquidity = pool.positions(positionKey);
//         assertEq(posLiquidity, params.liquidity);

//         (bool tickInitialized, uint128 tickLiquidity) = pool.ticks(params.lowerTick);
//         assertTrue(tickInitialized);
//         assertEq(tickLiquidity, params.liquidity);

//         (tickInitialized, tickLiquidity) = pool.ticks(params.upperTick);
//         assertTrue(tickInitialized);
//         assertEq(tickLiquidity, params.liquidity);

//         (uint160 sqrtPriceX96, int24 tick) = pool.slot0();
//         assertEq(sqrtPriceX96, 5602277097478614198912276234240, "invalid current sqrtP");
//         assertEq(tick, 85176, "invalid current tick");
//         assertEq(pool.liquidity(), 1517882343751509868544, "invalid current liquidity");
//     }

//     function testSwapBuyETH() external {
//         TestCaseParams memory params = TestCaseParams({
//             wethBalance: 1 ether,
//             usdcBalance: 5000 ether,
//             currentTick: 85176,
//             lowerTick: 84222,
//             upperTick: 86129,
//             liquidity: 1517882343751509868544,
//             currentSqrtP: 5602277097478614198912276234240,
//             transferInMintCallback: true,
//             transferInSwapCallback: true,
//             mintLiqudity: true
//         });

//         (uint256 poolBalance0, uint256 poolBalance1) = setupTestCase(params);

//         uint256 swapAmount = 42 ether; // 42 USDC
//         token1.mint(address(this), swapAmount);
//         token1.approve(address(this), swapAmount);
//     }

//     function uniswapV3MintCallback(uint256 amount0, uint256 amount1, bytes calldata data) public {
//         if (transferInMintCallback) {
//             UniswapV3Pool.CallbackData memory extra = abi.decode(data, (UniswapV3Pool.CallbackData));
//             IERC20(extra.token0).transferFrom(extra.payer, msg.sender, amount0);
//             IERC20(extra.token1).transferFrom(extra.payer, msg.sender, amount1);
//         }
//     }

//     // Internal Function
//     function setupTestCase(TestCaseParams memory params)
//         internal
//         returns (uint256 poolBalance0, uint256 poolBalance1)
//     {
//         token0.mint(address(this), params.wethBalance);
//         token1.mint(address(this), params.usdcBalance);

//         pool = new UniswapV3Pool(address(token0), address(token1), params.currentSqrtP, params.currentTick);

//         if (params.mintLiqudity) {
//             token0.approve(address(this), params.wethBalance);
//             token1.approve(address(this), params.usdcBalance);

//             UniswapV3Pool.CallbackData memory extra =
//                 UniswapV3Pool.CallbackData({token0: address(token0), token1: address(token1), payer: address(this)});

//             (poolBalance0, poolBalance1) =
//                 pool.mint(address(this), params.lowerTick, params.upperTick, params.liquidity, abi.encode(extra));
//         }

//         transferInMintCallback = params.transferInMintCallback;
//         transferInSwapCallback = params.transferInSwapCallback;
//     }
// }
