
pragma solidity  >=0.4.22 <0.8.0;
import "@OpenZeppelin/contracts/token/ERC20/ERC20.sol";
import "@OpenZeppelin/contracts/token/ERC20/ERC20Detailed.sol";

/**
   Rap token mock
  this fake rap will be used for testing only
 */
contract Rap is ERC20, ERC20Detailed {

    constructor() ERC20Detailed("RAP", "Rap token", 18) public {
       
    }
}

