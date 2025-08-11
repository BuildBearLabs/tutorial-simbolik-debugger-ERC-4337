# Docs

## For More Information on chain-specific implementation refer to the following official docs:

### Ethereum :

- [Ethereum EIP-4337](https://eips.ethereum.org/EIPS/eip-4337)

# Installation and Usage

```bash
git clone https://github.com/BuildBearLabs/tutorial-simbolik-debugger-ERC-4337.git
cd tutorial-simbolik-debugger-ERC-4337
cp .env.example .env
forge build
```

Setup your BuildBear Sandbox at [BuildBear.io](https://app.buildbear.io).
Once done, fill in the values in `Makefile` and `.env`.
The account used to setup Private Key in .env, use it to setup `BURNER_WALLET` in [script/HelperConfig.s.sol](https://github.com/BuildBearLabs/tutorial-simbolik-debugger-ERC-4337/blob/main/script/HelperConfig.s.sol#L31)

## Deployment & Verification

> Simbolik Debugger will need contracts verified on **Sourcify**, which can be installed from Plugin Marketplace

To Deploy and Verify on your BuildBear Sandbox Setup, execute the following command:

```bash
make deploy-sourcify
```

# Test Suite

### `NOTE` - The current test suites are written in foundry and contain the tests of `authorization`, `access control`, `transfer of ETH and ERC20 tokens to & from abstract account`

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

- **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
- **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
- **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
- **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
