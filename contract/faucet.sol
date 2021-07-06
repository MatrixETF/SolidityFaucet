pragma solidity ^0.8.1;

interface ERC20 {

    function transfer(address to, uint256 value) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {

    uint256 constant public tokenAmount = 100000000000000000000;
    uint256 constant public waitTime = 30 minutes;

    mapping(address => ERC20) public tokenInstances;

    mapping(address => uint256) lastAccessTime;

    constructor(address[] memory _tokenAddresses) public {
        for (uint256 i = 0; i < _tokenAddresses.length; i ++) {
            tokenInstances[_tokenAddresses[i]] = ERC20(_tokenAddresses[i]);
        }
    }

    function requestTokens(address tokenAddress) public {
        require(allowedToWithdraw(msg.sender));
        tokenInstances[tokenAddress].transfer(msg.sender, tokenAmount);
        lastAccessTime[msg.sender] = block.timestamp + waitTime;
    }

    function allowedToWithdraw(address _address) public view returns (bool) {
        if (lastAccessTime[_address] == 0) {
            return true;
        } else if (block.timestamp >= lastAccessTime[_address]) {
            return true;
        }
        return false;
    }
}
