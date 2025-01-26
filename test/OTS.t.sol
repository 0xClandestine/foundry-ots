// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {OneTimeSignatures} from "src/OTS.sol";

contract Counter {
    uint256 public count;

    function setCount(uint256 x) external {
        count = x;
    }
}

contract OTSTest is OneTimeSignatures, TransactionHasher, Test {
    function testFuzz_Sign(bytes32 digest, bytes32 seed) public {
        (address signer, uint8 v, bytes32 r, bytes32 s) =
            OneTimeSignatures.sign(digest, seed);

        assertTrue(v == 27 || v == 28, "v != 27 or 28");
        assertTrue(signer != address(0), "signer == address(0)");
        assertEq(
            signer,
            ecrecover(digest, v, r, s),
            "signer != ecrecover(digest, v, r, s)"
        );
    }

    function testFuzz_signDelegation(bytes32 seed) public {
        vm.attachDelegation(
            OneTimeSignatures.signDelegation(address(new Counter()), seed)
        );

        // TODO: need a way of computing the public key for this signature.
    }
}
