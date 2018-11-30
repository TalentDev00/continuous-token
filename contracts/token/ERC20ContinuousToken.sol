pragma solidity 0.4.25;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./ContinuousToken.sol";


contract ERC20ContinuousToken is ContinuousToken {
    ERC20 public reserveToken;

    constructor(
        string _name,
        string _symbol,
        uint32 _reserveRatio,
        ERC20 _reserveToken
    ) public ContinuousToken(_name, _symbol, _reserveRatio) {
        reserveToken = _reserveToken;
    }

    function () public { revert("Cannot call fallback function."); }

    function mint(uint256 _amount) public {
        require(reserveToken.transferFrom(msg.sender, address(this), _amount), "ERC20.transferFrom failed.");
        _continuousMint(_amount);
    }

    function burn(uint256 _amount) public {
        uint256 returnAmount = _continuousBurn(_amount);
        reserveToken.transfer(msg.sender, returnAmount);
    }
}