pragma solidity 0.4.26;
import "./Escrow.sol";
import "./MyToken.sol";

contract IcoAdmin {
address public coin_address;
address public ico_address;
mapping (address => bool) public whitelist;

event NewIco(address ico, uint256 id, uint256 duration, uint256 goal, address coinAddress);

//Add to whitelist
function addToWhitelist(address[] toAddAddresses) public{
        for (uint i = 0; i < toAddAddresses.length; i++) {
            whitelist[toAddAddresses[i]] = true;
        }
}

//Remove from whitelist
function removeFromWhitelist(address[]  toRemoveAddresses) public
{
    for (uint i = 0; i < toRemoveAddresses.length; i++) {
        delete whitelist[toRemoveAddresses[i]];
    }
}

//Deployer of ICO contracts, Coin and ICO
function create(
        address issuer,
        uint256 id,
        uint256 duration,
        uint256 goalVal,
        uint256 priceVal,
        string coinName,
        string coinSymbol,
        uint256 totalSupplyVal 
    ) public { 
        require(whitelist[msg.sender], "Not in Whitelist!");
        address platform = msg.sender;

        //Initialise Token 
        Coin coin = new Coin(coinName, coinSymbol, 18, totalSupplyVal, issuer);
        coin_address = address(coin);
        
        //Initialise ICOs 
        Ico ico = new Ico(platform, issuer, id, duration, goalVal, coin, priceVal, coin_address);
        ico_address = address(ico);

        emit NewIco(ico, id, duration, goalVal, coin_address);
    }

}
