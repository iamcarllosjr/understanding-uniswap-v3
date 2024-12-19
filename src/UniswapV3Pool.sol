// // SPDX-License-Identifier: MIT

// pragma solidity ^0.8.25;

// import {Tick} from "./libraries/Tick.sol";
// import {Position} from "./libraries/Position.sol";
// import "../src/interfaces/IUniswapV3MintCallback.sol";
// import "../src/interfaces/IUniswapV3SwapCallback.sol";
// import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// contract UniswapV3Pool {
//     ///@notice Each pool contract is a set of liquidity positions
//     ///@dev Keep track of ticks. A mapping with keys being tick indices and values being structures storing tick information.
//     using Tick for mapping(int24 => Tick.Info);

//     ///@dev Um mapeamento, onde as chaves são identificadores de posição única, e os valores são estruturas contendo informações sobre posições.
//     using Position for mapping(bytes32 => Position.Info);
//     using Position for Position.Info;

//     int24 internal constant MIN_TICK = -887272; // Numero de ticks para a esquerda (Negativo)
//     int24 internal constant MAX_TICK = -MIN_TICK; // Numero de ticks para a direita (Positivo)

//     // Pool tokens, immutable
//     address public immutable token0;
//     address public immutable token1;

//     error InvalidTickRange();
//     error ZeroLiquidity();
//     error InsufficientInputAmount();

//     event Mint(
//         address indexed sender,
//         address indexed owner,
//         int24 lowerTick,
//         int24 upperTick,
//         uint128 amount,
//         uint256 amount0,
//         uint256 amount1
//     );

//     event Swap(
//         address indexed sender,
//         address indexed recipient,
//         int256 amount0,
//         int256 amount1,
//         uint160 sqrtPriceX96,
//         uint128 liquidity,
//         int24 tick
//     );

//     // Empacotamento de variáveis que são lidas em conjunto
//     struct Slot0 {
//         // Current sqrt(P) (raiz quadrada do preço)
//         uint160 sqrtPriceX96;
//         // Current tick (índice do tick atual)
//         int24 tick;
//     }

//     struct CallbackData {
//         address token0;
//         address token1;
//         address payer;
//     }

//     Slot0 public slot0;

//     // Amount of liquidity, L.
//     uint128 public liquidity;

//     // Ticks info
//     mapping(int24 => Tick.Info) public ticks;
//     // Positions info
//     mapping(bytes32 => Position.Info) public positions;

//     constructor(address token0_, address token1_, uint160 sqrtPriceX96, int24 tick) {
//         token0 = token0_;
//         token1 = token1_;

//         // Inicializa o slot0 com o preço e o tick inicial
//         slot0 = Slot0({sqrtPriceX96: sqrtPriceX96, tick: tick});
//     }

//     function mint(address owner, int24 lowerTick, int24 upperTick, uint128 amount, bytes calldata data)
//         external
//         returns (uint256 amount0, uint256 amount1)
//     {
//         if (amount == 0) revert ZeroLiquidity();
//         if (lowerTick >= upperTick || lowerTick < MIN_TICK || upperTick > MAX_TICK) revert InvalidTickRange();

//         ticks.update(lowerTick, amount);
//         ticks.update(upperTick, amount);

//         Position.Info storage position = positions.get(owner, lowerTick, upperTick);
//         position.update(amount);

//         amount0 = 0.99897661834742528 ether;
//         amount1 = 5000 ether;

//         liquidity += uint128(amount);

//         uint256 balance0Before;
//         uint256 balance1Before;
//         if (amount0 > 0) balance0Before = balance0();
//         if (amount1 > 0) balance1Before = balance1();
//         IUniswapV3MintCallback(msg.sender).uniswapV3MintCallback(amount0, amount1, data);
//         if (amount0 > 0 && balance0Before + amount0 > balance0()) {
//             revert InsufficientInputAmount();
//         }
//         if (amount1 > 0 && balance1Before + amount1 > balance1()) {
//             revert InsufficientInputAmount();
//         }

//         emit Mint(msg.sender, owner, lowerTick, upperTick, amount, amount0, amount1);
//     }

//     function balance0() internal view returns (uint256 balance) {
//         balance = IERC20(token0).balanceOf(address(this));
//     }

//     function balance1() internal view returns (uint256 balance) {
//         balance = IERC20(token1).balanceOf(address(this));
//     }

//     function swap(address recipient, bytes calldata data) public returns (int256 amount0, int256 amount1) {
//         int24 nextTick = 85184;
//         uint160 nextPrice = 5604469350942327889444743441197;

//         amount0 = -0.008396714242162444 ether;
//         amount1 = 42 ether;

//         (slot0.tick, slot0.sqrtPriceX96) = (nextTick, nextPrice);

//         IERC20(token0).transfer(recipient, uint256(-amount0));

//         uint256 balance1Before = balance1();
//         IUniswapV3SwapCallback(msg.sender).uniswapV3SwapCallback(amount0, amount1, data);
//         if (balance1Before + uint256(amount1) < balance1()) {
//             revert InsufficientInputAmount();
//         }

//         emit Swap(msg.sender, recipient, amount0, amount1, slot0.sqrtPriceX96, liquidity, slot0.tick);
//     }
// }
