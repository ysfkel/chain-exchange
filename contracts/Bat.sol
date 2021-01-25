
pragma solidity  >=0.4.22 <0.8.0;
import "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";
import "@OpenZeppelin/contracts/token/ERC20/ERC20Detailed.sol";

/**
   BAT mock
  this fake BAT will be used for testing only
 */
contract Bat is ERC20, ERC20Detailed {

    constructor() ERC20Detailed("BAT", "Brave browser token", 18) public {
       
    }
}

