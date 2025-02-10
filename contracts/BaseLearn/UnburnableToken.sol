// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

/**
 * @title UnburnableToken
 * @dev Contrato que gestiona un token que no puede ser quemado,
 *      permitiendo a los usuarios reclamar tokens y transferirlos de manera segura.
 */
contract UnburnableToken {
    // Definición de errores personalizados para revertir transacciones con mensajes específicos
    error TokensClaimed(); // Se dispara cuando un usuario ya ha reclamado tokens
    error AllTokensClaimed(); // Se dispara cuando ya no quedan tokens disponibles para reclamar
    error UnsafeTransfer(address _direccion); // Se dispara cuando una transferencia no es segura

    // Mapping que almacena los saldos de cada dirección
    mapping(address => uint256) public balances;

    uint256 public totalSupply; // Suministro total de tokens
    uint256 public totalClaimed; // Tokens reclamados hasta el momento
    uint256 private claimAmount = 1000; // Cantidad fija de tokens que se pueden reclamar por usuario

    address[] private balancesarray; // Lista de direcciones que han recibido tokens

    /**
     * @dev Constructor que inicializa el suministro total del token.
     */
    constructor() {
        totalSupply = 100000;
    }

    /**
     * @dev Permite a un usuario reclamar una cantidad fija de tokens.
     * @notice Cada usuario solo puede reclamar una vez.
     * @notice No se pueden reclamar más tokens si el suministro total ha sido distribuido.
     */
    function claim() external {
        if ((totalClaimed + claimAmount) > totalSupply) {
            revert AllTokensClaimed(); // Verifica si hay tokens disponibles para reclamar
        }

        if (balances[msg.sender] > 0)
            revert TokensClaimed(); // Evita que un usuario reclame más de una vez

        totalClaimed += claimAmount; // Incrementa el contador de tokens reclamados
        balancesarray.push(msg.sender); // Registra la dirección del usuario
        balances[msg.sender] += claimAmount; // Asigna los tokens al usuario
    }

    /**
     * @dev Obtiene todas las direcciones con saldo y sus respectivos valores.
     * @return Un arreglo con las direcciones y otro con los saldos correspondientes.
     */
    function getAllBalances()
        external
        view
        returns (address[] memory, uint256[] memory)
    {
        uint256 length = balancesarray.length;
        uint256[] memory allBalances = new uint256[](length);

        // Recorre la lista de direcciones y obtiene los saldos
        for (uint256 i = 0; i < length; i++) {
            allBalances[i] = balances[balancesarray[i]];
        }

        return (balancesarray, allBalances);
    }

    /**
     * @dev Realiza una transferencia segura de tokens entre usuarios.
     * @param _to Dirección del destinatario.
     * @param _amount Cantidad de tokens a transferir.
     * @notice La transferencia debe cumplir con ciertas condiciones de seguridad.
     */
    function safeTransfer(address _to, uint256 _amount) public {
        // Verifica que el remitente tenga suficientes tokens y que la dirección de destino no sea cero
        if (balances[msg.sender] < _amount || _to == address(0))
            revert UnsafeTransfer({_direccion: _to});

        // Verifica que la dirección de destino tenga saldo en la blockchain
        if (_to.balance == 0) revert UnsafeTransfer({_direccion: _to});

        // Realiza la transferencia de tokens
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // Verifica si la dirección de destino ya está en la lista
        bool existe;
        for (uint256 i = 0; i < balancesarray.length; i++) {
            if (balancesarray[i] == _to) {
                existe = true;
                break; // Termina el ciclo si encuentra la dirección
            }
        }

        // Si la dirección no está en la lista, la agrega
        if (!existe) balancesarray.push(_to);
    }
}
