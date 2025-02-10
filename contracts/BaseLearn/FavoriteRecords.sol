// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

//creo contato FavoriteREcords
contract FavoriteRecords {

    //creo mapping que almacenará albunes
    mapping(string => bool) private approvedRecords;
      
    //creo indice para almacenar la lista de albunes como índice
    string[] private approvedRecordsIndices;

    // creo mapping para almacenar los albunes de usuarios
    mapping(address => mapping(string => bool)) public userFavorites;
    // Array para almacenar los albunes de usuarios como índices
    mapping(address => string[]) private userFavoritesIndices;



    //@dev constructor con el método de crear un nuevo artista
    constructor() {
        agregaInicial("Thriller");
        agregaInicial("Back in Black");
        agregaInicial("The Bodyguard");
        agregaInicial("The Dark Side of the Moon");
        agregaInicial("Their Greatest Hits (1971-1975)");
        agregaInicial("Hotel California");
        agregaInicial("Come On Over");
        agregaInicial("Rumours");
        agregaInicial("Saturday Night Fever");
    }

    /**
     * @dev Funcion que agrega registros iniciales al mapping
     * @param _albumName El nombre del album a agregar
     */
    function agregaInicial(string memory _albumName) private {
            approvedRecords[_albumName] = true;
            approvedRecordsIndices.push(_albumName);
        
    }

    /*
    @dev funcion que devuelve la lusta de album aprovados
    @return  devuelve  un arrego con todos los albunes aprobados
    */
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordsIndices;
    }

  /*
    @dev funcion que devuelve la lusta de album aprovados
    @return  devuelve  un arrego con todos los albunes aprobados
    */
    function getUserFavorites (address _address) public view returns (string[] memory) {
        return userFavoritesIndices[_address];
    }

    /**
     * @dev Funcion para agregar registros de albunes de usuarios
     * @param _albumName El nombre del album a agregar
     */
    function addRecord(string memory _albumName) public {
       
      if (!approvedRecords[_albumName]) {
           revert NotApproved({_albumName: _albumName});
            
         }
         
            if (!userFavorites[msg.sender][_albumName]) {
                //agrego album favoritos
               userFavorites[msg.sender][_albumName] = true;
                // agrego album favoritos a indices
                userFavoritesIndices[msg.sender].push(_albumName);
              
            }
        
    }

    /**
     * @dev Funcion para resetear albunes favoritos
     */
    function resetUserFavorites() public {
        // Iterate through the user's favorite records
        for (uint256 i = 0; i < userFavoritesIndices[msg.sender].length; i++) {
            // Delete each record from the user's favorites mapping
            delete userFavorites[msg.sender][
                userFavoritesIndices[msg.sender][i]
            ];
        }
        // Delete the user's favorites index
        delete userFavoritesIndices[msg.sender];
    }

    /** 
    @dev Custom error to handle unapproved records
    @param _albumName Nombre del album con error
    */
    error NotApproved(string _albumName);
}
