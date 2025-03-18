// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract NFTArtMarketplace {
    struct Artwork {
        uint id;
        address creator;
        string title;
        string description;
        uint price;
        bool forSale;
    }

    uint public nextId = 1;
    mapping(uint => Artwork) public artworks;

    event ArtworkCreated(uint id, address creator, string title, string description, uint price);
    event ArtworkSold(uint id, address buyer, uint price);

    function createArtwork(string memory _title, string memory _description, uint _price) public {
        artworks[nextId] = Artwork(nextId, msg.sender, _title, _description, _price, true);
        emit ArtworkCreated(nextId, msg.sender, _title, _description, _price);
        nextId++; 
    }

    function buyArtwork(uint _id) public payable {
        Artwork storage artwork = artworks[_id];
        require(artwork.forSale, "Artwork not for sale");
        require(msg.value == artwork.price, "Incorrect price");


        artwork.forSale = false;
        payable(artwork.creator).transfer(msg.value);
        emit ArtworkSold(_id, msg.sender, msg.value);
    }

    function toggleForSale(uint _id) public {
        Artwork storage artwork = artworks[_id];
        require(msg.sender == artwork.creator, "Only creator can change sale status");
        artwork.forSale = !artwork.forSale;
    }
}
