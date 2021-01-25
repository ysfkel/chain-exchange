
pragma solidity  >=0.4.22 <0.8.0;
import "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";
import "@OpenZeppelin/contracts/token/ERC20/ERC20Detailed.sol";

/**
   DAI mock
  this fake dai will be used for testing only
 */
contract Dai is ERC20, ERC20Detailed {

    constructor() ERC20Detailed("DAI", "Dai stable coin", 18) public {
       
    }
}

