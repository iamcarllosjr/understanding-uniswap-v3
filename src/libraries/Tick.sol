// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./TickMath.sol";

library Tick {
    struct Info {
        // the total position liquidity that references this tick
        uint128 liquidityGross;
        // amount of net liquidity added (subtracted) when tick is crossed from left to right (right to left),
        int128 liquidityNet;
        // fee growth per unit of liquidity on the _other_ side of this tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint256 feeGrowthOutside0X128;
        uint256 feeGrowthOutside1X128;
        // the cumulative tick value on the other side of the tick
        int56 tickCumulativeOutside;
        // the seconds per unit of liquidity on the _other_ side of this tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint160 secondsPerLiquidityOutsideX128;
        // the seconds spent on the other side of the tick (relative to the current tick)
        // only has relative meaning, not absolute — the value depends on when the tick is initialized
        uint32 secondsOutside;
        // true iff the tick is initialized, i.e. the value is exactly equivalent to the expression liquidityGross != 0
        // these 8 bits are set to prevent fresh sstores when crossing newly initialized ticks
        bool initialized;
    }

    /// @notice Deriva a liquidez máxima por tick a partir de um dado espaçamento entre ticks
    /// @dev Executado dentro do construtor do pool
    /// @param tickSpacing A quantidade de separação de ticks necessária, realizada em múltiplos de `tickSpacing`
    /// por exemplo, um tickSpacing de 3 requer que os ticks sejam inicializados a cada 3 ticks, ou seja : -6, -3, 0, 3, 6, ...
    /// @return A liquidez máxima por tick
    function tickSpacingToMaxLiquidtyPerTick(int24 tickSpacing) internal pure returns (uint128) {
        int24 minTick = (TickMath.MIN_TICK / tickSpacing) * tickSpacing;
        int24 maxTick = (TickMath.MAX_TICK / tickSpacing) * tickSpacing;
        uint24 numTicks = uint24((maxTick - minTick) / tickSpacing) + 1;
        return type(uint128).max / numTicks;
    }

    function update(
        mapping(int24 => Tick.Info) storage self,
        int24 tick,
        int24 tickCurrent,
        int128 liquidityDelta,
        uint256 feeGrowthGlobal0X128,
        uint256 feeGrowthGlobal1X128,
        bool upper,
        uint128 maxLiquidity
    ) internal returns (bool flipped) {
        Info memory info = self[tick];

        uint128 liquidityGrowthBefore = info.liquidityGross;
        uint128 liquidityGrowthAfter = liquidityDelta < 0
            ? liquidityGrowthBefore - uint128(-liquidityDelta)
            : liquidityGrowthBefore + uint128(liquidityDelta);

        require(liquidityGrowthAfter <= maxLiquidity, "liquidity > max");

        // Para que flipped seja true, a comparação entre os dois lados devem ter resultados diferentes (!=)
        // Para que flipped seja false, a comparação entre os dois lados deve ser verdadeira (!=) (ambas true ou ambas false)
        flipped = (liquidityGrowthAfter == 0) != (liquidityGrowthBefore == 0);
        // Se liquidityGrowthAfter for 0 e liquidityGrowthBefore for 100, flipped será true.
        // Se liquidityGrowthAfter for 100 e liquidityGrowthBefore for 200, flipped será false.

        if (liquidityGrowthBefore == 0) {
            info.initialized = true;
        }

        info.liquidityGross = liquidityGrowthAfter;
    }
}
