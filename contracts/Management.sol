pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/ownership/HasNoEther.sol";

/**
 *   @title Contract that implements logic of management.
 *   @dev Implement logic of role management
 */
contract Management{

    /*** STORAGE ***/

    /// Number of admins. It cannot be less than 1 and greater than 256
    uint8 adminCount;

    /// State of contract. Some operations cannot be done if contract is paused
    bool public paused = false;

    // A mapping for approval that address is owner
    mapping (address => bool) ownerMapping;


    /*** EVENTS ***/

    // Emits when new admin was added
    event AdminWasAdded(address newAdmin);

    // Emits when admin was removed
    event AdminWasRemoved(address removedAdmin);

    // Emits when contract was paused
    event Pause();

    // Emits when contract was unpaused
    event Unpause();

    /*** MODIFIERS ***/

    /**
     *@dev Only admins modifier
     */
    modifier onlyAdmins() {
        require(isAdmin(msg.sender));
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is not paused.
     */
    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    /**
     * @dev Modifier to make a function callable only when the contract is paused.
     */
    modifier whenPaused() {
        require(paused);
        _;
    }


    /*** FUNCTIONS ***/

    /**
     * @dev Default constructor for Management contract
     * mgs.sender will be assigned as first admin
     * Constructor rejects incoming ether. The payable flag is added for access
     * to msg.value without warning
     */
    function Management() public payable {
        require(msg.value == 0);
        ownerMapping[msg.sender] = true;
        adminCount = 1;
    }

    /**
     *   @dev Adds new admin. Can be called only by existing admin
     *   @param newAdmin             Address of new admin
     */
    function addAdmin(address newAdmin) onlyAdmins public {
        // Require that number of admins is less than 256
        require(adminCount < 256);
        // Require that address is not zero
        require(newAdmin != 0x0);
        // Require that it's new admin
        require(!isAdmin(newAdmin));

        ownerMapping[newAdmin] = true;
        adminCount++;

        AdminWasAdded(newAdmin);
    }

    /**
     *   @dev Removes admin. Can be called only by multiple admins
     *   If admins count less than 3 it can be called by 1 admin
     *   @param adminAddress         Address of existing admin
     */
    function removeAdmin(address adminAddress) onlyAdmins public {
        // Require that number of admins is more than one
        require(adminCount > 1);
        // Require that address exists
        require(isAdmin(adminAddress));

        delete ownerMapping[adminAddress];
        adminCount--;

        AdminWasRemoved(adminAddress);
    }

    /**
    *   @dev Checks that the address is an administrator
    *   @param _address             Address of possible admin
    **/
    function isAdmin(address _address) internal constant returns (bool) {
        return ownerMapping[_address];
    }

    /**
     * @dev called by the owner to pause, triggers stopped state
     */
    function pause() onlyOwner whenNotPaused public {
        paused = true;
        Pause();
    }

    /**
     * @dev called by the owner to unpause, returns to normal state
     */
    function unpause() onlyOwner whenPaused public {
        paused = false;
        Unpause();
    }

    /**
     * @dev Disallows direct send by settings a default function without the `payable` flag.
     */
    function () external {
    }
}
