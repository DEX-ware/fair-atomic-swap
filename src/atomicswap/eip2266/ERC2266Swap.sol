contract ERC875Interface {
    function trade(uint256 expiry, uint256[] tokenIndices, uint8 v, bytes32 r, bytes32 s) public payable;
    function passTo(uint256 expiry, uint256[] tokenIndices, uint8 v, bytes32 r, bytes32 s, address recipient) public;
    function name() public view returns(string);
    function symbol() public view returns(string);
    function getAmountTransferred() public view returns (uint);
    function balanceOf(address _owner) public view returns (uint256[]);
    function myBalance() public view returns(uint256[]);
    function transfer(address _to, uint256[] tokenIndices) public;
    function transferFrom(address _from, address _to, uint256[] tokenIndices) public;
    function approve(address _approved, uint256[] tokenIndices) public;
    function endContract() public;
    function contractType() public pure returns (string);
    function getContractAddress() public view returns(address);
 }


 contract ERC20Interface {
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function allowance(address tokenOwner, address spender) public view returns (uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}