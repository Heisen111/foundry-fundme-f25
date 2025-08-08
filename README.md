# FundMe — Foundry

>  README for the **FundMe** project implemented using **Foundry**, based on the Cyfrin Updraft tutorial.

---

## Table of contents

1. [Project Overview](#project-overview)
2. [Features](#features)
3. [Tech Stack](#tech-stack)
4. [Repository Structure](#repository-structure)
5. [Prerequisites](#prerequisites)
6. [Installation & Setup](#installation--setup)
7. [Environment Variables](#environment-variables)
8. [Run Locally (Development)](#run-locally-development)
9. [Testing](#testing)
10. [Deployment](#deployment)
11. [Contract Details](#contract-details)
12. [Security & Audit Notes](#security--audit-notes)
13. [Gas & Optimization Notes](#gas--optimization-notes)
14. [Contributing](#contributing)
15. [License & Credits](#license--credits)

---

## Project Overview

**FundMe** is a simple crowdfunding smart contract system written in Solidity and built & tested with Foundry. The contract allows users to send ETH to fund a contract and allows the contract owner to withdraw funds. The project includes unit tests, mocks for price feeds, deployment scripts, and verification helpers.

This README was created for a professional repo deliverable — includes developer-friendly commands, environment setup, and security guidance.

---

## Features

* Accept ETH contributions from any address.
* Track contributions per address.
* Owner-only withdrawal functionality.
* Integration with a price feed (via a `PriceConverter` helper or mock aggregator) to enforce minimum funding amounts in USD terms.
* Comprehensive unit tests using Foundry.
* Local development with `anvil` for chain forking and fast iteration.

---

## Tech Stack

* Solidity (>=0.8.x)
* Foundry (forge, anvil, cast)
* Optional: Hardhat / Ethers (only if integrating with JS tooling)

---

## Repository Structure (example)

```
├─ .env
├─ foundry.toml
├─ src/
│  ├─ FundMe.sol
│  ├─ PriceConverter.sol
│  └─ mocks/MockV3Aggregator.sol
├─ script/
│  └─ DeployFundMe.s.sol
├─ test/
│  └─ FundMe.t.sol
└─ README.md
```

Adjust paths if your project differs.

---

## Prerequisites

* Git
* Foundry (recommended install: Foundryup)
* Node.js (only if you plan to use JS tooling)

Quick Foundry install (one-liner):

```bash
# Install foundryup (official installer)
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

Start a local chain with Anvil (bundled with Foundry):

```bash
anvil
```

---

## Installation & Setup

1. Clone the repository:

```bash
git clone <your-repo-url>
cd <your-repo-folder>
```

2. Install Foundry (see Prerequisites).

3. Create a `.env` file in the project root (see the next section for variables).

4. Install any optional JS dependencies if you have front-end scripts.

---

## Environment Variables

Create a `.env` file containing sensitive information. Example:

```text
RPC_URL=<YOUR_RPC_URL>        # e.g. Alchemy / Infura RPC for the target network
PRIVATE_KEY=<DEPLOYER_KEY>    # Deployer private key (keep safe)
ETHERSCAN_API_KEY=<key>       # For contract verification (optional)
```

> **Security:** Never commit `.env` or private keys to git. Add `.env` to `.gitignore`.

---

## Run Locally (Development)

1. Start a local Anvil node (recommended):

```bash
anvil
```

2. Deploy to Anvil using Foundry script (broadcast):

```bash
forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key <ANVIL_PRIVATE_KEY> --broadcast
```

3. Interact with deployed contract using `cast`:

```bash
# Example: call a read-only function
cast call <contract_address> "getOwner()(address)" --rpc-url http://127.0.0.1:8545

# Example: send ETH (fund)
cast send --private-key <KEY> <contract_address> "fund()"  --value 0.1ether --rpc-url http://127.0.0.1:8545
```

> Tip: Use the first private key printed by `anvil` for quick local testing.

---

## Testing

Run tests with Foundry's `forge`:

```bash
# Run all tests (verbose)
forge test -vvvv

# Run tests with forking (example mainnet fork):
forge test -vv --fork-url $RPC_URL

# Generate coverage report
forge coverage
```

Common flags:

* `-v` / `-vv` / `-vvv` — increase verbosity
* `--match-test <pattern>` — run a subset of tests

Make sure tests cover happy paths, edge cases, and security checks (owner-only, reentrancy guards if applicable).

---

## Deployment

Use your deployment script under `script/` (commonly a `DeployFundMe.s.sol` script).

Deploy (example — Sepolia / Goerli / Sepolia-style chain id sample):

```bash
forge script script/DeployFundMe.s.sol --rpc-url $RPC_URL --private-key $PRIVATE_KEY --broadcast --chain-id <CHAIN_ID>
```

Verify contract on Etherscan (after deployment):

```bash
# Example verification command
forge verify-contract --chain-id <CHAIN_ID> <DEPLOYED_ADDRESS> "src/FundMe.sol:FundMe" $ETHERSCAN_API_KEY
```

Replace placeholders accordingly.

---

## Contract Details

**Main contracts:**

* `FundMe.sol` — Core contract that accepts funds, keeps track of contributors, and allows owner withdrawal. Includes access control for owner.
* `PriceConverter.sol` (or similar) — Utility that converts ETH to USD using a price-feed (Chainlink) to enforce minimum contributions in USD.
* `MockV3Aggregator.sol` — Local mock for Chainlink price feed used in unit tests and local development.
* `script/DeployFundMe.s.sol` — Deployment script used with `forge script`.

**Important variables & functions (example):**

* `MINIMUM_USD` — Minimum funding amount required (in USD scaled units).
* `fund()` — Payable function to contribute ETH.
* `withdraw()` — Owner-only function that withdraws funds.
* `getFunder(uint256)` / `getAddressToAmountFunded(address)` — Read helpers for testing and UI.

Adjust names to match your actual contract code.

---

## Security & Audit Notes

* **Owner checks:** Ensure only owner can call privileged functions; add checks using `require(msg.sender == owner)` or `Ownable`.
* **Reentrancy:** If `withdraw` sends ETH to external addresses, protect it using the Checks-Effects-Interactions pattern or `ReentrancyGuard`.
* **Input validation:** Validate minimum funding amounts and handle edge cases (zero contributions, overflows — Solidity 0.8+ has built-in overflow checks).
* **Private keys & RPC keys:** Never expose these in the repo.
* **Testing adversarial flows:** Add tests for malicious actors and large-value transfers.

---

## Gas & Optimization Notes

* Favor `immutable` and `constant` for gas savings where appropriate (e.g., owner addresses, constants).
* Reduce storage writes: combine variables, use memory when possible for temporary arrays.
* Use `calldata` for external view functions accepting arrays.
* Keep constructor logic minimal.

---

## Contributing

Contributions are welcome. Suggested guidelines:

1. Fork the repo and create a branch for your feature: `git checkout -b feat/my-feature`
2. Add tests for any new functionality.
3. Open a PR with a clear description and link to failing/passing tests.

---

## License & Credits

* **License:** MIT (default). Replace with your preferred license.

* **Credits:** Project implemented following the Cyfrin Updraft Foundry tutorial. Adapted and polished for a professional repository deliverable.

---

## Contact

For questions or collaboration, open an issue or reach out using the contact info in the repository profile.

---

*Last updated: `2025-08-08`*
