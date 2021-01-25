pragma solidity >=0.4.22 <0.8.0;

import "@OpenZeppelin/contracts/token/ERC20/IERC20.sol";

/**
  Featurs
  1. Token registry: registers a list of supported tokens 
  2. Wallet: manages a wallet which tracks users ether

  3. DAI integration; when you trade financial assets , you will always have a 
      base currency as well as a quote currency, the price of the base currency is 
      given in terms of the quote currency 
      eg the pair EUR/USD is 1.2 means you need to pay 1.2 USD to get 1 EUR where USD is the quote currency
      in the past for most exchanges, the quote curency was ether, 
      however , Eth is very volatile , so its not ideal as a quote currency ,
      instead we want to have something stable

      DAi is ony available on the mainnet or public testnets ,
      so to use DAI we will create a fake DAI
  
  4. Limit Order:
     A limit order is a buy or sell order with a limit price 
     For a buy order , the limit will be a maximum price 
     For a sell order , the limit will be a minimum price 

  5. Order
           
      
 */
contract Dex {

    enum Side {
        BUY,
        SELL
    }

    struct Order {
        uint id;
        Side side;
        //ticker of token to buy or sell
        bytes32 ticker;
        uint amount;
        //how much of the order was filled
        //an order can be partiallt filled, 
        //forinstance if order amount is 100 at order 
        //creation, filled will be equal 0
        //if a market oder matches this order for only 
        //50 , then filled will be 50, once flled 
        //becomes 100 by subsequent market orders 
        ///then the order will be complete
        uint filled;
        uint price;
        uint date;
    }
    
    struct Token {
        //we use bytes32 because 
        //string are not easy to manipulate
        bytes32 ticker;
        address tokenAddress;
    }

    mapping(bytes32 => Token) public tokens;
    bytes32[] public tokenList; 
    address public admin; 
    //order book. 
    //mapping of ticker to mapping of Side(buy or sell) to
    // order array sorted by best price
    mapping(bytes32 => mapping(uint => Order[])) public orderBook;
    //tracks the next order
    uint public nextOrderID;
    //Wallet
    mapping(address => mapping(bytes32 => uint)) public traderBalances;

    constructor() public {
        admin = msg.sender;
    }

    //registers supported token
    function addToken(bytes32 ticker, address tokenAddress) onlyAdmin() external {

         tokens[ticker] = Token(ticker, tokenAddress);
         tokenList.push(ticker);
    }

    //deposit token 
    function deposit(uint amount, bytes32 ticker) tokenExists(ticker) external {
       // approve THE DEX exchange to trade your tokens
       //and transfer the amount of token to the exchange
       //by calling the transferFrom method on the token
       //this increases the traders tokens on the DEX 
       IERC20(tokens[ticker].tokenAddress).transferFrom(msg.sender, address(this), amount);

       traderBalances[msg.sender][ticker] += amount;

    }


    function createLimitOrder(
        bytes32 ticker,
        uint amount,
        uint price,
        Side side
        ) tokenExists(ticker) external{
        //ensure the token is not DAI because DAI cannot be traded 
        //it is the quote currency 
        require(ticker != bytes32('DAI'),"cannot trade DAI");

        //for sell order, ensure trader has enough tokens 
        if(side == Side.SELL) {
            require(traderBalances[msg.sender][ticker] > amount, "token balance too low");
        } else {
            //else if it is a buy order, we need to make sure 
            //the trader has enough dai to buy the token 
            require(traderBalances[msg.sender][bytes32("DAI")]>= amount * price, "DAI balance too low");
        }

        //add order
        Order[] storage orders = orderBook[ticker][uint(side)]; 

        //we need to keep the orders with the best price at the start of the array
        // we need this ranking because of the way we match incoming orders
       //we will use bubble sort to order the orders
        orders.push(Order(
            nextOrderID,
            side, 
            ticker,
            amount, 
            0, //filled is initially 0,
            price,
            now //date
        ));

        uint i = orders.length - 1;
        //for buy orders we want the
        //highst prices at beginning 
        //for sell orders we want the contrary
        //SORT ORDERS USING BUBBLE SORT
        while(i > 0) {
           if(side == Side.BUY && (orders[i - 1].price > orders[i].price)) {
               break;
           }
           if(side == Side.SELL && (orders[1 - 1].price < orders[i].price)) {
               break;
           }

           Order memory order = orders[i - 1];
           orders[i - 1] = orders[i];
           orders[i] = order;
           i--;
        }
        nextOrderID++;

    }
    //allows trader to withdraw his tokens
    function withdraw(uint amount, bytes32 ticker) tokenExists(ticker) external {

        //ensure trader has balance >= amount
        require(traderBalances[msg.sender][ticker] >= amount,'balance too low');

        traderBalances[msg.sender][ticker] -= amount;
        IERC20(tokens[ticker].tokenAddress).transfer(msg.sender, amount);
    } 

    modifier onlyAdmin() {
        require(msg.sender == admin, 'only admin');
        _;
    }

    modifier tokenExists(bytes32 ticker) {
        require(tokens[ticker].tokenAddress!=address(0), 'unsuported token');
        _;
    }

    

}