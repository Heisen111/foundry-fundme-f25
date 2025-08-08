// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from  "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {console} from "forge-std/console.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
     FundMe fundMe;

     address USER = makeAddr("user");
     uint constant SEND_VALUE = 0.1 ether;
     uint constant STARTING_VALUE = 10 ether;
     uint constant GAS_PRICE = 1;


    function setUp()  external {
     //     fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
     DeployFundMe deployFundMe = new DeployFundMe();
     fundMe = deployFundMe.run();
     vm.deal(USER, STARTING_VALUE);
    }

    function testDemo() public view {
      assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
     assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVersionIsAccurate() public view{
     uint256 version = fundMe.getVersion();
     assertEq(version, 4);
    }

    function testFundFailsWithoutEnoughETH() public {
      vm.expectRevert();
      fundMe.fund();
    }

    function testFundUpdatesFundedDs() public {
      vm.prank(USER);
      fundMe.fund{value: SEND_VALUE}();
      uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
      assertEq(amountFunded, SEND_VALUE);
    }

    function testAddFundersToArrayOfFunders() public {
      vm.prank(USER);
      fundMe.fund{value: SEND_VALUE}();
      address funder = fundMe.funders(0);
      assertEq(funder, USER);
    }

    modifier funded(){
      vm.prank(USER);
      fundMe.fund{value: SEND_VALUE}();
      _;
    }

    function testOnlyOwnerCanWithdraw() public funded{
      vm.prank(USER);
      vm.expectRevert();
      fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public funded{
      //arrange
      uint256 startBalance = fundMe.getOwner().balance;
      uint256 startFundMeBalance = address(fundMe).balance;

      //act
      uint256 gasStart = gasleft();
      vm.txGasPrice(GAS_PRICE);
      vm.prank(fundMe.getOwner());
      fundMe.withdraw();
      uint gasEnd = gasleft();
      uint256 gasUsed = (gasStart - gasEnd)* tx.gasprice;
      console.log(gasUsed);

      //assert
      uint endOwnerBalance = fundMe.getOwner().balance;
      uint256 endFundMeBalance = address(fundMe).balance;
      assertEq(endFundMeBalance, 0);
      assertEq(startBalance + startFundMeBalance, endOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded{
      //arrange
      uint160 noOfFunders = 10;
      uint160 startIndex = 1;
      for(uint160 i= startIndex; i < noOfFunders; i++){
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();

      }

      uint256 startBalance = fundMe.getOwner().balance;
      uint256 startFundMeBalance = address(fundMe).balance;

      //Act
      vm.startPrank(fundMe.getOwner());
      fundMe.withdraw();
      vm.stopPrank();

      //assert
      uint endOwnerBalance = fundMe.getOwner().balance;
      uint256 endFundMeBalance = address(fundMe).balance;
      assert(endFundMeBalance == 0);
      assert(startFundMeBalance + startBalance == endOwnerBalance);

    }

    function testWithdrawWithMultipleFundersCheaper() public funded{
      //arrange
      uint160 noOfFunders = 10;
      uint160 startIndex = 1;
      for(uint160 i= startIndex; i < noOfFunders; i++){
        hoax(address(i), SEND_VALUE);
        fundMe.fund{value: SEND_VALUE}();

      }

      uint256 startBalance = fundMe.getOwner().balance;
      uint256 startFundMeBalance = address(fundMe).balance;

      //Act
      vm.startPrank(fundMe.getOwner());
      fundMe.cheaperWithdraw();
      vm.stopPrank();

      //assert
      uint endOwnerBalance = fundMe.getOwner().balance;
      uint256 endFundMeBalance = address(fundMe).balance;
      assert(endFundMeBalance == 0);
      assert(startFundMeBalance + startBalance == endOwnerBalance);

    }
}