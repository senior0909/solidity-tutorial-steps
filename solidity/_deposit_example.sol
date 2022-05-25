
   
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import { ERC20 } from "./ERC20.sol";
import { ICrossDomainMessenger } from "@eth-optimism/rollup-contracts/build/contracts/bridge/CrossDomainMessenger.interface.sol";

import { console } from "@nomiclabs/buidler/console.sol";

contract DepositedERC20 is ERC20 {
    ICrossDomainMessenger crossDomainMessenger;
    address depositContractAddress;
    
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    )
        public
        ERC20(
            _initialAmount,
            _tokenName,
            _decimalUnits,
            _tokenSymbol
        )
    {

    }

    function init(address _depositContractAddress, address _crossDomainMessengerAddress) public {
        require(depositContractAddress == address(0));
        depositContractAddress = _depositContractAddress;
        crossDomainMessenger = ICrossDomainMessenger(_crossDomainMessengerAddress);
        
    }
    
    function mint(address _to, uint256 _amount) public returns (bool success) {
        require(crossDomainMessenger.crossDomainMsgSender() == depositContractAddress, "only the deposit contract can mint");
        balances[_to] += _amount;
        totalSupply += _amount;
        return true;
    }

    function withdraw(uint256 _amount) public {
        transfer(address(0), _amount);
        bytes memory messageData = abi.encodeWithSignature(
            "withdraw(address,uint256)",
            msg.sender,
            _amount
        );
        crossDomainMessenger.sendMessage(depositContractAddress, messageData);
    }
}