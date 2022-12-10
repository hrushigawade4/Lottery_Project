//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{

    address payable[] public players;
    address manager;
    address payable public winner;

    constructor(){
        manager = msg.sender;
    }


    receive() external payable{
        require(msg.value==1 ether,"Please pay 1 ether only");
        players.push(payable(msg.sender));
    }

    function getBalance() public view returns(uint){
        require(manager==msg.sender,"You are not the Manager");
        return address(this).balance;
    }

    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        require(msg.sender==manager,"You are not the manager");
        require(players.length>=3,"Players are less than 3");

        uint r = random();

        uint index = r%players.length; //100%3=1  24%3=0
        winner=players[index];
        winner.transfer(getBalance());

        players = new address payable[](0);
    }

        function allPlayers() public view returns(address payable[] memory){
            return players;
        }

        


}

// test network address
// 0x670A811D1dBBC0F596F11a3BAFEf2a940c86D4e9
// 0x17eCCF5C23Ce5454948Fd8E39C8E68077AD3Ab40
// 0x53461a64240c2e4b350712181E5BbE71290C46Ae

// ganache contract deployment address
// 0x5F9684a50741EED588E3EFcC664433AFD8aB3D9C
// 0xAf1784d26906E33115B659dB99312ADa7E9259F8

// final deploy
// 0xe2AEF72B37921c45Df6C1Ca730840059026B3EFE