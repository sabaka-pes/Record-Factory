// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/access/Ownable.sol";

// Interface combining AddressRecord, StringRecord and ENSRecord
interface IRecord {
    function getRecordType() external view returns(string memory);
    function timeOfCreation() external view returns(uint);
}

contract StringRecord is IRecord {
    uint public immutable timeOfCreation;
    string public record;

    constructor(string memory _str) {
        record = _str;
        timeOfCreation = block.timestamp;
    }

    function getRecordType() external pure override returns(string memory) {
        return "string";
    }

    function setRecord(string memory _str) external {
        record = _str;
    }
}

contract AddressRecord is IRecord {
    uint public immutable timeOfCreation;
    address public record;
  
    constructor(address _addr) {
        record = _addr;
        timeOfCreation = block.timestamp;
    }

    function getRecordType() external pure override returns(string memory) {
        return "address";
    }

    function setRecord(address _addr) external {
        record = _addr;
    }
}

contract ENSRecord is IRecord {
    uint public immutable timeOfCreation;
    string public domain;
    address public owner;

    constructor(string memory _domain, address _owner) {
        domain = _domain;
        owner = _owner;
        timeOfCreation = block.timestamp;
    }

    function getRecordType() external pure override returns(string memory) {
        return "ENS";
    }

    function setRecord(string memory _domain, address _addr) external {
        domain = _domain;
        owner = _addr;
    }
}

// Storage for records
contract RecordStorage is Ownable(msg.sender) {
    IRecord[] public records;
    mapping(address => bool) public factories;

    // Only factories can add records
    function addRecord(IRecord record) external {
        require(factories[msg.sender], "Not allowed");
        records.push(record);
    }

    // Only owner can add factories
    function addFactory(address factory) external onlyOwner {
        factories[factory] = true;
    }

    // Get record type from storage
    function getRecordType(uint index) external view returns (string memory) {
        require(index < records.length, "Index out of bounds");
        return records[index].getRecordType();
    }
}

// Factory for StringRecord
contract StringRecordFactory {
    RecordStorage public storageContract;

    constructor(address _storageAddress) {
        storageContract = RecordStorage(_storageAddress);
    }

    // Add string record
    function addRecord(string memory _record) public {
        StringRecord newStringRecord = new StringRecord(_record);
        onRecordAdding(newStringRecord);
    }

    // Adding to storage
    function onRecordAdding(IRecord record) internal {
        storageContract.addRecord(record);
    }
}

// Factory for AddressRecord
contract AddressRecordFactory {
    RecordStorage public storageContract;

    constructor(address _storageAddress) {
        storageContract = RecordStorage(_storageAddress);
    }

    // Add address record
    function addRecord(address _record) public {
        AddressRecord newAddressRecord = new AddressRecord(_record);
        onRecordAdding(newAddressRecord);
    }

    // Adding to storage
    function onRecordAdding(IRecord record) internal {
        storageContract.addRecord(record);
    }
}

// Factory for ENSRecord
contract EnsRecordFactory {
    RecordStorage public storageContract;

    constructor(address _storageAddress) {
        storageContract = RecordStorage(_storageAddress);
    }

    // Add ENS record
    function addRecord(string memory _domain, address _owner) public {
        ENSRecord newEnsRecord = new ENSRecord(_domain, _owner);
        onRecordAdding(newEnsRecord);
    }

    // Adding to storage
    function onRecordAdding(IRecord record) internal {
        storageContract.addRecord(record);
    }
}

// // Common Factory
// contract RecordFactory {
//     RecordStorage public storageContract;

//     constructor(address _storageAddress) {
//         storageContract = RecordStorage(_storageAddress);
//     }

//     function addStringRecord(string memory _record) public {
//         StringRecord newStringRecord = new StringRecord(_record);
//         onRecordAdding(newStringRecord);
//     }

//     function addAddressRecord(address _record) public {
//         AddressRecord newAddressRecord = new AddressRecord(_record);
//         onRecordAdding(newAddressRecord);
//     }

//     function addEnsRecord(string memory _domain, address _owner) public {
//         ENSRecord newEnsRecord = new ENSRecord(_domain, _owner);
//         onRecordAdding(newEnsRecord);
//     }

//     function onRecordAdding(IRecord record) internal {
//         storageContract.addRecord(record);
//     }
// }