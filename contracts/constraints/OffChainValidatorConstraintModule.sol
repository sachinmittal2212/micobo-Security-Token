pragma solidity 0.5.12;

/*
import "../interfaces/IConstraintsModule.sol";
import "../interfaces/ISecurityToken.sol";


contract OffChainValidator is IConstraintsModule {

    // TODO

    ISecurityToken _securityToken;

    address _signer;

    string private _module_name;

    // module data
    address _signer;

    constructor(
        address tokenAddress,
        string memory module_name,
        address signer
    ) public {
        _owner = msg.sender;
        _module_name = module_name;
        _securityToken = ISecurityToken(tokenAddress);
        _signer = signer;
    }


    // function change signer


    function isValid(
        address msg_sender,
        bytes32 partition,
        address operator,
        address from,
        address to,
        uint256 value,
        bytes memory data,
        bytes memory operatorData
    )
    public
    returns (
        bool valid,
        string memory message
    )
    {

        // TODO ecrecover

        return (valid, message);
    }

    // VIEW

    function getModuleName() public view returns (string memory) {
        return _module_name;
    }

}
*/
