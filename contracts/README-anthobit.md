# Anthobit (ABIT)

A Bitcoin-inspired fungible token smart contract built with Clarity for the Stacks blockchain.

## Overview

Anthobit is a SIP-010 compliant fungible token that mirrors Bitcoin's total supply of 21 million tokens. It implements the standard fungible token interface with additional features for minting, burning, and token URI management.

## Token Specifications

- **Name:** Anthobit
- **Symbol:** ABIT
- **Decimals:** 6
- **Total Supply:** 21,000,000 ABIT (21,000,000,000,000 base units)
- **Standard:** SIP-010 Fungible Token

## Features

### Core Functions (SIP-010)

#### `transfer`
Transfer tokens from sender to recipient.
```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```
- Validates sender is transaction initiator
- Validates amount is greater than 0
- Supports optional memo field

#### Read-Only Functions
- `get-name` - Returns token name: "Anthobit"
- `get-symbol` - Returns token symbol: "ABIT"
- `get-decimals` - Returns decimal places: 6
- `get-balance` - Returns balance for specified principal
- `get-total-supply` - Returns current circulating supply
- `get-token-uri` - Returns optional token metadata URI

### Extended Functions

#### `mint`
Owner-only function to mint new tokens.
```clarity
(mint (amount uint) (recipient principal))
```
- Only callable by contract owner
- Cannot exceed total supply cap
- Validates amount is greater than 0

#### `burn`
Burn tokens from sender's balance.
```clarity
(burn (amount uint) (sender principal))
```
- Only token owner can burn their tokens
- Reduces circulating supply

#### `set-token-uri`
Owner-only function to set token metadata URI.
```clarity
(set-token-uri (value (string-utf8 256)))
```

## Error Codes

- `u100` - Owner-only operation
- `u101` - Not token owner
- `u102` - Insufficient balance
- `u103` - Invalid amount

## Deployment

The contract initializes by minting the entire supply (21M ABIT) to the deployer's address.

### Using Clarinet

1. Ensure the contract is in your `contracts/` directory
2. Update `Clarinet.toml` to include the contract:
```toml
[contracts.anthobit]
path = "contracts/anthobit.clar"
```

3. Check the contract:
```bash
clarinet check
```

4. Test the contract:
```bash
clarinet test
```

5. Deploy to devnet:
```bash
clarinet integrate
```

## Usage Examples

### Transfer Tokens
```clarity
(contract-call? .anthobit transfer u1000000 tx-sender 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM none)
```

### Check Balance
```clarity
(contract-call? .anthobit get-balance 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Mint (Owner Only)
```clarity
(contract-call? .anthobit mint u5000000 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM)
```

### Burn Tokens
```clarity
(contract-call? .anthobit burn u1000000 tx-sender)
```

## Security Considerations

- Only the contract deployer can mint new tokens
- Maximum supply is hard-capped at 21 million
- Users can only transfer or burn their own tokens
- All transfers validate sender identity

## Testing

Create unit tests in `tests/anthobit.test.ts` to verify:
- Token initialization
- Transfer functionality
- Mint restrictions
- Burn operations
- Balance tracking
- Supply cap enforcement

## License

See LICENSE file in the repository root.

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting pull requests.
