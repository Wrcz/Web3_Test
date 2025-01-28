// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

// Define un contrato llamado ArraysExercise
contract ArraysExercise {
    // Declara un array dinámico de uints inicializado con los números del 1 al 10
    uint256[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // Declara un array dinámico de direcciones para almacenar los remitentes de transacciones
    address[] public senders;
    // Declara un array dinámico de uints para almacenar marcas de tiempo (timestamps)
    uint256[] public timestamps;

    // Función para obtener el array `numbers` actual
    function getNumbers() external view returns (uint256[] memory) {
        // Devuelve todo el array `numbers`
        return numbers;
    }

    // Función para restablecer el array `numbers` a sus valores originales
    function resetNumbers() external {
        // Reinicia el array `numbers` con sus valores predeterminados
        numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    }

    // Función para agregar un array de números al array `numbers`
    function appendToNumbers(uint256[] calldata _toAppend) external {
        // Recorre cada elemento del array de entrada `_toAppend`
        for (uint256 i; i < _toAppend.length; ) {
            // Agrega el elemento actual al array `numbers`
            numbers.push(_toAppend[i]);
            // Utiliza `unchecked` para omitir la verificación de desbordamiento en `i` y ahorrar gas
            unchecked {
                ++i;
            }
        }
    }

    // Función para guardar una marca de tiempo junto con la dirección del remitente
    function saveTimestamp(uint256 _unixTimestamp) external {
        // Ag
    }
}
