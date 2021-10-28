pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract FractionManager is ERC721{
    constructor () ERC721('FractionManager','DFM'){}
    // struct for fraction track
    struct fractionItem{
        uint itemId;
        uint totalFraction;
        uint price;
        address sellerAddress;
        address[] fractioAddresses;
    }
    
    // mapping to store frationItem
    mapping(uint => fractionItem)public idToFractionItem;
    
    function fractionNFT(uint _itemId, uint _totalFraction,uint _price, address _seller, address[] calldata _fractionAddresses)external {
        fractionItem memory tempItem = fractionItem({
           itemId: _itemId,
           totalFraction : _totalFraction,
           price : _price,
           sellerAddress : _seller,
           fractioAddresses : _fractionAddresses
        });
        idToFractionItem[_itemId] = tempItem;
        _mint(address(this), _itemId);
    }

    
    function sellNFT(uint _itemId)external payable returns(bool){
        require(msg.sender != address(0),'invalid address');
        require(_itemId > 0,' NFT not available');
        require(msg.value == idToFractionItem[_itemId].price, 'amount must be equal to selling price');
        
        uint count = idToFractionItem[_itemId].totalFraction;
        uint fractionAmount = msg.value/ count;
        payable(address(this)).transfer(msg.value);
        address[] memory receiverAddress = idToFractionItem[_itemId].fractioAddresses;
        multisend(count,fractionAmount,receiverAddress);
        
        return true;
        
        
    }
    
    
    function multisend(uint _count, uint amount, address[] memory receiverAddress)private{
        uint i =0;
        while(i <=_count){
            payable(receiverAddress[i]).transfer(amount);
            i + 1;
        }
    }
}