// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./libraries/Tick.sol";
import "./libraries/TickMath.sol";
import "./libraries/Position.sol";
import "./libraries/SafeCast.sol";
import "./interfaces/IERC20.sol";

contract CLAMM {
    using SafeCast for int256;
    using Position for mapping(bytes32 => Position.Info);
    using Position for Position.Info;
    using Tick for mapping(int24 => Tick.Info);

    address public immutable token0;
    address public immutable token1;
    uint24 public immutable fee;
    int24 public immutable tickSpacing;
    uint128 public immutable maxLiquidityPerTick;

    // Slot0 porque ocupa o slot 0 do contrato na EVM
    // Cada slot cabe 32 bytes, 256 bits = 32 bytes
    // Para saber quantos bytes, basta dividir por 8.
    struct Slot0 {
        // the current price
        // 160 / 8 = 20 bytes
        uint160 sqrtPriceX96;
        // the current tick
        // 24 / 8 = 3 bytes
        int24 tick;
        // the most-recently updated index of the observations array
        // 16 / 8 = 2 bytes
        uint16 observationIndex;
        // the current maximum number of observations that are being stored
        // 16 / 8 = 2 bytes
        uint16 observationCardinality;
        // the next maximum number of observations to store, triggered in observations.write
        // 16 / 8 = 2 bytes
        uint16 observationCardinalityNext;
        // the current protocol fee as a percentage of the swap fee taken on withdrawal
        // represented as an integer denominator (1/x)%
        // 8 / 8 = 1 bytes
        uint8 feeProtocol;
        // whether the pool is locked
        // bool contem 1 bytes
        bool unlocked;
    }
    // 20 + 3 + 2 + 2 + 2 + 1 + 1 = 31 bytes

    Slot0 public slot0;

    mapping(bytes32 => Position.Info) public positions;
    mapping(int24 => Tick.Info) public ticks;

    struct ModifyPositionParams {
        address owner;
        int24 tickLower;
        int24 tickUpper;
        int128 liquidityDelta;
    }

    modifier lock() {
        require(slot0.unlocked, "locked");
        slot0.unlocked = false;
        _;
        slot0.unlocked = true;
    }

    constructor(address _token0, address _token1, uint24 _fee, int24 _tickSpacing) {
        token0 = _token0;
        token1 = _token1;
        fee = _fee;
        tickSpacing = _tickSpacing;
        maxLiquidityPerTick = Tick.tickSpacingToMaxLiquidtyPerTick(_tickSpacing);
    }

    function initialize(uint160 sqtrPriceX96) external {
        require(slot0.sqrtPriceX96 == 0, "already initialized");
        int24 tick = TickMath.getTickAtSqrtRatio(sqtrPriceX96);

        slot0 = Slot0({sqtrPriceX96: sqtrPriceX96, tick: tick, unlocked: true});
    }

    /// @dev Common checks for valid tick inputs.
    function _checkTicks(int24 tickLower, int24 tickUpper) private pure {
        require(tickLower < tickUpper, "TLU");
        require(tickLower >= TickMath.MIN_TICK, "TLM");
        require(tickUpper <= TickMath.MAX_TICK, "TUM");
    }

    function _updatePosition(address owner, int24 tickLower, int24 tickUpper, int128 liquidityDelta, int24 tick)
        private
        returns (Position.Info storage position)
    {
        position = positions.get(owner, tickLower, tickUpper);

        // TODO fees
        uint256 _feeGrowthGlobal0X128 = 0;
        uint256 _feeGrowthGlobal1X128 = 0;

        //TODO fess
        position.update(liquidityDelta, 0, 0);
    }

    function _modifyPosition(ModifyPositionParams memory params)
        private
        returns (Position.Info storage position, int256 amount0, int256 amount1)
    {
        _checkTicks(params.tickLower, params.tickUpper);

        Slot0 memory _slot0 = slot0;

        position = _updatePosition(params.owner, params.tickLower, params.tickUpper, params.liquidityDelta, _slot0.tick);
        return (positions[bytes32(0)], 0, 0);
    }

    function mint(address recipient, int24 tickLower, int24 tickUpper, uint128 amount)
        external
        lock
        returns (uint256 amount0, uint256 amount1)
    {
        require(amount > 0, "amount must be greater than zero");
        (, int256 amount0Int, int256 amount1Int) = _modifyPosition(
            ModifyPositionParams({
                owner: recipient,
                tickLower: tickLower,
                tickUpper: tickUpper,
                liquidityDelta: int256(uint256(amount)).toInt128()
            })
        );

        amount0 = uint256(amount0Int);
        amount1 = uint256(amount1Int);

        if (amount0 > 0) {
            IERC20(token0).transferFrom(msg.sender, address(this), amount0);
        }

        if (amount1 > 0) {
            IERC20(token1).transferFrom(msg.sender, address(this), amount1);
        }
    }
}
