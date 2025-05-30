// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.30;

import {Test, console} from "forge-std/Test.sol";
import {SimpleTodoList} from "../src/ToDoList.sol";

contract ToDoListTest is Test {
    SimpleTodoList toDoListContract;

    address testUser = address(1);

    function setUp() public {
        toDoListContract = new SimpleTodoList();
    }

    function test_AddTask(string calldata _text) public {
        vm.prank(testUser);
        toDoListContract.addTask(_text);
        vm.prank(testUser);
        assertEq(toDoListContract.getMyTasks().length,1);
        vm.prank(testUser);
        assertFalse(toDoListContract.getMyTasks()[0].isDone);
        vm.prank(testUser);
        assertEq(toDoListContract.getMyTasks()[0].text,_text);
    }

    function test_UpdateTask(string calldata _oldText, string calldata _newText) public {
        vm.assume(bytes(_oldText).length < 10);
        vm.assume(bytes(_newText).length < 10);
        vm.prank(testUser);
        toDoListContract.addTask(_oldText);
        vm.prank(testUser);
        toDoListContract.updateTask(0,_newText);
        vm.prank(testUser);
        assertEq(toDoListContract.getMyTasks()[0].text,_newText);
    }

    function test_CompleteTask() public {
        vm.prank(testUser);
        toDoListContract.addTask("test");
        vm.prank(testUser);
        assertFalse(toDoListContract.getMyTasks()[0].isDone);
        vm.prank(testUser);
        toDoListContract.completeTask(0);
        vm.prank(testUser);
        assertTrue(toDoListContract.getMyTasks()[0].isDone);
    }

    function test_DeleteTask() public {
        vm.prank(testUser);
        toDoListContract.addTask("test");
        vm.prank(testUser);
        assertEq(toDoListContract.getMyTasks().length,1);
        vm.prank(testUser);
        toDoListContract.deleteTask(0);
        vm.prank(testUser);
        assertEq(toDoListContract.getMyTasks().length,0);
    }

    function test_ErrorNothingToDelete() public {
        vm.expectRevert();
        toDoListContract.deleteTask(0);
    }



}
