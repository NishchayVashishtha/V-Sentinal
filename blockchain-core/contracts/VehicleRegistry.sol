// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VehicleRegistry {
    // Ye 'admin' tumhara SOC Analyst (Dashboard) hoga jo control karega
    address public admin;

    // Gaadi ka structure (Identity)
    struct Vehicle {
        bool isRegistered;
        bool isBanned;
        string vehicleId; // Example: "DL-4C-1234"
    }

    // Database: Public Key (Address) se Gaadi ki details map karna
    mapping(address => Vehicle) public vehicles;

    // Events (Ye React Dashboard par Live Alerts bhejenge)
    event VehicleAdded(address indexed vehicleAddress, string vehicleId);
    event VehicleBanned(address indexed vehicleAddress, string reason);
    event AttackLogged(address indexed attacker, string attackType, uint256 timestamp);

    // Modifier: Kuch actions sirf Admin kar sakta hai
    modifier onlyAdmin() {
        require(msg.sender == admin, "Access Denied: Only SOC Admin allowed");
        _;
    }

    // Jab contract deploy hoga, deploy karne wala Admin ban jayega
    constructor() {
        admin = msg.sender;
    }

    // 1. Nayi gaadi ko network me add karna (White-listing)
    function registerVehicle(address _vehicleAddress, string memory _vehicleId) public onlyAdmin {
        require(!vehicles[_vehicleAddress].isRegistered, "Vehicle is already registered");
        vehicles[_vehicleAddress] = Vehicle(true, false, _vehicleId);
        
        emit VehicleAdded(_vehicleAddress, _vehicleId);
    }

    // 2. The Kill Switch: Hacker ko permanently ban karna
    function banVehicle(address _vehicleAddress, string memory _reason) public onlyAdmin {
        require(vehicles[_vehicleAddress].isRegistered, "Vehicle not found in registry");
        vehicles[_vehicleAddress].isBanned = true;
        
        emit VehicleBanned(_vehicleAddress, _reason);
    }

    // 3. Gatekeeper Check: Python script isse poochegi ki kya ye gaadi valid hai?
    function isAuthorized(address _vehicleAddress) public view returns (bool) {
        return (vehicles[_vehicleAddress].isRegistered && !vehicles[_vehicleAddress].isBanned);
    }

    // 4. Incident Logging: Jab attack prevent ho jaye, to yahan record hoga
    function logAttack(address _attacker, string memory _attackType) public {
        emit AttackLogged(_attacker, _attackType, block.timestamp);
    }
}