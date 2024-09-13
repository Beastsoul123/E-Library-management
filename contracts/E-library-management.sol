pragma solidity 0.8.1;

contract ELibrary {
    // Mapping of resources to their metadata
    mapping (address => Resource) public resources;

    // Struct to represent a resource
    struct Resource {
        string title;
        string author;
        string description;
        address creator;
        uint256 timestamp;
        bytes32 license;
        bool isPublic;
    }

    // Event emitted when a new resource is added
    event NewResource(address indexed creator, address indexed resource);

    // Event emitted when a resource is accessed
    event ResourceAccessed(address indexed accessor, address indexed resource);

    // Modifier to check if the caller is the creator of a resource
    modifier onlyCreator(address resource) {
        require(resources[resource].creator == msg.sender, "Only the creator can perform this action");
        _;
    }

    // Function to add a new resource
    function addResource(string memory title, string memory author, string memory description, bytes32 license, bool isPublic) public {
        address newResource = address(new Resource(title, author, description, msg.sender, block.timestamp, license, isPublic));
        resources[newResource] = Resource(title, author, description, msg.sender, block.timestamp, license, isPublic);
        emit NewResource(msg.sender, newResource);
    }

    // Function to access a resource
    function accessResource(address resource) public {
        require(resources[resource].isPublic || msg.sender == resources[resource].creator, "Access denied");
        emit ResourceAccessed(msg.sender, resource);
    }

    // Function to update a resource's license
    function updateLicense(address resource, bytes32 newLicense) public onlyCreator(resource) {
        resources[resource].license = newLicense;
    }

    // Function to update a resource's public status
    function updatePublicStatus(address resource, bool newStatus) public onlyCreator(resource) {
        resources[resource].isPublic = newStatus;
    }
}
