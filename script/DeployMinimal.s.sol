// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {MinimalAccount} from "../src/ethereum/MinimalAccount.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {console2} from "forge-std/console2.sol";
import {IERC20} from "forge-std/interfaces/IERC20.sol";
import {PackedUserOperation} from "@eth-infinitism/account-abstraction/interfaces/PackedUserOperation.sol";
import {IEntryPoint} from "@eth-infinitism/account-abstraction/interfaces/IEntryPoint.sol";
import {MessageHashUtils} from "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract DeployMinimal is Script {
    using MessageHashUtils for bytes32;

    uint256 constant VERIFICATION_GAS_LIMIT = 16777216;
    uint256 constant CALL_GAS_LIMIT = VERIFICATION_GAS_LIMIT;
    uint256 constant MAX_FEE_PER_GAS = 256;
    uint256 constant MAX_PRIORITY_FEE_PER_GAS = MAX_FEE_PER_GAS;

    function run() public {
        deployMinimalAccount();
    }

    function deployMinimalAccount() public returns (MinimalAccount, HelperConfig.NetworkConfig memory) {
        uint256 value = 1e18;
        address receiver = 0xA72e562f24515C060F36A2DA07e0442899D39d2c;
        bytes memory callData = abi.encodeWithSignature("call(bytes memory)", "");
        bytes memory transferData = abi.encodeWithSignature("transfer(address, uint)", receiver, value);

        uint256 deployerKey;
        address deployer;
        string memory mnemonic = vm.envString("MNEMONIC");
        console2.log(mnemonic);
        (deployer, deployerKey) = deriveRememberKey(mnemonic, 0);

        HelperConfig helperConfig = new HelperConfig();

        HelperConfig.NetworkConfig memory config = helperConfig.getConfig();
        address usdc = config.usdc;

        vm.startBroadcast(deployer);
        MinimalAccount minimalAccount = new MinimalAccount(config.account, config.entryPoint);
        // minimalAccount.transferOwnership(msg.sender);
        minimalAccount.execute{value: 1e18}(config.entryPoint, value, callData);

        // Target target = new Target();
        // minimalAccount.execute{value: 1e17, gas: 2300}(address(target), value, transferData);

        // minimalAccount.execute{value: value}(deployer, value, transferData);
        vm.stopBroadcast();

        // Send USDC Transfer transaction
        // vm.startBroadcast(config.account);

        // address dest = usdc;
        // bytes memory functionData = abi.encodeWithSelector(IERC20.approve.selector, receiver, 1e18);
        // bytes memory executeCalldata =
        //     abi.encodeWithSelector(MinimalAccount.execute.selector, dest, value, functionData);
        // PackedUserOperation memory userOp =
        //     generateSignedUserOperation(executeCalldata, helperConfig.getConfig(), address(minimalAccount));
        // PackedUserOperation[] memory ops = new PackedUserOperation[](2);
        // ops[0] = userOp;

        // functionData = abi.encodeWithSelector(IERC20.transfer.selector, receiver, 1e18);
        // executeCalldata = abi.encodeWithSelector(MinimalAccount.execute.selector, dest, value, functionData);
        // PackedUserOperation memory userOp2 =
        //     generateSignedUserOperation(executeCalldata, helperConfig.getConfig(), address(minimalAccount));

        // ops[1] = userOp2;

        // IEntryPoint(helperConfig.getConfig().entryPoint).handleOps(ops, payable(config.account));
        // vm.stopBroadcast();

        return (minimalAccount, config);
    }

    function generateSignedUserOperation(
        bytes memory callData,
        HelperConfig.NetworkConfig memory config,
        address minimalAccount
    ) public view returns (PackedUserOperation memory) {
        // 1. Generate the unsigned data
        uint256 nonce = vm.getNonce(minimalAccount) - 1;
        PackedUserOperation memory userOp = _generateUnsignedUserOperation(callData, minimalAccount, nonce);

        // 2. Get the userOp Hash
        bytes32 userOpHash = IEntryPoint(config.entryPoint).getUserOpHash(userOp);
        bytes32 digest = userOpHash.toEthSignedMessageHash();

        // 3. Sign it
        uint8 v;
        bytes32 r;
        bytes32 s;
        uint256 ANVIL_DEFAULT_KEY = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        if (block.chainid == 31337) {
            (v, r, s) = vm.sign(ANVIL_DEFAULT_KEY, digest);
        } else {
            (v, r, s) = vm.sign(config.account, digest);
        }
        userOp.signature = abi.encodePacked(r, s, v); // Note the order
        return userOp;
    }

    function _generateUnsignedUserOperation(bytes memory callData, address sender, uint256 nonce)
        internal
        pure
        returns (PackedUserOperation memory)
    {
        uint128 verificationGasLimit = 16777216;
        uint128 callGasLimit = verificationGasLimit;
        uint128 maxPriorityFeePerGas = 256;
        uint128 maxFeePerGas = maxPriorityFeePerGas;
        return PackedUserOperation({
            sender: sender,
            nonce: nonce,
            initCode: hex"",
            callData: callData,
            accountGasLimits: bytes32(uint256(verificationGasLimit) << 128 | callGasLimit),
            preVerificationGas: verificationGasLimit,
            gasFees: bytes32(uint256(maxPriorityFeePerGas) << 128 | maxFeePerGas),
            paymasterAndData: hex"",
            signature: hex""
        });
    }
}

contract Target {
    uint256 constant MINIMUM_AMOUNT = 10_000;

    event Fallback();

    function execute(bytes memory _value) public returns (bool) {}

    fallback() external payable {
        for (uint256 i = 0;; i++) {
            payable(address(0xDEAD)).transfer(1 ether);

            if (gasleft() < MINIMUM_AMOUNT) {
                return;
            }
        }
    }

    receive() external payable {
        for (uint256 i = 0;; i++) {
            payable(address(0xDEAD)).transfer(1 ether);

            if (gasleft() < MINIMUM_AMOUNT) {
                return;
            }
        }
    }
}
