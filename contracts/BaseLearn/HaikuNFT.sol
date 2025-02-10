// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Importación del contrato ERC721 de OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

// Interfaz para interactuar con un contrato de envío de haikus
interface ISubmission {
    // Estructura que representa un haiku
    struct Haiku {
        address author; // Dirección del autor del haiku
        string line1; // Primera línea del haiku
        string line2; // Segunda línea del haiku
        string line3; // Tercera línea del haiku
    }

    // Función para acuñar un nuevo haiku
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external;

    // Función para obtener el número total de haikus
    function counter() external view returns (uint256);

    // Función para compartir un haiku con otra dirección
    function shareHaiku(uint256 _id, address _to) external;

    // Función para obtener los haikus compartidos con el llamador
    function getMySharedHaikus() external view returns (Haiku[] memory);
}

// Contrato para gestionar NFTs de Haikus
contract HaikuNFT is ERC721, ISubmission {
    Haiku[] public haikus; // Arreglo para almacenar haikus
    mapping(address => mapping(uint256 => bool)) public sharedHaikus; // Mapeo para rastrear haikus compartidos
    uint256 public haikuCounter; // Contador de haikus acuñados

    // Constructor para inicializar el contrato ERC721
    constructor() ERC721("KILLYSNFT", "FILL") {
        haikuCounter = 1; // Inicializa el contador de haikus
    }

    string salt = "Willys"; // Variable privada de tipo string

    // Función para obtener el número total de haikus
    function counter() external view override returns (uint256) {
        return haikuCounter;
    }

    // Función para acuñar un nuevo haiku
    function mintHaiku(
        string memory _line1,
        string memory _line2,
        string memory _line3
    ) external override {
        // Verifica si el haiku es único
        string[3] memory haikusStrings = [_line1, _line2, _line3];
        for (uint256 li = 0; li < haikusStrings.length; li++) {
            string memory newLine = haikusStrings[li];
            for (uint256 i = 0; i < haikus.length; i++) {
                Haiku memory existingHaiku = haikus[i];
                string[3] memory existingHaikuStrings = [
                    existingHaiku.line1,
                    existingHaiku.line2,
                    existingHaiku.line3
                ];
                for (uint256 eHsi = 0; eHsi < 3; eHsi++) {
                    string memory existingHaikuString = existingHaikuStrings[eHsi];
                    if (
                        keccak256(abi.encodePacked(existingHaikuString)) ==
                        keccak256(abi.encodePacked(newLine))
                    ) {
                        revert HaikuNotUnique();
                    }
                }
            }
        }

        // Acuñar el haiku como un NFT
        _safeMint(msg.sender, haikuCounter);
        haikus.push(Haiku(msg.sender, _line1, _line2, _line3));
        haikuCounter++;
    }

    // Función para compartir un haiku con otra dirección
    function shareHaiku(uint256 _id, address _to) external override {
        require(_id > 0 && _id <= haikuCounter, "Invalid haiku ID");

        Haiku memory haikuToShare = haikus[_id - 1];
        require(haikuToShare.author == msg.sender, "NotYourHaiku");

        sharedHaikus[_to][_id] = true;
    }

    // Función para obtener los haikus compartidos con el llamador
    function getMySharedHaikus()
        external
        view
        override
        returns (Haiku[] memory)
    {
        uint256 sharedHaikuCount;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                sharedHaikuCount++;
            }
        }

        Haiku[] memory result = new Haiku[](sharedHaikuCount);
        uint256 currentIndex;
        for (uint256 i = 0; i < haikus.length; i++) {
            if (sharedHaikus[msg.sender][i + 1]) {
                result[currentIndex] = haikus[i];
                currentIndex++;
            }
        }

        if (sharedHaikuCount == 0) {
            revert NoHaikusShared();
        }

        return result;
    }

    // Errores personalizados
    error HaikuNotUnique(); // Error cuando se intenta acuñar un haiku no único
    error NotYourHaiku(); // Error cuando se intenta compartir un haiku no propio
    error NoHaikusShared(); // Error cuando no hay haikus compartidos con el llamador
}
