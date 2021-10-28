pragma solidity ^0.8.0;
import "@openzeppelin/contracts/utils/Counters.sol";
import "./FractionManager.sol";


contract BlockshipNFTMarket  {
    address private FractionManagerContact;
    constructor(address _Fractionaddress){
        FractionManagerContact = _Fractionaddress;
    }
    FractionManager fractionContract = FractionManager(FractionManagerContact);
    using Counters for Counters.Counter;
    Counters.Counter private _itemIds;
    Counters.Counter private _itemsSold;
    // struct NFT market Item
    struct marketItem{
        uint itemId;
        string NFTName;
        string description;
        string URI;
        uint price;
        address seller;
        bool isFractioned;
        uint totalFractions;
    }
    // mapping for market item
    mapping (uint => marketItem)public idToMarketItem;
    // mapping id to boolean fraction
    mapping(uint => bool)public idToFractioCheck;
    // mapping for NFT item fraction count
    mapping(uint => uint)public idToFractionCount;
    // mapping for all fraction array
    mapping(uint => address[])public NFTFractionedAddresses;
    modifier add(uint _price){
        require(msg.sender != address(0),'invalid address');
        require(_price != 0,' price must be greater than zero');
        _;
    }
    function addNftItem(string memory _name, string memory _description,string memory _URI,
    uint _price, bool _isFractioned,
    uint _totalFractions, address[] calldata _fractionAddresses)external add(_price) returns(bool){
    _itemIds.increment();
    uint tempId = _itemIds.current();
    marketItem memory tempItem = marketItem({
       itemId : tempId,
       NFTName :_name,
       description : _description,
       URI : _URI,
       price : _price,
       seller : msg.sender,
       isFractioned : _isFractioned,
       totalFractions : _totalFractions
    });
    idToMarketItem[tempId] = tempItem;
    idToFractioCheck[tempId] = _isFractioned;
    idToFractionCount[tempId] = idToMarketItem[tempId].totalFractions;
    NFTFractionedAddresses[tempId] = _fractionAddresses;
    fractionContract.fractionNFT(tempId,_totalFractions,_price,msg.sender,_fractionAddresses);
    return true;
    }
    
    
    // function allNFT()public returns(marketItem){
    //     uint i = 0;
    //     while(i<=_itemIds.current()){
    //         return idToMarketItem[i];
    //         i + 1;
    //     }
    // }
    
    
}