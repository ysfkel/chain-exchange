
pragma solidity  >=0.4.22 <0.8.0;
import "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";
import "@OpenZeppelin/contracts/token/ERC20/ERC20Detailed.sol";

/**
   Zrx mock
  this fake Zrx will be used for testing only
 */
contract Zrx is ERC20, ERC20Detailed {

    constructor() ERC20Detailed("ZRX", "0X token", 18) public {
       
    }
}

