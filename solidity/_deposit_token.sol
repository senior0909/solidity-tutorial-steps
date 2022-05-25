// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

interface DaiToken {
    function transfer(address dst, uint256 amt) external returns (bool);

    function transferFrom(
        address src,
        address dst,
        uint256 amt
    ) external returns (bool);

    function balanceOf(address wlt) external view returns (uint256);
}

contract MyVault {
    address admin;
    uint256 public totalBalance;

    DaiToken public daiToken;

    event Deposit(address creator, uint256 amount);

    event Errormsg(string title);

    mapping(address => bool) public has_deposited;

    modifier onlyAdmin {
        require(msg.sender == admin, "Only admin can unlock escrow.");
        _;
    }

    constructor() {
        admin = msg.sender;
        daiToken = DaiToken(0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F);
    }

    function deposit(uint256 _amount) external payable returns (bool) {
        // amount should be > 0
        require(_amount > 0, "amount should be > 0");

        // caller balance should be >= _amount
        require(
            daiToken.balanceOf(msg.sender) >= _amount,
            "not enough balance"
        );

        // transfer Dai to this contract
        daiToken.transferFrom(msg.sender, address(this), _amount);

        has_deposited[msg.sender] = true;

        emit Deposit(msg.sender, _amount);

        return true;
    }
}