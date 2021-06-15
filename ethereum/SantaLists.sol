pragma solidity >=0.7.0 <0.9.0;

contract SantaLists {
    uint niceFee;
    address owner;
    address[] members;
    mapping(address => bool) personToList;
    address[] niceList;
    address[] naughtyList;

    constructor(uint minimimNiceFee) {
        owner = msg.sender;
        niceFee = minimimNiceFee;
    }

    function join() external {
        members.push(msg.sender);
        niceList.push(msg.sender);
        personToList[msg.sender] = true;
    }

    function getLists() external view returns(address[] memory, address[] memory){
        return(niceList, naughtyList);
    }

    function switchLists(address person, uint index) public restricted {
        bool currentList = personToList[person];
        personToList[person] = !(currentList);
        if (currentList) {
            niceList[index] = niceList[niceList.length-1];
            niceList.pop();
            naughtyList.push(person);
        }else{
            naughtyList[index] = naughtyList[naughtyList.length-1];
            naughtyList.pop();
            niceList.push(person);
        }

    }

    function becomeNice(uint index) public payable {
        require(msg.value >= niceFee);
        niceList.push(msg.sender);
        naughtyList[index] = naughtyList[naughtyList.length-1];
        naughtyList.pop();
    }

    modifier restricted() {
        require(msg.sender == owner);
        _;
    }

}
