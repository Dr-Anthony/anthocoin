# Anthobit Token (ABIT)

A SIP-010 compliant fungible token smart contract built with Clarinet for the Stacks blockchain.

## Overview

Anthobit (ABIT) is a fungible token implementation that follows the SIP-010 standard. It includes basic token functionality such as transfers, minting, burning, and allowances.

## Token Details

- **Name**: Anthobit
- **Symbol**: ABIT
- **Decimals**: 6
- **Standard**: SIP-010 Fungible Token

## Features

- ✅ SIP-010 compliant
- ✅ Minting (owner only)
- ✅ Burning (token holders)
- ✅ Transfers with optional memo
- ✅ Allowances and delegated transfers
- ✅ Token URI support
- ✅ Event logging via print statements

## Functions

### Read-Only Functions

- `get-name()` - Returns the token name
- `get-symbol()` - Returns the token symbol
- `get-decimals()` - Returns the number of decimals
- `get-balance(account)` - Returns the balance of an account
- `get-total-supply()` - Returns the total supply
- `get-token-uri()` - Returns the token URI
- `get-allowance(owner, spender)` - Returns the allowance amount

### Public Functions

- `transfer(amount, sender, recipient, memo)` - Transfer tokens
- `mint(amount, recipient)` - Mint new tokens (owner only)
- `burn(amount, sender)` - Burn tokens
- `approve(spender, amount)` - Approve spending allowance
- `transfer-from(amount, owner, recipient, memo)` - Transfer from approved account
- `set-token-uri(new-uri)` - Set token URI (owner only)
- `initialize(initial-supply)` - Initialize with initial supply (one-time, owner only)

## Error Codes

- `u100` - Owner only operation
- `u101` - Not token owner
- `u102` - Insufficient balance
- `u103` - Invalid amount
- `u104` - Already initialized

## Setup

1. Install Clarinet:
```bash
curl -L https://github.com/hirosystems/clarinet/releases/download/v2.0.0/clarinet-linux-x64-glibc.tar.gz | tar xz
```

2. Check the contract:
```bash
clarinet check
```

3. Run tests:
```bash
clarinet test
```

## Usage Examples

### Initialize the token
```clarity
(contract-call? .anthobit initialize u1000000000000)
```

### Transfer tokens
```clarity
(contract-call? .anthobit transfer u1000000 tx-sender 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 none)
```

### Mint tokens (owner only)
```clarity
(contract-call? .anthobit mint u500000 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7)
```

### Burn tokens
```clarity
(contract-call? .anthobit burn u100000 tx-sender)
```

### Approve spending
```clarity
(contract-call? .anthobit approve 'SP2J6ZY48GV1EZ5V2V5RB9MP66SW86PYKKNRV9EJ7 u50000)
```

## Development

The contract is written in Clarity and can be deployed to the Stacks blockchain. Use Clarinet for local development and testing.

### Testing
Create test files in the `tests` directory to ensure contract functionality works as expected.

### Deployment
Use Clarinet to deploy to testnet or mainnet:
```bash
clarinet deployments apply -p testnet
```

## License

This project is licensed under the terms specified in the LICENSE file.

## Security Considerations

- Only the contract owner can mint new tokens
- Only token holders can burn their own tokens
- Transfers require sender authorization
- All operations validate amounts and balances
- Events are logged for transparency

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting a pull request.
