pragma solidity ^0.4.15;
import "./Ownable.sol";

contract ERC20Interface {
  function transferFrom(address _from, address _to, uint _value) returns (bool){}
  function transfer(address _to, uint _value) returns (bool){}
  function ERC20Interface(){}
}

contract GenesisToken is Ownable {
  string  public name;
  string  public symbol;
  uint    public decimals;

  uint    public totalSupply;
  mapping(address=>uint) public balanceOf;

  function GenesisToken( address minter ) {
    transferOwnership(minter);
  }
  function GenesisToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
    UpgradeableToken(msg.sender) {

    // Create any address, can be transferred
    // to team multisig via changeOwner(),
    // also remember to call setUpgradeMaster()
    owner = msg.sender;

    name = _name;
    symbol = _symbol;

    totalSupply = _initialSupply;

    decimals = _decimals;

    // Create initially all balance on the team multisig
    balances[owner] = totalSupply;

    if(totalSupply > 0) {
      Minted(owner, totalSupply);
    }

    // No more new supply allowed after the token creation
    if(!_mintable) {
      mintingFinished = true;
      if(totalSupply == 0) {
        throw; // Cannot create a token without supply and no minting
      }
    }

  event Transfer(address indexed _from, address indexed _to, uint _value);
  event EndMinting( uint timestamp );

  function mint( address[] recipients ) onlyOwner {
    uint newRecipients = 0;
    for( uint i = 0 ; i < recipients.length ; i++ ){
      address recipient = recipients[i];
      if( balanceOf[recipient] == 0 ){
        Transfer( address(0x0), recipient, 1 );
        balanceOf[recipient] = 1;
        newRecipients++;
      }
    }

    totalSupply += newRecipients;
  }

  function endMinting() onlyOwner {
    transferOwnership(address(0xdead));
    EndMinting(block.timestamp);
  }

  function burn() {
    require(balanceOf[msg.sender] == 1 );
    Transfer( msg.sender, address(0x0), 1 );
    balanceOf[msg.sender] = 0;
    totalSupply--;
  }

  function emergencyERC20Drain( ERC20Interface token, uint amount ) onlyOwner {
      // callable by owner
      address emergencyDrainAddress = _emergencyDrainAddress;
      token.transfer( emergencyDrainAddress, amount );
  }
}

  // ERC20 stubs
  function transfer(address _to, uint _value) returns (bool){ revert(); }
  function transferFrom(address _from, address _to, uint _value) returns (bool){ revert(); }
  function approve(address _spender, uint _value) returns (bool){ revert(); }
  function allowance(address _owner, address _spender) constant returns (uint){ return 0; }
  event Approval(address indexed _owner, address indexed _spender, uint _value);
}
