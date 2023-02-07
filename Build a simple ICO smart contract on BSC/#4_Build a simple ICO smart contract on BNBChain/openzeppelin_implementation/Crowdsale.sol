pragma solidity ^0.5.0;
import "./MyToken.sol";

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundableCrowdsale.sol";




contract TokenCrowdsale is Crowdsale, MintedCrowdsale, TimedCrowdsale, RefundableCrowdsale {
    mapping(address => uint256) public contributions;
    
    constructor(
        uint256 rate,
        address payable wallet,
        MyToken token,
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _goal
    )
        Crowdsale(rate, wallet, token) 
        TimedCrowdsale(_openingTime, _closingTime)
        RefundableCrowdsale(_goal)
        public
    {
        // constructor body can stay empty
    }

    /**
    * @dev Returns the amount contributed so far by a sepecific user.
    * @param _beneficiary Address of contributor
    * @return User contribution so far
    */
    function getUserContribution(address _beneficiary)
        public view returns (uint256)
        {
            return contributions[_beneficiary];
        }
   
    /**
    * @dev Extend parent behavior requiring purchase to respect to record contributions.
    * @param _beneficiary Token purchaser
    * @param _weiAmount Amount of wei contributed
    */
    function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal
    {
        super._updatePurchasingState(_beneficiary, _weiAmount);
        uint256 _existingContribution = contributions[_beneficiary];
        uint256 _newContribution = _existingContribution.add(_weiAmount);
        contributions[_beneficiary] = _newContribution;
    }

}

contract TokenCrowdsaleDeployer {
    address public token_address;
    address public crowdsale_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint256 _goal
    )
        public
    {
        MyToken token = new MyToken(name, symbol);
        token_address = address(token);

        TokenCrowdsale token_crowdsale = new TokenCrowdsale(1, wallet, token, block.timestamp, block.timestamp+300, _goal);
        crowdsale_address = address(token_crowdsale);

        token.addMinter(crowdsale_address);
        token.renounceMinter();
    }
}
