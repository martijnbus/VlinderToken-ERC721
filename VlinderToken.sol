// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.4.2/token/ERC721/extensions/ERC721Pausable.sol";
contract VlinderToken is ERC721, Ownable, ERC721Enumerable{
    using Strings for uint256;
    uint256 public maxSupply=10000;
    uint256 public maxMint=20;
    uint256 public cost=0.03 ether;
    bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
    constructor() ERC721("VlinderToken", "VTK") {}
 using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    
    function safeMint(address to, uint tokenId ) public onlyOwner {
        _safeMint(to, tokenId);
    }

     function mint(address _to, uint256 _mintAmount) public payable{
        require(_mintAmount>0);
        require(_mintAmount<=maxSupply);
      if (msg.sender!= owner ()){
          require(msg.value>= cost *_mintAmount);
      }
      for (uint i=1; i<= _mintAmount; i++){
          super._mint(_to, _tokenIdTracker.current());
        _tokenIdTracker.increment();   
      }   
    }
 function _baseURI() internal view virtual override returns (string memory) {
        return "https://mydomain/metadata/";
    }
   function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }
     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
    }

}

contract Portemonee is VlinderToken{

    function walletOfOwner(address _owner) public view returns (uint256[] memory){
    uint256 ownerTokenCount=balanceOf(_owner);
    uint256[] memory tokenIds= new uint256[](ownerTokenCount);
for (uint256 i; i<ownerTokenCount; i++){  tokenIds[i]=tokenOfOwnerByIndex (_owner, i);
}
return tokenIds;
}
}
