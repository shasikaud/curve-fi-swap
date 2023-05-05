//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// https://curve.readthedocs.io/registry-exchanges.html#finding-pools-and-swap-rates

interface IERC20 {
    function owner() external returns (address);
    function totalSupply() external returns (uint256);
    function transfer(address _to, uint256 _amount) external;
    function balanceOf(address _of) external returns (uint256);
    function deposit() external payable;
    function approve(address spender, uint amount) external returns (bool);
}

interface ICurveSwapRouter {
    function exchange(
        address _pool,
        address _from,
        address _to,
        uint256 _amount,
        uint256 _expected
    ) external payable returns (uint256);

}

interface IWETH_ {
    function deposit() external payable;
}

contract CurveSwapTest {

    address payable owner;
    address private constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address private constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address private constant POOL = 0xD51a44d3FaE010294C616388b506AcdA1bfAAE46;
    address private constant CURVE_SWAP_ROUTER = 0x99a58482BD75cbab83b27EC03CA68fF489b5788f;

    ICurveSwapRouter private constant icurveSwapRouter = ICurveSwapRouter(CURVE_SWAP_ROUTER);
    
    constructor() {
        owner = payable(msg.sender);
    }

    function getBalanceOf(address _token) external returns (uint256) {
        require(msg.sender == owner, "not the owner");
        return IERC20(_token).balanceOf(address(this));
    }

    function depositEthersToContract() external payable {}

    function wrapEth() external {
        require(msg.sender == owner, "not the owner");
        IWETH_(WETH).deposit{value:address(this).balance}();
    }

    function curveSwap (
        uint256 amountIn,
        uint256 expectedAmountOut
    ) external {
        IERC20(WETH).approve(CURVE_SWAP_ROUTER, amountIn);
        icurveSwapRouter.exchange(POOL, WETH, USDT, amountIn, expectedAmountOut);
    }


}
