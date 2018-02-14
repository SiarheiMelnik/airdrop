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
// tokenRepo я так понимая это и есть то куды надо сыпать при инициализации??
  event TokenDrop( address receiver, uint amount );
  function airDrop( ERC20 token,
                    address   tokenRepo,
                    address[] recipients,
                    uint amount,
                    bool PoA, // If PoA on balance
                    CustomToken cusToken ) onlyOwner {
    require( amount == 0 || amount == (2*(10**18)) || amount == (5*(10**18)) ); //воткнуть переменную мин занчение и макс(кол-во токенов) Тту от 2 до 5 если есть.

    if( amount > 0 ) {
      for( uint i = 0 ; i < recipients.length ; i++ ) {
          assert( token.transferFrom( tokenRepo, recipients[i], amount ) );
          TokenDrop( recipients[i], amount );
      }
    }
// тут логику хуйнуть надо
    if( cus ) {
      cusToken.mint(recipients);
    }

    numDrops += recipients.length;
    dropAmount += recipients.length * amount;
  }

  function tranferMinterOwnership(  CustomToken cusToken, address newOwner ) onlyOwner {
    cusToken.transferOwnership(newOwner);
  }

  function emergencyERC20Drain( ERC20 token, uint amount,address _emergencyDrainAddress ) onlyOwner {
      // callable only by owner
      emergencyDrainAddress = _emergencyDrainAddress;
      token.transfer( emergencyDrainAddress, amount );
  }
}
