# Lottery Smart Contract Project

This project implements a decentralized lottery system using **Solidity** and Foundry. Participants can enter the lottery, and a winner is selected randomly at the end of each round. The project demonstrates Solidity concepts such as modifiers, events, random number generation, and contract ownership.

---

## Features

1. **Decentralized Participation**:
   - Any user can enter the lottery by sending a specified entry fee.
2. **Random Winner Selection**:
   - A winner is chosen at random using Chainlink VRF (or pseudo-random logic, depending on implementation).
3. **Fairness and Transparency**:
   - All transactions and operations are recorded on the blockchain.
4. **Owner Control**:
   - Only the contract owner can start or end the lottery.

---

## Prerequisites

Before running the project, ensure you have the following installed:

- **Foundry**:
  - Install Foundry by running:
    ```bash
    curl -L https://foundry.paradigm.xyz | bash
    foundryup
    ```
- **Node.js** and **npm** (for Chainlink VRF setup, if required).

---

## Project Structure

```plaintext
|-- src/
|   |-- Lottery.sol        # Main Lottery Contract
|
|-- test/
|   |-- Lottery.t.sol      # Test cases for the Lottery Contract
|
|-- foundry.toml           # Foundry configuration file
|-- README.md              # Project documentation
```

---

## Setup and Installation

1. **Clone the Repository**:
   ```bash
   git clone <repository_url>
   cd LotteryContractProject
   ```

2. **Compile the Contract**:
   ```bash
   forge build
   ```

3. **Run Tests**:
   ```bash
   forge test -vvvv
   ```

4. **Deploy the Contract**:
   - Update the deployment script if needed and deploy the contract to your desired network.
   ```bash
   forge script DeployScript --broadcast --rpc-url <network_rpc_url>
   ```

---

## Contract Overview

### **Lottery.sol**

#### **State Variables**:
- `address[] public players;`
  - Stores the list of participants.
- `uint256 public entryFee;`
  - The fee required to enter the lottery.
- `address public owner;`
  - The contract owner.
- `bool public lotteryActive;`
  - Indicates whether the lottery is currently active.

#### **Modifiers**:
- `onlyOwner`:
  - Ensures that only the owner can perform certain actions.
- `lotteryIsActive`:
  - Ensures that the lottery is active before allowing participation.

#### **Functions**:
1. **Constructor**:
   - Sets the initial entry fee and owner.
2. **startLottery()**:
   - Activates the lottery (only the owner can call this).
3. **enterLottery()**:
   - Allows users to enter the lottery by sending the required entry fee.
4. **endLottery()**:
   - Ends the lottery, selects a random winner, and transfers the prize pool.
5. **getPlayers()**:
   - Returns the list of participants.

#### **Events**:
- `LotteryStarted()`:
  - Emitted when the lottery starts.
- `LotteryEntered(address indexed player)`:
  - Emitted when a player enters the lottery.
- `LotteryEnded(address indexed winner, uint256 amount)`:
  - Emitted when the lottery ends and a winner is selected.

---

## Testing the Contract

### **Test Cases**

1. **Lottery Initialization**:
   - Verify the contract initializes with the correct entry fee and owner.

2. **Start and End Lottery**:
   - Test the `startLottery()` and `endLottery()` functions.

3. **Player Participation**:
   - Ensure that players can only enter the lottery when it is active.
   - Verify the entry fee is deducted from the participant.

4. **Winner Selection**:
   - Confirm that the winner is selected fairly and receives the correct prize amount.

5. **Edge Cases**:
   - Test scenarios like attempting to enter the lottery without sending the required fee.

### **Run Tests**
Execute the following command to run all test cases:
```bash
forge test
```

---

## Deployment

### Steps to Deploy on Ethereum or Test Networks:

1. **Configure Network RPC**:
   - Update your `foundry.toml` with the desired network RPC URL and private key:
     ```toml
     [default]
     rpc_url = "<network_rpc_url>"
     private_key = "<your_private_key>"
     ```

2. **Deploy the Contract**:
   ```bash
   forge script DeployScript --broadcast --rpc-url <network_rpc_url>
   ```

3. **Verify the Contract**:
   - Use Etherscan or a similar block explorer to verify the deployed contract.

---

## Future Enhancements

1. **Integration with Chainlink VRF**:
   - Use Chainlink's VRF for true randomness in winner selection.
2. **Dynamic Entry Fee**:
   - Allow the owner to update the entry fee dynamically.
3. **Multiple Lottery Rounds**:
   - Support for running multiple rounds without redeploying the contract.
4. **Frontend Integration**:
   - Build a user-friendly interface for participants to interact with the lottery.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

- [Foundry Documentation](https://book.getfoundry.sh/)
- [Chainlink VRF](https://docs.chain.link/vrf/v2/introduction/)
- Ethereum Developer Community

