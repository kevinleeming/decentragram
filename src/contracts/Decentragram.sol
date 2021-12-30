pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  // Store images
  uint public imageCount = 0;
  mapping(uint => Image) public images;

  struct Image{
    uint id;
    string Hash;
    string description;
    uint tipAmount;
    address payable author;
    bool isImage;
  }

  event ImageCreated(
    uint id,
    string Hash,
    string description,
    uint tipAmount,
    address payable author,
    bool isImage
  );

  event ImageTipped(
    uint id,
    string Hash,
    string description,
    uint tipAmount,
    address payable author
  );

  // Create image
  function uploadImage(string memory _imgHash, string memory _description, bool isImage) public {
    require(bytes(_imgHash).length > 0);
    require(bytes(_description).length > 0);
    require(msg.sender != address(0x0));

    imageCount++;
    images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender, isImage);
    emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender, isImage);
  }

  // Tip images
  function tipImageOwner(uint _id) public payable {
    require(_id > 0 && _id <= imageCount);
    // Fetch image
    Image memory _image = images[_id];
    // Fetch author
    address payable _author = _image.author;
    // Pay the author by sending them Ether
    address(_author).transfer(msg.value);
    // Increment the tip amount
    _image.tipAmount = _image.tipAmount + msg.value;
    // Update the image
    images[_id] = _image;

    emit ImageTipped(_id, _image.Hash, _image.description, _image.tipAmount, _author);
  }
}