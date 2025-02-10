// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

contract ErrorTriageExercise {
    /**
     * Finds the difference between each uint with it's neighbor (a to b, b to c, etc.)
     * and returns a uint array with the absolute integer difference of each pairing.
     */
    function diffWithNeighbor(
        uint256 _a,
        uint256 _b,
        uint256 _c,
        uint256 _d
    ) public pure returns (uint256[] memory) {
        uint256[] memory results = new uint256[](3);

        results[0] = (_a > _b) ? (_a - _b) : (_b - _a);
        results[1] = (_b > _c)  ? (_b - _c) : (_c - _b);
        results[2] = (_c > _d)  ? (_c - _d) : (_d - _c);

        return results;
    }

    /**
     * Changes the _base by the value of _modifier.  Base is always >= 1000.  Modifiers can be
     * between positive and negative 100;
     */
  function applyModifier(
        uint _base,
        int _modifier
    ) public pure returns (uint) {
       if (_modifier > 0) {
            return _base + uint(_modifier);
        }
        return _base - uint(-_modifier);
    }

    /**
     * Pop the last element from the supplied array, and return the popped
     * value (unlike the built-in function)
     */
    uint256[] arr;

    function popWithReturn() public returns (uint256) {
           uint value = arr[arr.length - 1];
        arr.pop();
        return value;
    }

    // The utility functions below are working as expected
    function addToArr(uint256 _num) public {
        arr.push(_num);
    }

    function getArr() public view returns (uint256[] memory) {
        return arr;
    }

    function resetArr() public {
        delete arr;
    }
}
