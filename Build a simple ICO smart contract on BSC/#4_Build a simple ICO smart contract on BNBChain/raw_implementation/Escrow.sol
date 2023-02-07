pragma solidity 0.4.26;

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a + b;
        assert(c >= a);
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
        c = a - b;
        assert(c <= a);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
        assert(b != 0);
        return a/b;
    }
}

import "./MyToken.sol";


contract Ico {
using SafeMath for uint256;

bool private active;            // keeps track if the ICO is still active
address private issuer;         // issuer of the ICO, who receives the proceeds
address private platform;       // platform of the issuance, who receives the fees
address private tokenAddress;   // address of token contract
uint256 private id;             // id of ICO on DB Server
uint256 private endTime;        // endTime of ICO
uint256 private goal;           // goal of ICO
uint256 private currentFunds;   // the current amount of funds raised
mapping(address => uint) public fundsByUser;   // total funds submitted by each user
mapping(address => uint) private toCoin;        // how much of the coin each user gets
address[] private funders;      // keys of the above two mappings
bool private canWithdraw;       // indicates if the funds can be withdrawn
Coin private coin;              // token to which the ICO is bound
uint256 private price;          // price in wei for which a token can currently be bought
uint private FEEcontributor = 0;    // fixed fee to be paid by the investor on every funding
uint private FEEissuer = 0;     // fixed fee to be paid by the issuer
uint256 private toGiveOut;      // total supply of the coin left for sale

event IcoEnded(uint256 id, uint256 funded, uint256 goal);
event IcoFunded(uint256 id, uint256 amount, uint256 funded, uint256 goal);


//Initiate a Crowdsale
constructor (
        address platformVal,
        address issuerVal,
        uint256 idVal,
        uint256 endTimeVal,
        uint256 goalVal,
        Coin theCoin,
        uint256 priceVal,
        address coin_address
    ) public {
        require(theCoin.balanceOf(issuerVal)>0, "Zero Supply of Token for sale!");
        platform = platformVal;
        issuer = issuerVal;
        id = idVal;
        endTime = endTimeVal + block.timestamp;
        goal = goalVal;
        active = true;
        canWithdraw = false;
        currentFunds = FEEissuer;
        fundsByUser[platform] = FEEissuer;
        coin = theCoin;
        toGiveOut = coin.balanceOf(issuer);
        price = priceVal;
        tokenAddress = coin_address;
    }

//Get info of crowdsale
function getInfo() public view returns (
        address issuerVal,
        uint256 idVal,
        uint256 endTimeVal,
        uint256 goalVal,
        bool activeVal,
        uint256 currentFundsVal,
        bool canWithdrawVal,
        Coin theCoin,
        uint256 currentPrice
    ) {
        return (issuer, id, endTime, goal, active, currentFunds, canWithdraw, coin, price);
    }

//Cancel ongoing active crowdsale
function cancel() public {
        require (tx.origin == issuer, "Only issuer can cancel the ICO");
        require (active, "Only active ICOs can be cancelled");

        active = false;
        canWithdraw = true;
        emit IcoEnded(id, currentFunds, goal);
    }

//end ICOs and distribute token to contributors, funds to issuer wallet
function end() payable public returns (bool) {
        require (tx.origin == issuer, "Only issuer can end the ICO"); //msg.sender
        require (active, "Only active ICOs can be ended");
        require (currentFunds >= goal, "Only successful ICOs can be ended");
        require (block.timestamp >= endTime, "Duration of ICOs has not come to an end");


        active = false;
        canWithdraw = false;
        emit IcoEnded(id, currentFunds, goal);

        for (uint i = 0; i<funders.length; i++){
            coin.transfer(funders[i], toCoin[funders[i]]);
        }
        
        //transfer fund to mytoken contract
        address(coin).transfer(address(this).balance);
       
        return true;
    }

//funds distribution to all parties and update token balances
function contribute() payable public {
        require (active, "One can only contribute to active ICOs");
        require (endTime >= block.timestamp, "This ICO has run out of time");
        require ((msg.value.sub(FEEcontributor)).div(price) <= toGiveOut, "Cannot buy this much, sold out!" );

        if (fundsByUser[msg.sender] == 0) {
            funders.push(msg.sender);
        }

        //update funds contributed by each user, after minus platform fee
        fundsByUser[msg.sender] = fundsByUser[msg.sender].add(msg.value.sub(FEEcontributor));
        // update platform fund with platform fee per user contribution
        fundsByUser[platform] = fundsByUser[platform].add(FEEcontributor); //Safemath lib
        // update the current amount of fund raised
        currentFunds = currentFunds.add(msg.value.sub(FEEcontributor));
        emit IcoFunded(id, msg.value.sub(FEEcontributor), currentFunds, goal);
        //update amount of token for each user owns
        toCoin[msg.sender] = toCoin[msg.sender].add((msg.value.sub(FEEcontributor)).div(price));
        // coin.updateMapping(msg.sender, (msg.value.sub(FEEcontributor)).div(price));
        // toGiveOut = coin.balanceOf(issuer);

        // update supply of coin, decreasing per contribution
        toGiveOut = toGiveOut - (msg.value.sub(FEEcontributor)).div(price);
    }

 //return the number of tokens avail for sale
function getToGiveOut() public view returns (uint256) {
    return toGiveOut;
}


//return the current Fund Rasied
function getCurrentFundRaised() public view returns (uint256) {
    return currentFunds;
}

//has goal been met
function metGoal() public view returns (bool) {
    if(currentFunds >= goal){
        return true;
    }
    return false;
}

//change price in wei for which a token can be bought at
function changePrice(uint256 newPrice) public {
        require (tx.origin == issuer, "Only issuer can change the price");
        price = newPrice;
}

// refund
function withdraw() payable public returns (bool) {
        require (!active, "Can only withdraw from inactive ICOs");
        require (canWithdraw, "Can only withdraw from cancelled ICOs");

        uint256 amount = fundsByUser[msg.sender];

        if (amount > 0) {
                fundsByUser[msg.sender] = 0;

                if (!msg.sender.send(amount)) {
                        fundsByUser[msg.sender] = amount;
                        return false;
                }
                return true;
        }
        return true;
    }
}


