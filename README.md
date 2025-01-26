# One Time Signatures (OTS)

A Solidity implementation of one-time-signatures (OTS) based on [SECP256k1](https://en.bitcoin.it/wiki/Secp256k1), designed to support [EIP-7702](https://eips.ethereum.org/EIPS/eip-7702).

## Overview

This library enables the generation of deterministic ECDSA signatures without requiring access to private keys. By using only public parameters, it creates valid signatures where the signer's private key remains unknown and uncomputable.

## References

- Based on the original work from [eth-one-time-sig](https://github.com/noot/eth-one-time-sig/blob/master/ots.go)