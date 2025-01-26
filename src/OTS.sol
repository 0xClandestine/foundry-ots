// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {CommonBase, VmSafe} from "forge-std/Base.sol";

error InvalidSalt();

/// @title OneTimeSignatures
/// @dev Implementation of one-time signatures based on SECP256k1.
/// @notice Original inspiration: https://github.com/noot/eth-one-time-sig/blob/master/ots.go
abstract contract OneTimeSignatures is CommonBase {
    function generateOTS(bytes32 salt)
        internal
        virtual
        returns (uint8 v, bytes32 r, bytes32 s)
    {
        r = bytes32(vm.createWallet(uint256(salt) % SECP256K1_ORDER).publicKeyX);
        // Can signature malleability be exploited for a positive use-case?
        s = bytes32(SECP256K1_ORDER / 2 - 1);
        v = uint256(s) % 2 == 0 ? 27 : 28;
    }

    function sign(bytes32 digest, bytes32 salt)
        internal
        virtual
        returns (address signer, uint8 v, bytes32 r, bytes32 s)
    {
        (v, r, s) = generateOTS(salt);
        if ((signer = ecrecover(digest, v, r, s)) == address(0)) {
            revert InvalidSalt();
        }
    }

    function signDelegation(address implementation, bytes32 salt)
        internal
        virtual
        returns (VmSafe.SignedDelegation memory)
    {
        (uint8 v, bytes32 r, bytes32 s) = generateOTS(salt);
        return VmSafe.SignedDelegation(v % 27, r, s, 0, implementation);
    }
}
