
## 🪙 FundMe – A Decentralized Crowdfunding Smart Contract

FundMe is a Solidity-based smart contract built with **Foundry**.  
It allows users to **fund** a contract using ETH, while the **owner** can withdraw the collected funds.  

This project was built as part of the **Cyfrin Updraft** course to practice real-world concepts like:

- How ETH value is validated using Chainlink price feeds
- How to manage contributors securely
- How to write gas-efficient and test-driven Solidity code

Essentially — a hands-on walkthrough of how Web3 handles something as simple (and powerful) as “funding with transparency.”
## Tech Stack

- **Solidity** – Smart contract development language  
- **Foundry** – Framework for building, testing, and deploying contracts  
- **Chainlink** – Used for fetching live ETH/USD price data via oracles  

## ⚙️ Features

- **Fund with ETH:** Anyone can send ETH to the contract to support the project.  
- **Real-time USD Conversion:** Uses Chainlink price feeds to calculate the minimum funding amount in USD.  
- **Owner Withdrawals:** Only the contract owner can withdraw the collected funds.  
- **Funder Tracking:** Stores each contributor’s address and amount funded.  
- **Comprehensive Testing:** Includes Foundry unit and integration tests to ensure contract reliability.  
- **Gas Optimization:** Implements efficient Solidity patterns for lower transaction costs. 

## Smart Contract Overview

The **FundMe** contract demonstrates the fundamentals of decentralized crowdfunding using Solidity and Foundry.  
It’s built around transparency, modular design, and precise handling of real-world ETH values.

### Core Concepts:
- **Funding Logic:** Users can send ETH directly to the contract. Each contribution is validated against a minimum USD threshold using Chainlink’s ETH/USD price feed.  
- **Owner Control:** Only the contract owner can withdraw the total balance, ensuring clear fund management.  
- **Price Feeds:** Integrates **Chainlink AggregatorV3Interface** to fetch live ETH prices for accurate conversions.  
- **Data Structures:**  
  - `mapping(address => uint256) addressToAmountFunded` — Tracks each funder’s contributions  
  - `address[] funders` — Maintains a list of all unique contributors  
- **Security Practices:** Includes proper access control, withdrawal safety, and clean error handling to prevent misuse.

*This project showcases not just Solidity syntax — but the mindset of writing secure, production-grade smart contracts.*  

## Deployment & Testing

### Deployment
The project uses a `Makefile` to simplify and standardize deployment.  
Currently, it supports **deployment to the Sepolia testnet only**.

To deploy, run:

```bash
make deploy-sepolia
```

### Testing

```bash
forge test
```

## Commands

Here are the most commonly used Foundry commands for this project:

| Command | Description |
|----------|-------------|
| `forge build` | Compiles all smart contracts in the project. |
| `forge test` | Runs all test files to verify contract logic. |
| `make deploy-sepolia` | Deploys the contract to the **Sepolia** testnet using your `.env` configuration. |
| `forge script script/DeployFundMe.s.sol` | Manually runs the deployment script without Makefile. |
| `forge fmt` | Formats Solidity files for clean and consistent code. |
| `forge coverage` | Generates test coverage reports (optional). |

*These commands make it easy to move from writing to testing to deploying — without ever leaving your terminal.*

## 🏁 Conclusion

The **FundMe** project is more than just a funding contract — it’s a hands-on exploration of how decentralized systems handle trust, transparency, and real-world value.  
Built with **Solidity**, powered by **Foundry**, and linked to the real world through **Chainlink oracles**, it demonstrates a full development cycle — from concept to deployment.

This project reflects my journey of learning **smart contract design, testing, and deployment** the right way: with clarity, precision, and a focus on secure, gas-efficient patterns.

*A small contract — but a big step toward mastering Web3 development.*



