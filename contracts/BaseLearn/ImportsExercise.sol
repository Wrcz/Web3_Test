// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    // Using the SillyStringUtils library for string manipulation
    using SillyStringUtils for string;

    SillyStringUtils.Haiku public haiku;

    /**
@dev funcion que setea variables de haiku
@param _line1 Linea 1
@param _line2 Linea 2
@param _line3 Linea 3
*/
    function saveHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) public {
        haiku.line1 = _line1;
        haiku.line2 = _line2;
        haiku.line3 = _line3;
    }

    /**
@dev Funcion que retorna los valores de haiku
*/
    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku()
        external
        view
        returns (SillyStringUtils.Haiku memory)
    {
        // Creating a copy of the Haiku
        SillyStringUtils.Haiku memory newHaiku = haiku;

        // Appending the shrugging emoji to the third line using the shruggie function from the SillyStringUtils library
        newHaiku.line3 = newHaiku.line3.shruggie();
        return newHaiku;
    }
}
