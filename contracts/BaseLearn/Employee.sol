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

//Contrato Salario
contract Salaried is Employee {
    uint256 public annualSalary;

    //Constructor del Contrato, lleno valores de Employee
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Employee(_idNumber, _managerId) {
        annualSalary = _annualSalary;
    }

    //Sobrecargo funcion heredada getAnnualCost
    function getAnnualCost() external view override returns (uint256) {
        return annualSalary;
    }
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

//Contrato Manager
contract Manager {
    //Arrego de empleados
    string[] public employeeIds;

    //Funcion para agregar empleados al arreglo
    function addReport(string memory _idNumber) public {
        employeeIds.push(_idNumber);
    }

    //funcion que borra los empleados del arreglo
    function resetReports() public {
        for (uint256 x = 0; x < employeeIds.length; x++) {
            delete employeeIds[x];
        }
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

//Contrato EngineeringManager
contract EngineeringManager is Salaried, Manager {
    //Constructor obligatorio por herencia
    constructor(
        uint256 _idNumber,
        uint256 _managerId,
        uint256 _annualSalary
    ) Salaried(_idNumber, _managerId, _annualSalary) Manager() {
        // no hay operaciones
    }
}


contract InheritanceSubmission {
    address public salesPerson;
    address public engineeringManager;

    constructor(address _salesPerson, address _engineeringManager) {
        salesPerson = _salesPerson;
        engineeringManager = _engineeringManager;
    }
}