pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./Government.sol";


/**
 * ERC20 for resources
 */
contract PotatoERC20 is ERC20 {
    using SafeMath for uint256;

    event GovTransfer(address from, address to, uint256 amount);

    Government government;

    constructor(address _gov) public {
        government = Government(_gov);
    }

    /**
     * modified `transfer` that checks if law allows corporation to directly transfer tokens
     *
     * Requirements:
     * - **government authorizes outside resource transfer**
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        require(government.allowOutsideResourceTransfer(address(this)));
        return super.transfer(recipient, amount);
    }

    /**
     * modified `transferFrom` that checks if law allows corporation to directly transfer tokens
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - **government authorizes outside resource transfer**
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        require(government.allowOutsideResourceTransfer(address(this)));
        return super.transferFrom(sender, recipient, amount);
    }

    /**
     * transfer operation that only allows government recognized contracts to transfer tokens and allows them to transfer any amount
     *
     * Requirements:
     * - **the caller must be authorized by the government.**
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function govTransferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        require(government.isAuthorizedForTransfer(address(this), _msgSender()));
        _transfer(sender, recipient, amount);
        emit GovTransfer(sender, recipient, amount);
        return true;
    }

}
