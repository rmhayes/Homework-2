pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BettingContract.sol";

contract TestBettingContract {
	BettingContract betting = BettingContract(DeployedAddresses.BettingContract());

	function testChooseOracle() {
		address oracle = betting.chooseOracle(0x583031d1113ad414f02576bd6afabfb302140225);
		address expected = betting.oracle();
		Assert.equal(oracle, expected, "Oracle chosen by Owner should be registered.");
	}


	function testMakeDecision() {
		//test with call from non-oracle
		//test with call from oracle where there aren't 2 gamblers
		//test with call where there are 2 gamblers:
		//	- both win - check and see if winnings for both is updated
		//	- one wins - check and see if winnings for winner is updated
		// 	- nobody wins - check and see if winnings for oracle is updated
		//	- for all, check and see if contract is reverted after
	}

	function testMakeBet() {
		// check and see if first gambler becomes gamblerA
		// make sure gamblerA can't bet again
		// check and see if second gambler becomes gamblerB
		// make sure gamblerB can't bet again
		// make sure nobody else can make bets
		// make sure owner and oracle can't make bets
	}

	function testWithdraw() {
		// try with too high of funds, should be no change in balance
		// try with reasonable amt of funds, make sure winnings changes and function returns correct value
		// make sure msg.sender balance is updated

	}

	function testCheckWinnings() {
		// run a full bet, make sure winnings for all parties is updated
	}
	// // function testMakeBet() {
	// // 	address exampleA = 0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db;
	// // 	// betting.getCurrAddress.call({from:exampleA});
	// // 	bool boolA = betting.makeBet(1, {value: 50});
	// // 	// bool boolB = betting.makeBet({from: 0x583031d1113ad414f02576bd6afabfb302140225, value: 600});
	// // 	address gamblerA = betting.gamblerA();
	// // 	Assert.equal(boolA, true, "GamblerA should be set correctly.");
	// // 	Assert.equal(gamblerA, exampleA, "GamblerA should be set to correct address.");
	// // }

	function testCheckOutcomes() {
		uint[] outcomes;
		outcomes.push(1);
		outcomes.push(2);
		outcomes.push(3);
		uint[] storage expected = betting.checkOutcomes();
		Assert.equal(outcomes, expected, "Outcomes should be the array declared in ../migrations/2_deploy_contracts.js.");
	}

}
