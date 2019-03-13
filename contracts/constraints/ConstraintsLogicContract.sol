pragma solidity ^0.5.0;

import "../administration/AdministrationInterface.sol";

contract ConstraintsLogicContract {

    // this needs to match the proxy's storage order
    address public constraintsLogicContract;

    /**
     * @dev The Administration Master Contract (Proxy)
     */
    AdministrationInterface public _admin;


    /**
    * @dev every user has their own mapping that can be filled with information
    * entry keys are uints derived from the `Code` enum and point to uint values which can represent anything
    */
    mapping(address => mapping(uint => uint)) userList;

    event Authorised(
        address msg_sender,
        address from,
        address to,
        uint256 value
    );

    enum Code {
        SEND,
        RECEIVE
    }

    modifier onlyConstraintEditor() {
        require(_admin.isConstraintsEditor(msg.sender));
        _;
    }

    function editUserList(address user, uint key, uint value) onlyConstraintEditor public returns (bool) {
        userList[user][key] = value;
        return true;
    }

    function getUserListEntry(address user, uint key) public view returns (uint value) {
        return userList[user][key];
    }

    function check(
        address _msg_sender,
        address _from,
        address _to,
        uint256 _value)
    public returns (
        bool authorized,
        string memory message)
    {

        // we don't use require here, because errors are not thrown through low-level calls like delegatecall
        // so we return the error message explicitly

        // SEND(0) == 1   check if from address can send
        if (userList[_from][uint(Code.SEND)] != 1) {
            return (false, "_from address cannot send");
        }

        // RECEIVE(1) == 1   check if to address can receive
        if (userList[_to][uint(Code.RECEIVE)] != 1) {
            return (false, "_to address cannot receive");
        }

        emit Authorised(_msg_sender, _from, _to, _value);
        return (true, "authorized");
    }

}