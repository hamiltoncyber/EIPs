// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./openzeppelin/IERC165.sol";
import "./openzeppelin/IERC721.sol";

/**
 * @title ERC-726 Operating Cash Flow Standard
 * @dev See https://eips.ethereum.org/EIPS/eip-726
 * Note: the ERC-165 identifier for this interface is 0x************.
 */
interface IERC726 is IERC165, IERC721 {
    // enum {
    //     ETHER 0;

    // }
    struct Account {
        string name;
        uint8 index;
        uint256 domination;
        uint256 balance;
        bool active;
    }

    event Refund(address owner, uint256 tokenId, uint256 amount);
    event EtherInflow(address indexed source, uint256 amount);
    event EtherOutflow(address indexed receiver, uint256 amount);

    /**
     * @notice Request a refund for a token.
     * @dev - Caller must be the token owner; the token must not have been transferred; accumulated
     *        and benefit in munst not exceeds a certain amount of ether.
     *      - The token must be transferred to a pre-set unified address, e.g. Community Contract 
     *        address, when refund succeeds.
     * @param  tokenId The token id that the refund requests for.
     * MUST emit a {Refund} event.
     */

    function refund(uint256 tokenId) external;

    /**
     * @notice Send ether in to this contract account.
     * @dev - Caller should normally be registered to a certain account for inflowing ether. Received ether
     *        value is added to the balance of the registered account if caller was registered, otherwise
     *        to a default account.
     * MUST emit a {etherInflow} event.*/        
    function etherInflow() external payable;

    /**
     * @notice Send ether out from this contract account.
     * @dev - Caller MUST be the contract owner or an authorized operator.
            - To succeed in sending out ether, it must meet certain conditions.
     * @param - receiver, the address of which ether is sent out to. receiver should normally be registered
     *          to a certain account for outflowing ether. outflowed ether value is deducted from the balance
     *          of the registered account if receiver was registered, otherwise to a default account.
     * MUST emit a {etherOutflow} event.        
     */        

    function etherOutflow(address receiver, amount) external;

    /**
     * @notice Create an Account.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     * @param - accountName: name of the account to create, it must not exist yet.
     * @returns - account index
     */        
    function createAccount(string memory accountName) external returns(uint8);

    /**
     * @notice Change an Account name.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     * @param - oldName: name of the account to be changed, it must exist.
     *        - newName: name of the account to be changed to.
     * @returns - account index
     */
    function changeAccountName(string memory oldName, string memory newName) external returns(uint8);    /**

     * @notice Set active status of an Account to either true or false.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     * @param - accountName: name of the account for which the active status to set.
     *        - active_: active status of the account to set: either true or false.
     */        
    function setAccountStatus(string memory accountName, bool active_) external;

    /**
     * @notice Register an address to an account that the address will inflow asset to the account.
     * @dev - Caller MUST be the contract owner or an authorized operator.
            - One address is only allowed to register to one account for inflowing asset.
     * @param - inflower: address to be registered to the account.
              - accountName: name of the account to which the address inflower is registered.      
     */        
    function registerInflowAccount(address inflower, uint8 accountName) external;

    /**
     * @notice Register an address to an account that the account in this contract will outflow asset
     *         to the address.
     * @dev - Caller MUST be the contract owner or an authorized operator.
            - One address is only allowed to register to one account for outflowing asset.
     * @param - outflower: address to be registered to the account.
              - accountName: name of the account to which the address receiver is registered.
     */        
    function registerOutflowAccount(address receiver, uint8 accountName) external;

    /**
     * @notice Get account infomation of an NFT holder.
     * @param - tokenId:  tokenId of which account information to be retreive, it must exist.
     * @returns - array of Account
     */        
    function accountOf(uint256 tokenId) external returns(Account[]);

    /**
     * @notice Register NFT holders who will be entitled to for royalty distribution.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     */        
    function registerRoyaltyDistributees() external;

    /**
     * @notice Distribute royalty to certain NFT holders which are determined by registerRoyaltyDistributees.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     */        
    function distributeRoyalty() external;

    /**
     * @notice Register beneficiaries who will be entitled to for benefits distribution.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     */        
    function registerBenificiaries() external;

    /**
     * @notice Distribute benifits to beneficiaries who are determined by registerBenificiaries.
     *         the benefit can be either in ether or any kind of assets, e.g. ERC20 token, etc.
     * @dev - Caller MUST be the contract owner or an authorized operator.
     */        
    function distributeBenifit() external;

    /**
     * @notice Get net value in ether wei of an NFT holder.
     * @param - tokenId:  tokenId of which net value to be retreived, it must exist.
     * @returns - net value in ether wei
     */        
    function netValueOf(uint256 tokenId) external returns(uint256);

    /**
     * @notice Get to-be-distributed dividend value and yield of an NFT holder.
     * @param - tokenId:  tokenId of which devidend to be retreived, it must exist.
     * @returns - dividend value in ether wei and percentage
     */        
    function devidendOf(uint256 tokenId) external returns(uint256, uint256);

    /**
     * @notice Set the contract address Set net value in ether wei of an NFT holder.
     * @param - contractAddress_:  address of the contract.
     */        
    function setContractAddress(address contractAddress_) external;
}
