// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//Creo Contrato GarageManager
contract GarageManager {
    /*@dev funcion que genera mensaje de error*/
    error BadCarIndex(uint256 _index);
    
    //Estructura que almacenará caracteristicas de un auto
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    //Maping para almacer las direcciones de propieratio y los autos
    mapping(address => Car[]) public garage;

    /**
@dev Permite agregar un nuevo auto a la lista de un owner
@param _make Fabricante del auto
@param _model Model del auto
@param _color Color del auto
@param _numberOfDoors Numero de puertas
*/
    function addCar(
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) external {
        garage[msg.sender].push(Car(_make, _model, _color, _numberOfDoors));
    }

    /**
@dev Funcion que devuelve todos los autos del usuario actual
*/
    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    /**
@dev Funcion que devuelve los autos de una determinada direccion
@param _address Direccion de cartera para consultar sus autos
*/
    function getUserCars(address _address)
        external
        view
        returns (Car[] memory)
    {
        return garage[_address];
    }

  
    /**
@dev Funcion que actualiza automovil
@param _index Indice buscado
@param _make Fabricante de automovil
@param _model Modelo del automovil
@param _color Color del automovil
@param _numberOfDoors Numero de puertas 
*/
    function updateCar(
        uint256 _index,
        string calldata _make,
        string calldata _model,
        string calldata _color,
        uint256 _numberOfDoors
    ) external {
        Car[] storage cars = garage[msg.sender];

        if (_index >= cars.length) {
            revert BadCarIndex(_index);
        }

        cars[_index].make = _make;
        cars[_index].model = _model;
        cars[_index].color = _color;
        cars[_index].numberOfDoors = _numberOfDoors;
    }

  /**
@dev Funcion que eliminas los autos del propietario
*/
    function resetMyGarage() external {
        delete garage[msg.sender];
    }

}
