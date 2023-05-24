const { ethers } = require("ethers");

// contract artifacts
const CurveProxyContract = artifacts.require('curveProxy');
const IERC20Contract = artifacts.require('IERC20_');

contract('tests for dummy pool', (accounts) => {
  
    let curveProxyContract;
    let wethContractInterface;
    let usdtContractInterface;

    const WETH = web3.utils.toChecksumAddress("0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2");
    const WBTC = web3.utils.toChecksumAddress("0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599");
    const USDT = web3.utils.toChecksumAddress("0xdAC17F958D2ee523a2206206994597C13D831ec7");
    const USDC = web3.utils.toChecksumAddress("0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48");
    const DAI = web3.utils.toChecksumAddress("0x6B175474E89094C44Da98b954EedeAC495271d0F");

    const USDT_WETH_WBTC_POOL = web3.utils.toChecksumAddress("0xd51a44d3fae010294c616388b506acda1bfaae46");
    const DAI_USDC_USDT_POOL = web3.utils.toChecksumAddress("0xbebc44782c7db0a1a60cb6fe97d0b483032ff1c7");
    const CRV_YCRV_POOL = web3.utils.toChecksumAddress("0x453D92C7d4263201C69aACfaf589Ed14202d83a4");
    
    const WETH_WHALE = "0xf57074ea449A15a79F23eEA0F43Ab1DF38344F57";
    const USDT_WHALE = "0x5754284f345afc66a98fbB0a0Afe71e0F007B949";

    const USDT0 = ethers.utils.parseUnits("0", 6);
    const USDT2 = ethers.utils.parseUnits("2", 6);
    const USDT3 = ethers.utils.parseUnits("3", 6);

    const WETH0 = ethers.utils.parseUnits("0", 18);
    const WETH1 = ethers.utils.parseUnits("1", 18);
    const WETH2 = ethers.utils.parseUnits("2", 18);
    const WETH3 = ethers.utils.parseUnits("3", 18);
    const WETH5 = ethers.utils.parseUnits("5", 18);

    const DAI1 = ethers.utils.parseUnits("1", 6);
    const DAI0 = ethers.utils.parseUnits("0", 6);

    const USDC1 = ethers.utils.parseUnits("1", 6);
    const USDC0 = ethers.utils.parseUnits("0", 6);

    const WBTC1 = ethers.utils.parseUnits("1", 8);
    const WBTC0 = ethers.utils.parseUnits("0", 8);

    before (async () => {
        curveProxyContract = await CurveProxyContract.new();
        wethContractInterface = await IERC20Contract.at(WETH);
        usdtContractInterface = await IERC20Contract.at(USDT);
    })

    it ('Should pass tests', async () => {

        let accounts = await web3.eth.getAccounts();
        let account = accounts[0];

        const curveProxyContractAddress = web3.utils.toChecksumAddress(curveProxyContract.address);

        await usdtContractInterface.transfer(curveProxyContractAddress, USDT3, { from: USDT_WHALE });

        console.log(`------------ BEFORE SWAP`);

        let usdtBalProxy = await usdtContractInterface.balanceOf(curveProxyContractAddress);

        console.log(`USDT > proxy:${usdtBalProxy}`);

        console.log(`------------ SWAP >`);
        await curveProxyContract.poolExchange(DAI_USDC_USDT_POOL, USDT, 2, 0, USDT2, DAI1);
        
        console.log(`------------ AFTER SWAP`);

        usdtBalProxy = await usdtContractInterface.balanceOf(curveProxyContractAddress);

        console.log(`USDT > proxy:${usdtBalProxy});

    })


})
