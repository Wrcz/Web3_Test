// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.23;

// Importación de contratos de OpenZeppelin para manejo de ERC20 y conjuntos de direcciones
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";

// Contrato para votaciones ponderadas utilizando un token ERC20
contract WeightedVoting is ERC20 {
    string private salt = "itsmyryb"; // Variable privada de tipo string
    using EnumerableSet for EnumerableSet.AddressSet; // Uso de EnumerableSet para gestionar listas de direcciones

    // Definición de errores personalizados para situaciones específicas
    error TokensClaimed(); // Error cuando un usuario intenta reclamar tokens más de una vez
    error AllTokensClaimed(); // Error cuando ya no quedan tokens disponibles para reclamar
    error NoTokensHeld(); // Error cuando un usuario intenta participar sin tener tokens
    error QuorumTooHigh(); // Error si el quórum es mayor que el total de tokens disponibles
    error AlreadyVoted(); // Error cuando un usuario intenta votar más de una vez en el mismo tema
    error VotingClosed(); // Error cuando se intenta votar en un tema que ya ha sido cerrado

    // Estructura que representa un tema de votación
    struct Issue {
        EnumerableSet.AddressSet voters; // Lista de direcciones de votantes
        string issueDesc; // Descripción del tema a votar
        uint256 quorum; // Cantidad mínima de votos requerida para cerrar la votación
        uint256 totalVotes; // Total de votos emitidos
        uint256 votesFor; // Votos a favor
        uint256 votesAgainst; // Votos en contra
        uint256 votesAbstain; // Votos en abstención
        bool passed; // Indica si el tema fue aprobado
        bool closed; // Indica si la votación ha sido cerrada
    }

    // Estructura para serializar los datos de un tema de votación
    struct SerializedIssue {
        address[] voters; // Lista de votantes
        string issueDesc; // Descripción del tema
        uint256 quorum; // Quórum requerido
        uint256 totalVotes; // Total de votos
        uint256 votesFor; // Votos a favor
        uint256 votesAgainst; // Votos en contra
        uint256 votesAbstain; // Votos en abstención
        bool passed; // Indica si el tema fue aprobado
        bool closed; // Indica si la votación está cerrada
    }

    // Enum para representar las opciones de votación
    enum Vote {
        AGAINST, // En contra
        FOR, // A favor
        ABSTAIN // Abstención
    }

    Issue[] internal issues; // Lista de temas de votación
    mapping(address => bool) public tokensClaimed; // Registro de usuarios que han reclamado tokens

    uint256 public maxSupply = 1000000; // Suministro máximo de tokens
    uint256 public claimAmount = 100; // Cantidad de tokens que un usuario puede reclamar

    string saltt = "any"; // Otra variable de tipo string

    // Constructor que inicializa el token ERC20 con nombre y símbolo
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
        issues.push(); // Se agrega un tema vacío para comenzar desde el índice 1
    }

    // Función para reclamar tokens (cada usuario solo puede hacerlo una vez)
    function claim() public {
        if (totalSupply() + claimAmount > maxSupply) {
            revert AllTokensClaimed(); // Verifica si quedan tokens disponibles
        }
        if (tokensClaimed[msg.sender]) {
            revert TokensClaimed(); // Verifica si el usuario ya reclamó tokens
        }
        _mint(msg.sender, claimAmount); // Asigna los tokens al usuario
        tokensClaimed[msg.sender] = true; // Marca los tokens como reclamados
    }

    // Función para crear un nuevo tema de votación
    function createIssue(string calldata _issueDesc, uint256 _quorum) external returns (uint256) {
        if (balanceOf(msg.sender) == 0) {
            revert NoTokensHeld(); // Verifica que el usuario tenga tokens para crear un tema
        }
        if (_quorum > totalSupply()) {
            revert QuorumTooHigh(); // Verifica que el quórum no sea mayor que el total de tokens
        }
        Issue storage _issue = issues.push(); // Crea un nuevo tema de votación
        _issue.issueDesc = _issueDesc;
        _issue.quorum = _quorum;
        return issues.length - 1; // Retorna el índice del nuevo tema
    }

    // Función para obtener los detalles de un tema de votación
    function getIssue(uint256 _issueId) external view returns (SerializedIssue memory) {
        Issue storage _issue = issues[_issueId];
        return SerializedIssue({
            voters: _issue.voters.values(),
            issueDesc: _issue.issueDesc,
            quorum: _issue.quorum,
            totalVotes: _issue.totalVotes,
            votesFor: _issue.votesFor,
            votesAgainst: _issue.votesAgainst,
            votesAbstain: _issue.votesAbstain,
            passed: _issue.passed,
            closed: _issue.closed
        });
    }

    // Función para emitir un voto en un tema de votación
    function vote(uint256 _issueId, Vote _vote) public {
        Issue storage _issue = issues[_issueId];
        if (_issue.closed) {
            revert VotingClosed(); // Verifica si la votación sigue abierta
        }
        if (_issue.voters.contains(msg.sender)) {
            revert AlreadyVoted(); // Verifica si el usuario ya votó
        }

        uint256 nTokens = balanceOf(msg.sender);
        if (nTokens == 0) {
            revert NoTokensHeld(); // Verifica que el usuario tenga tokens para votar
        }

        // Registra el voto según la opción elegida
        if (_vote == Vote.AGAINST) {
            _issue.votesAgainst += nTokens;
        } else if (_vote == Vote.FOR) {
            _issue.votesFor += nTokens;
        } else {
            _issue.votesAbstain += nTokens;
        }

        _issue.voters.add(msg.sender); // Agrega el usuario a la lista de votantes
        _issue.totalVotes += nTokens; // Incrementa el total de votos emitidos

        // Si se alcanza el quórum, se cierra la votación y se determina el resultado
        if (_issue.totalVotes >= _issue.quorum) {
            _issue.closed = true;
            if (_issue.votesFor > _issue.votesAgainst) {
                _issue.passed = true;
            }
        }
    }
}
