## A repo listing out attempted twitter bug challenges


Check out the first Find the Bug Challenge posted by @Securrtech on twitter.

1. [YieldFarming contract](https://github.com/Derastephh/Twitter-SC-FindTheBug-Challenges/blob/main/src/YieldFarming.sol) and its [test file](https://github.com/Derastephh/Twitter-SC-FindTheBug-Challenges/blob/main/test/YieldFarmingTest.t.sol) which is written in foundry.

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
