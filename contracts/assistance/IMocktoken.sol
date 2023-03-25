import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMockToken is IERC20 {
    function mintTo(address receiver, uint amount) external;
}
