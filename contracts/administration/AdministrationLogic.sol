pragma solidity ^0.5.0;


contract AdministrationLogic {

    // this needs to match the master's storage order
    address public administrationLogic;

    /**
     * @title _roles
     * @dev mapping for managing addresses assigned to a role.
     * cannot be changed, just like administrationLogic
     */
    mapping(uint8 => mapping(address => bool)) _roles;


    enum Role {
        ADMIN,
        ADMIN_UPDATER,
        CONSTRAINTS_UPDATER,
        MINTER,
        PAUSER,
        CONSTRAINTS_EDITOR,
        BURNER
    }

    event RoleAdded(uint8 role, address account);
    event RoleRemoved(uint8 role, address account);
    event RoleRenounced(uint8 role, address account);


    modifier _onlyAdmins() {
        require(_has(uint8(Role.ADMIN), msg.sender));
        _;
    }


    function add(uint8 role, address account) _onlyAdmins public {
        _add(role, account);
    }

    function remove(uint8 role, address account) _onlyAdmins public {
        _remove(role, account);
    }

    function renounce(uint8 role) public {
        require(_has(role, msg.sender));

        _remove(role, msg.sender);

        emit RoleRenounced(role, msg.sender);
    }



    /**
     * @dev give an account access to a role
     */
    function _add(uint8 role, address account) internal {
        require(account != address(0));
        require(!_has(role, account));

        _roles[role][account] = true;

        emit RoleAdded(role, account);
    }

    /**
     * @dev remove an account's access to a role
     */
    function _remove(uint8 role, address account) internal {
        require(account != address(0));
        // cannot remove own ADMIN role
        require(!(role == uint8(Role.ADMIN) && account == msg.sender));
        require(_has(role, account));

        _roles[role][account] = false;

        emit RoleRemoved(role, account);
    }

    /**
     * @dev check if an account has a role
     * @return bool
     */
    function _has(uint8 role, address account) internal view returns (bool) {
        require(account != address(0));
        return _roles[role][account];
    }


    function isAdmin(address account) public view returns (bool) {
        return _has(uint8(Role.ADMIN), account);
    }

    function isMinter(address account) public view returns (bool) {
        return _has(uint8(Role.MINTER), account);
    }

    function isPauser(address account) public view returns (bool) {
        return _has(uint8(Role.PAUSER), account);
    }

    function isConstraintsEditor(address account) public view returns (bool) {
        return _has(uint8(Role.CONSTRAINTS_EDITOR), account);
    }

    function isConstraintsUpdater(address account) public view returns (bool) {
        return _has(uint8(Role.CONSTRAINTS_UPDATER), account);
    }

    function isAdminUpdater(address account) public view returns (bool) {
        return _has(uint8(Role.ADMIN_UPDATER), account);
    }

    function isBurner(address account) public view returns (bool) {
        return _has(uint8(Role.BURNER), account);
    }

}



