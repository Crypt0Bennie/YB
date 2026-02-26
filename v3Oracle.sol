import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";

function getTWAP(address pool, uint32 twapInterval) external view returns (uint256 price) {
    uint32[] memory secondsAgos = new uint32[](2);
    secondsAgos[0] = twapInterval;  // e.g., 1800 for 30 min
    secondsAgos[1] = 0;

    (int56[] memory tickCumulatives,) = IUniswapV3Pool(pool).observe(secondsAgos);

    int24 averageTick = int24((tickCumulatives[1] - tickCumulatives[0]) / int56(uint56(twapInterval)));

    // Convert tick to price (token1 / token0, adjusted for decimals)
    uint160 sqrtPriceX96 = TickMath.getSqrtRatioAtTick(averageTick);
    price = FullMath.mulDiv(sqrtPriceX96, sqrtPriceX96, FixedPoint96.Q96);  // price in Q96 format
}
