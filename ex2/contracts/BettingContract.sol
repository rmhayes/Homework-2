pragma solidity ^0.4.15;

contract BettingContract {
	/* Standard state variables */
	address owner;
	address public gamblerA;
	address public gamblerB;
	address public oracle;
	uint[] outcomes;

	/* Structs are custom data structures with self-defined parameters */
	struct Bet {
		uint outcome;
		uint amount;
		bool initialized;
	}

	/* Keep track of every gambler's bet */
	mapping (address => Bet) bets;
	/* Keep track of every player's winnings (if any) */
	mapping (address => uint) winnings;

	/* Add any events you think are necessary */
	event BetMade(address gambler);
	event BetClosed();

	/* Uh Oh, what are these? */
	modifier OwnerOnly() {
		require(msg.sender == owner);
		_;
	}
	modifier OracleOnly() {
		require(msg.sender == oracle);
		_;
	}

	/* Constructor function, where owner and outcomes are set */
	function BettingContract(uint[] _outcomes) {
		outcomes = _outcomes;
		owner = msg.sender;
	}

	/* Owner chooses their trusted Oracle */
	function chooseOracle(address _oracle) OwnerOnly() returns (address) {
		if (_oracle != gamblerA && _oracle != gamblerB) {
			oracle = _oracle;
		}
		return oracle;
	}

	/* Gamblers place their bets, preferably after calling checkOutcomes */
	function makeBet(uint _outcome) payable returns (bool) {
		bool b = false;
		for (uint i = 0; i < outcomes.length; i++) {
			if (_outcome == outcomes[i]) {
				b = true;
			}
		}

		if (!b || msg.sender == owner || msg.sender == oracle || bets[msg.sender].initialized || (gamblerA != address(0) && gamblerB != address(0))) {
			revert();
			return false;
		}
        
		if (gamblerA == address(0)) {
			gamblerA = msg.sender;
		} else if (gamblerB == address(0)) {
		    gamblerB = msg.sender;
		}
		
		bets[msg.sender].outcome = _outcome;
		bets[msg.sender].amount = msg.value;
		bets[msg.sender].initialized = true;
		BetMade(msg.sender);
		return true;

	}

	/* The oracle chooses which outcome wins */
	function makeDecision(uint _outcome) OracleOnly() {
		bool b = false;
		for (uint i = 0; i < outcomes.length; i++) {
			if (_outcome == outcomes[i]) {
				b = true;
			}
		}

		if (!b || gamblerA == address(0) || gamblerB == address(0)) {
			revert();
		} else {
			if (bets[gamblerA].outcome == _outcome && bets[gamblerB].outcome == _outcome) {
				winnings[gamblerA] += bets[gamblerA].amount;
				winnings[gamblerB] += bets[gamblerB].amount;
			} else if(bets[gamblerA].outcome == _outcome) {
				winnings[gamblerA] += bets[gamblerA].amount;
				winnings[gamblerA] += bets[gamblerB].amount;
			} else if (bets[gamblerB].outcome == _outcome) {
				winnings[gamblerB] += bets[gamblerA].amount;
				winnings[gamblerB] += bets[gamblerB].amount;
			} else {
				winnings[oracle] += bets[gamblerA].amount;
				winnings[oracle] += bets[gamblerB].amount;
			}
			BetClosed();
			contractReset();
		}
	}

	/* Allow anyone to withdraw their winnings safely (if they have enough) */
	function withdraw(uint withdrawAmount) returns (uint remainingBal) {
		if (winnings[msg.sender] >= withdrawAmount) {
			winnings[msg.sender] -= withdrawAmount;
			msg.sender.transfer(withdrawAmount);
		} 
		return winnings[msg.sender];
	}
	
	/* Allow anyone to check the outcomes they can bet on */
	function checkOutcomes() constant returns (uint[]) {
		return outcomes;
	}
	
	/* Allow anyone to check if they won any bets */
	function checkWinnings() constant returns(uint) {
		return winnings[msg.sender];
	}

	/* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
	function contractReset() private {
		delete(bets[gamblerA]);
		delete(bets[gamblerB]);
		delete(gamblerA);
		delete(gamblerB);
		delete(oracle);
	}

	/* Fallback function */
	function() {
		revert();
	}
}
