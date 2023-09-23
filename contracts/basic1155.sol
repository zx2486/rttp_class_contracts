// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "./Administrator.sol";
import "./token/ERC1155/ERC1155.sol";
import "./token/ERC1155/extensions/ERC1155Burnable.sol";

contract basic1155 is ERC1155, ERC1155Burnable, Adminstrator {
    uint256 private _totalSupply;
    mapping(uint => bool) public _isExist;
    mapping(uint256 => uint256) public tokenSupply;
    string public name;
    string public symbol;

    constructor()
        ERC1155(
            "ipfs://QmSt1dU4LF8jtfwPQF8Nr2Msda2BN4fJ6C5XNAod6RDNik/{id}.json"
        )
    {
        //Minting 1000 NFT with tokenID 0 to the sender address
        address _initialTokenAddress = msg.sender;
        mint(_initialTokenAddress, 1000, 0, "");
        //Minting 1 NFT with tokenID 1 to the sender address with custom URL
        mint(_initialTokenAddress, 1, 1, "");
        //Information of this collection
        name = "RTTP 23 Sep Class ERC1155";
        symbol = "R23Sep";
    }

    //The following are not standard functions
    function setNameSymbol(
        string memory newName,
        string memory newSymbol
    ) public onlyAdmin {
        name = newName;
        symbol = newSymbol;
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /**
     * Total number of NFT
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function totalSupply(uint256 _id) public view returns (uint256) {
        return tokenSupply[_id];
    }

    function getNewTokenID() public view virtual returns (uint256) {
        uint256 tokenId = _totalSupply;
        while (_isExist[tokenId]) {
            tokenId += 1;
        }
        return tokenId;
    }

    function mintToken(address account, uint256 amount) public onlyAdmin {
        mint(account, amount, getNewTokenID(), "");
    }

    //Minting new token, only admin can do it
    function mint(
        address account,
        uint256 amount,
        uint256 tokenId,
        bytes memory data
    ) public onlyAdmin {
        require(account != address(0), "basic1155: mint to the zero address");
        _mint(account, tokenId, amount, data);
        tokenSupply[tokenId] += amount;
        if (!_isExist[tokenId]) {
            _isExist[tokenId] = true;
            _totalSupply += 1;
        }
    }

    function mintBatch(
        address account,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyAdmin {
        require(account != address(0), "basic1155: mint to the zero address");
        _mintBatch(account, ids, amounts, data);
        for (uint256 i = 0; i < ids.length; i++) {
            uint256 tokenId = ids[i];
            tokenSupply[tokenId] += amounts[i];
            if (!_isExist[tokenId]) {
                _isExist[tokenId] = true;
                _totalSupply += 1;
            }
        }
    }

    //Burn token, only admin can do it
    function burnToken(
        address account,
        uint256 tokenId,
        uint256 amount
    ) public onlyAdmin {
        require(account != address(0), "basic1155: burn from zero address");
        require(_isExist[tokenId], "basic1155: token is not minted");
        _burn(account, tokenId, amount);
        tokenSupply[tokenId] -= amount;
        if (tokenSupply[tokenId] <= 0) {
            _isExist[tokenId] = false;
            _totalSupply -= 1;
        }
    }

    //fallback function
    /*fallback () external payable  { 
        revert(); 
    }
    //Prevent someone sending in ETH
    receive () external payable {
        revert();
    }
	*/

    //In case someone send in ETH to the token address, taking it out and give to admin
    /*function withdrawETH(uint256 amount) public onlyAdmin returns(uint256){
		require(amount > 0, "basicNFT: No amount to send");
		require(address(this).balance >=amount);
		address payable owner = payable(msg.sender);
		owner.transfer(amount);
		return 1;
	}
	//In case someone send in a ERC-20 token to the token address, taking it out and give to admin
    function withdrawErc20(address tokenAddr, uint256 amount) public onlyAdmin returns(uint256){
		require(amount > 0, "basicNFT: No amount to send");
		require(tokenAddr != address(0),"basicNFT: Cannot send to empty address");
		IERC20 token = IERC20(tokenAddr);
		address payable owner = payable(msg.sender);
		require(token.balanceOf(address(this)) >=amount);
		token.transfer(owner, amount);
		return 1;
	}*/
}
