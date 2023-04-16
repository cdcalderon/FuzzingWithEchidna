// SPDX-License-Identifier: AGPL-3.0
import "@openzeppelin/contracts/math/SafeMath.sol";

pragma solidity ^0.7.0;

contract Ownable {
    address public owner = msg.sender;

    function Owner() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }
}

contract Pausable is Ownable {
    bool private _paused;
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    function paused() public view returns (bool) {
        return _paused;
    }

    function pause() public onlyOwner {
        _paused = true;
    }

    function resume() public onlyOwner {
        _paused = false;
    }

    modifier whenNotPaused() {
        require(!_paused, "Pausable: Contract is paused.");
        _;
    }
}

contract Token is Ownable, Pausable {
    using SafeMath for uint256;
    mapping(address => uint256) public balances;

    // function transfer(address to, uint256 value) public whenNotPaused {
    //     balances[msg.sender] -= value;
    //     balances[to] += value;
    // }

    function transfer(address to, uint256 value) public whenNotPaused {
        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value);
    }
}
