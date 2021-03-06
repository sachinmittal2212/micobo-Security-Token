pragma solidity 0.6.6;

import "../../node_modules/@openzeppelin/contracts/math/SafeMath.sol";

import "../interfaces/IConstraintModule.sol";
import "../interfaces/ISecurityToken.sol";


/**
 * @author Simon Dosch
 * @title VestingPeriodConstraintModule
 * @dev ConstraintModule
 * Define a vesting function including a locked period
 * Accounts can only transfer tokens when they are vested
 */
contract VestingPeriodConstraintModule is IConstraintModule {
	using SafeMath for uint256;

	/**
	 * @dev Address of securityToken this ConstraintModule is used by
	 */
	ISecurityToken private _securityToken;

	/**
	 * @dev Standard module name
	 */
	bytes32 private _module_name = bytes32("VESTING");

	// EVENTS
	/**
	 * @dev Emitted when vesting options are set
	 */
	event VestingOptionsSet(
		uint256 vestingStart,
		uint256 vestedFractionAfterStart,
		uint256 vestingRatio
	);

	// MODULE DATA
	/**
	 * @dev Time until vesting starts
	 */
	uint256 private _vestingStart;

	/**
	 * @dev Fraction vested after starting
	 */
	uint256 private _vestedFraction;

	/**
	 * @dev Fraction of tokens vested in 1 month
	 */
	uint256 private _vestingRatio;

	/**
	 * @dev Tracks amount already spent by users
	 */
	mapping(address => uint256) private _amountSpentByUser;

	/**
	 * [VestingPeriodConstraintModule CONSTRUCTOR]
	 * @dev Initialize VestingPeriodConstraintModule with security token address
	 * @param tokenAddress Address of securityToken this ConstraintModule is used by
	 */
	constructor(address tokenAddress) public {
		_securityToken = ISecurityToken(tokenAddress);
	}

	// MODULE FUNCTIONS
	/**
	 * @dev Sets vesting options
	 * @param vestingStart Timestamp in seconds when vesting should start
	 * @param vestedFractionAfterStart i.e. 4  => 1/4
	 * @param vestingRatio i.e. 48 => 1/48
	 */
	function setVestingOptions(
		uint256 vestingStart,
		uint256 vestedFractionAfterStart,
		uint256 vestingRatio
	) public {
		require(
			_securityToken.hasRole(
				bytes32("VESTING_PERIOD_EDITOR"),
				msg.sender
			),
			"!VESTING_PERIOD_EDITOR"
		);

		_vestingStart = vestingStart;
		_vestedFraction = vestedFractionAfterStart;
		_vestingRatio = vestingRatio;

		emit VestingOptionsSet(
			vestingStart,
			vestedFractionAfterStart,
			vestingRatio
		);
	}

	/**
	 * @dev Validates live transfer. Can modify state
	 * @param partition Partition the tokens are being transferred from
	 * @param from Token holder.
	 * @param value Number of tokens to transfer.
	 * @return valid transfer is valid
	 * @return reason Why the transfer failed (intended for require statement)
	 */
	function executeTransfer(
		address, /* msg_sender */
		bytes32 partition,
		address, /* operator */
		address from,
		address, /* to */
		uint256 value,
		bytes calldata, /* data */
		bytes calldata /* operatorData */
	) external override returns (bool, string memory) {
		// dormant Period not over
		if (now < _vestingStart) {
			return (false, "vesting has not started yet");
		}
		// dormant period is over

		uint256 allowed = getAmountAllowed(partition, from, value);

		// amount exceeds allowance minus amountAlreadySpent by this acount
		if (value > (allowed.sub(_amountSpentByUser[from]))) {
			return (false, "amount exceeds vested amount");
		}

		_amountSpentByUser[from] = _amountSpentByUser[from].add(value);
		return (true, "");
	}

	/**
	 * @dev Returns allowed amount at this point in time for a specific account
	 * @param partition Partition the transfer originates from
	 * @param from Account tokens are being transferred from
	 * @param value Amount that is being transferred
	 * @return uint256 Allowed amount to be transferred at the moment
	 */
	function getAmountAllowed(
		bytes32 partition,
		address from,
		uint256 value
	) internal view returns (uint256) {
		// calculate the original amount of tokens this account got
		uint256 userOriginalBalance = _securityToken
			.balanceOfByPartition(partition, from)
		// we need to add the value of this transfer as well
			.add(value)
			.add(_amountSpentByUser[from]);

		return
			// the starting amount after the dormant period has passed
			// (i.e 1/4 where 4 is the fraction, hence originalBalance / fraction)

			(userOriginalBalance.div(_vestedFraction))

			// add to this
				.add(
				// the original balance multiplied by
				userOriginalBalance
					.mul(
					// the seconds that have passed since the dormant period was over
					// now - vestingStart
					(now.sub(_vestingStart))
					// divided by 1 month in seconds, gives us the number in months
						.div(2628288)
				)
				// so by multiplying with the monthsPassed and now dividing by the fraction the amount grows every month
				// (i.e. 48),
					.div(_vestingRatio)
			);

		// we get the total amountAllowed at this point in time
	}

	/**
	 * @dev Returns _vestingStart
	 * @return uint256 _vestingStart
	 */
	function getVestingStart() public view returns (uint256) {
		return _vestingStart;
	}

	/**
	 * @dev Returns _vestedFraction
	 * @return uint256 _vestedFraction
	 */
	function getVestedFractionAfterStart() public view returns (uint256) {
		return _vestedFraction;
	}

	/**
	 * @dev Returns _vestingRatio
	 * @return uint256 _vestingRatio
	 */
	function getVestingRatio() public view returns (uint256) {
		return _vestingRatio;
	}

	/**
	 * @dev Returns _amountSpentByUser
	 * @param user Account to get amountSpent for
	 * @return uint256 _amountSpentByUser
	 */
	function getAmountSpentByUser(address user) public view returns (uint256) {
		return _amountSpentByUser[user];
	}

	/**
	 * @dev Returns module name
	 * @return bytes32 name of the constraint module
	 */
	function getModuleName() public override view returns (bytes32) {
		return _module_name;
	}
}
