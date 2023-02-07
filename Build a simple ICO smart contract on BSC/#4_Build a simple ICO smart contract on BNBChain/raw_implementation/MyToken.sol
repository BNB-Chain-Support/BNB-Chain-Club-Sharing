pragma solidity 0.4.26;

interface IERC20 {

    //Returns the amount of tokens in existence.
    function totalSupply() external view returns (uint256);
    // Returns the amount of tokens owned by `account`.
    function balanceOf(address account) external view returns (uint256);
    // Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner` through {transferFrom}. This is zero by default.
    function allowance(address owner, address spender) external view returns (uint256);
    //Returns a boolean value indicating whether the operation succeeded.
    function transfer(address recipient, uint256 amount) external returns (bool);
    function updateMapping(address _address, uint256 numTokens) external returns (bool);

    //Sets `amount` as the allowance of `spender` over the caller's tokens. Returns a boolean value indicating whether the operation succeeded.
    function approve(address spender, uint256 amount) external returns (bool);
    //Moves `amount` tokens from `from` to `to` using the allowance mechanism. `amount` is then deducted from the caller' allowance. Returns a boolean value indicating whether the operation succeeded.
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    //Emitted when `value` tokens are moved from one account (`from`) to another (`to`).
    event Transfer(address indexed from, address indexed to, uint256 value);
    //Emitted when the allowance of a `spender` for an `owner` is set by a call to {approve}. `value` is the new allowance.
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Successfulwithdraw(address indexed issuer_, uint256 balance);
    event ReceiveFunds(address sender, uint256 amount);
}


contract Coin is IERC20 {

    string public name;
    string public symbol;
    uint8 public decimals;
    address public issuer_;

    //hold the token balance of each owner account
    mapping(address => uint256) public balances;
    // all of the accounts approved to withdraw from a given account together with the withdrawal sum allowed for each
    mapping(address => mapping (address => uint256)) allowed;

    uint256 totalSupply_;

    //If you want to set 1 token per 0.001, meaning it's 1000 token per 1 ETH, set it this way:
   constructor(string nameVal, string symbolVal, uint8 decimalsVal, uint256 totalSupplyVal, address issuer) public {
        name = nameVal;
        symbol = symbolVal;
        decimals = decimalsVal;
        totalSupply_ = totalSupplyVal;
        issuer_ = issuer;
        // contract owner owns all token at start
        balances[issuer] = totalSupply_;
    }

    //return the number of tokens allocated by this contract
    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    //return the current token balance of an account, identified by its owner’s address.
    function balanceOf(address tokenOwner) public view returns (uint256) {
        return balances[tokenOwner];
    }

    function updateMapping(address _address, uint256 numTokens) public returns (bool) {
        // return balances[_address];
        balances[issuer_] = balances[issuer_] - numTokens;
        balances[_address] = balances[_address] + numTokens;
        return true;
    }

    //transfer tokens to another account
    function transfer(address receiver, uint256 numTokens) payable public returns (bool) {
        require(numTokens <= balances[tx.origin]);
        balances[tx.origin] = balances[tx.origin] - numTokens;
        balances[receiver] = balances[receiver] + numTokens;
        emit Transfer(tx.origin, receiver, numTokens);
        return true;
    }
    
    //approve delegate to withdraw new amount of tokens
    function approve(address delegate, uint256 numTokens) public returns (bool) {
        allowed[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    //returns the current approved number of tokens by an owner to a specific delegate, as set in the approve function.
    function allowance(address owner, address delegate) public view returns (uint) {
        return allowed[owner][delegate];
    }

    //allows a delegate approved for withdrawal to transfer owner funds to a third-party account.
    function transferFrom(address owner, address buyer, uint256 numTokens) public returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner]-numTokens;
        allowed[owner][msg.sender] = allowed[owner][msg.sender]-numTokens;
        balances[buyer] = balances[buyer]+numTokens;
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function() public payable { emit ReceiveFunds(msg.sender, msg.value); }

    //issuer withdraw fund upon successful campaign
    function withdraw() public returns (bool) {
            require (msg.sender == issuer_, "Only issuer can withdraw funds");
            // address payable issuer = payable(issuer_);
            uint256 amount =  address(this).balance;
            emit Successfulwithdraw(issuer_, amount);
            msg.sender.transfer(amount);
            return true;
        }
}
