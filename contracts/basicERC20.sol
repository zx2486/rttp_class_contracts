// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.9;

import "./Administrator.sol";
import "./token/ERC20/ERC20.sol";
import "./token/ERC20/extensions/ERC20Burnable.sol";
import "./access/Ownable.sol";

/**
 * @title ERC20 token
 * @dev Very simple ERC20 Token example
 */
contract basicERC20 is ERC20, ERC20Burnable, Adminstrator {
    /**
     * @dev Constructor that gives msg.sender all of existing tokens.
     */
    constructor() ERC20("Class 23 Sep 2023", "Class23Sep") {
        uint256 totalSupply = 32 * (10 ** 5); //3.2 millions coins
        _mint(msg.sender, totalSupply * (10 ** uint256(decimals())));
    }

    function decimals() public view virtual override returns (uint8) {
        return 5;
    }

    ///fallback function
    /*fallback () external payable  { 
        revert(); 
    }*/
    //Receiving ETH
    /*receive () external payable {
        revert();
    }*/
    function withdrawETH(uint256 amount) public onlyAdmin returns (uint256) {
        require(amount > 0, "basicERC20: No amount to send");
        require(address(this).balance >= amount);
        owner.transfer(amount);
        return 1;
    }

    function withdrawErc20(
        address tokenAddr,
        uint256 amount
    ) public onlyAdmin returns (uint256) {
        require(amount > 0, "basicERC20: No amount to send");
        require(
            tokenAddr != address(0),
            "basicERC20: Cannot send to empty address"
        );
        IERC20 token = IERC20(tokenAddr);
        require(token.balanceOf(address(this)) >= amount);
        token.transfer(owner, amount);
        return 1;
    }
    /*
    function mintToken(address target, uint amount) public onlyAdmin returns(uint256){
        _mint(target,amount);
        return 1;
    }
    fucntion burnToken(address target, uint amount) public onlyAdmin return(uint256){
        burnFrom(target, amount);
        return 1;
    }
    function tokenForAnotherErc20(address tokenAddr,address targetAddr, uint256 amount) public onlyAdmin returns(uint256){
		require(amount > 0, "basicERC20: No amount to send");
		require(tokenAddr != address(0),"basicERC20: Cannot send to empty address");
		require(targetAddr != address(0), "basicERC20: transfer to zero address");
		IERC20 token = IERC20(tokenAddr);
		require(token.balanceOf(address(this)) >=amount);
		token.transfer(targetAddr, amount);
		_burn(targetAddr,amount);
		return 1;
	}*/
}
