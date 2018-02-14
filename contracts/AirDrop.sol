// Created using KyberAirDrop contract https://github.com/KyberNetwork/airdrop 
// Modyfied by YouTweak.iT https://github.com/youtweakit/airdrop for Token Wizard Usage

pragma solidity ^0.4.15;
import "./Ownable.sol";
import "./KyberGenesisToken.sol"; // how to connect to existing token for minting??? From API? or it's better to just send an ammount of tokens to this contract and use them for airdroping?

contract AirDrop is Ownable {
  uint public numDrops;
  uint public dropAmount;

  function AirDrop( address dropper ) {
    transferOwnership(dropper);
  }

  event TokenDrop( address receiver, uint amount );
  function airDrop( ERC20 token,
                    address   tokenRepo,
                    address[] recipients,
                    uint amount,
                    bool ihs,
                    KyberGenesisToken kgtToken ) onlyOwner {
    require( amount == 0 || amount == (2*(10**18)) || amount == (5*(10**18)) );

    if( amount > 0 ) {
      for( uint i = 0 ; i < recipients.length ; i++ ) {
          assert( token.transferFrom( tokenRepo, recipients[i], amount ) );
          TokenDrop( recipients[i], amount );
      }
    }

    if( kgt ) {
      kgtToken.mint(recipients);
    }

    numDrops += recipients.length;
    dropAmount += recipients.length * amount;
  }

  function tranferMinterOwnership( KyberGenesisToken kgtToken, address newOwner ) onlyOwner {
    kgtToken.transferOwnership(newOwner);
  }

  function emergencyERC20Drain( ERC20Interface token, uint amount,address _emergencyDrainAddress ) onlyOwner {
      // callable only by owner
      emergencyDrainAddress = _emergencyDrainAddress;
      token.transfer( emergencyDrainAddress, amount );
  }
}
