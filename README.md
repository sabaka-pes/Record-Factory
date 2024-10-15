# Record-Factory
In this project, the task was to create a contract that will spawn other contracts and put them in an array inside itself in order to demonstrate OOP skills.

There are three types of contracts to create: `StringRecord`, `AddressRecord` and `ENSRecord`. Each of these contracts has two public state variables and getters and setters. The `timeOfCreation` variable (the same for all contracts) is the time of record creation. The `record` variable is the record itself, a string or an address. For ENS, these are the `domain` and `owner` variables.

There is an `IRecord` interface, which describes the common functions of the three types of contracts.

There is a common `RecordsStorage` storage, which allows or does not allow other factory contracts to add records to itself.
The `RecordsStorage` contract has a public array of all added records inside it. The mapping (address => boolean value) `factories` contains information about which address is a factory and can add records to `RecordsStorage`.
- the `addRecord` function, which accepts a record and adds it to the array.
- the `addFactory` function, which accepts the address of a factory to give it access to adding records. Only the contract deployer can call this function. The `onlyOwner` modifier from the openzeppelin library is used for checking.

Since there are three types of records, there are also three factories, this is necessary for the flexibility of the program in the future.
- the internal function `onRecordAdding`, which calls addRecord for this contract.
The commented contract `Common Factory` replaces the functionality of three factories with one common one.
