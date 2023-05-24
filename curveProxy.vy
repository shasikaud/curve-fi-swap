# @version ^0.3

from vyper.interfaces import ERC20

Z: constant(address) = empty(address)

interface ICurvePool:
    def exchange(i: int128, j: int128, dx: uint256, min_dy: uint256): nonpayable

@external
@view
def getBalance(token: address) -> uint256: 
    return ERC20(token).balanceOf(self)

@external
def poolExchangeUsingDirectMethod(
    pool: address, 
    tokenIn: address, 
    i: int128, 
    j: int128, 
    amountIn: uint256, 
    amountOut: uint256
):
    ERC20(tokenIn).approve(pool, amountIn)
    ICurvePool(pool).exchange(
        i,
        j,
        amountIn,
        amountOut
    )

@external
def poolExchangeUsingRawCall(
    pool: address, 
    tokenIn: address, 
    i: int128, 
    j: int128, 
    amountIn: uint256, 
    amountOut: uint256
):
    _response1: Bytes[32] = raw_call(
        tokenIn,
        concat(
            method_id("approve(address,uint256)"),
            convert(pool, bytes32),
            convert(amountIn, bytes32),
        ),
        max_outsize=32,
    ) 
    if len(_response1) > 0:
        assert convert(_response1, bool)

    _response2: Bytes[32] = raw_call(
        pool,
        concat(
            method_id("exchange(uint256,uint256,uint256,uint256,bool)"),
            convert(i, bytes32),
            convert(j, bytes32),
            convert(amountIn, bytes32),
            convert(amountOut, bytes32),
            convert(True, bytes32),
        ),
        max_outsize=32,
    ) 
    if len(_response2) > 0:
        assert convert(_response2, bool)

