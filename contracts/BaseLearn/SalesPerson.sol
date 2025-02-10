// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Contrato abstracto Empleado
abstract contract Employee {
    //Variables del contrato
    uint256 public idNumber;
    uint256 public managerId;

    //Constructor del contrato
    constructor(uint256 _idNumber, uint256 _managerId) {
        idNumber = _idNumber;
        managerId = _managerId;
    }

    //Funcion Virtual para devolver el costo anual
    function getAnnualCost() external view virtual returns (uint256);
}



//Contrato Hourly
contract Hourly is Employee {
    uint256 public hourlyRate;

    //Constructor del Contrato, lleno valores de Employee
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Employee(_idNumber, _managerId) {
        hourlyRate = _hourlyRate;
    }

    //Sobrecargo funcion heredada getAnnualCost
    function getAnnualCost() external view override returns (uint256) {
        return hourlyRate * 1000;
    }
}



//Contrato Salesperson
contract Salesperson is Hourly {
    //Constructor obligatorio por herencia
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _hourlyRate
    ) Hourly(_idNumber, _managerId, _hourlyRate) {
        // no hay operaciones
    }
}



