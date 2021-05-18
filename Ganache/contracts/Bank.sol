pragma solidity >=0.4.22 <0.7.0;


/**
 * @title Bank
 * @dev Implements bank system
 */
contract Bank {
    uint256 private capital;
    address private owner;

    struct Client {
        address clientID;
        uint256 balance;
    }

    mapping(address => Client) private clients;

    constructor() public payable {
        owner = msg.sender;
        capital = 0;
    }

    function deposit() public payable {
        clients[msg.sender].clientID = msg.sender;
        clients[msg.sender].balance += msg.value;
        capital += msg.value;
    }
    
    function balance() public view returns (uint256) {
        if (clients[msg.sender].balance != 0) {
            return clients[msg.sender].balance;
        }
        return 0;
    }
    
    function get_capital() public view returns (uint256) {
        require(
            msg.sender == owner,
            "Only banker can see the total cash of the bank."
        );
        return capital;
    }

    function withdraw(uint256 amount) public returns (uint256) {
        if (clients[msg.sender].balance >= amount) {
            clients[msg.sender].balance -= amount;
            capital -= amount;
            msg.sender.transfer(amount);
            return amount;
        }
        return 0;
    }

    function transfer(address beneficiary, uint32 amount)
        public
        returns (bool)
    {
        if (clients[msg.sender].balance >= amount) {
            clients[msg.sender].balance -= amount;

            clients[beneficiary].clientID = beneficiary;
            clients[beneficiary].balance += amount;
            return true;
        }
        return false;
    }
}
