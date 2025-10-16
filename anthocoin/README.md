# AnthoCoin (ANTHO)

A SIP-010 compliant fungible token smart contract built on the Stacks blockchain using Clarity.

## Overview

AnthoCoin is a fungible token with a total supply of 1 billion tokens (1,000,000,000 ANTHO). The contract is fully compliant with the SIP-010 standard, making it compatible with all major Stacks wallets and exchanges.

### Key Features

- **SIP-010 Compliant**: Full compatibility with the Stacks fungible token standard
- **Fixed Supply**: 1 billion tokens with 6 decimal places
- **Administrative Controls**: Owner can mint additional tokens and transfer ownership
- **Burn Functionality**: Token holders can burn their own tokens
- **Metadata Support**: Configurable token URI for additional metadata

## Token Details

- **Name**: AnthoCoin
- **Symbol**: ANTHO
- **Decimals**: 6
- **Total Supply**: 1,000,000,000,000,000 (1 billion tokens with 6 decimals)
- **Standard**: SIP-010

## Smart Contract Functions

### SIP-010 Standard Functions

#### `transfer`
Transfer tokens between addresses.
```clarity
(transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
```

#### `get-name`
Returns the token name.
```clarity
(get-name) -> (response "AnthoCoin" uint)
```

#### `get-symbol`
Returns the token symbol.
```clarity
(get-symbol) -> (response "ANTHO" uint)
```

#### `get-decimals`
Returns the number of decimal places.
```clarity
(get-decimals) -> (response u6 uint)
```

#### `get-balance`
Returns the balance of a specific address.
```clarity
(get-balance (who principal)) -> (response uint uint)
```

#### `get-total-supply`
Returns the total token supply.
```clarity
(get-total-supply) -> (response uint uint)
```

#### `get-token-uri`
Returns the token metadata URI.
```clarity
(get-token-uri) -> (response (optional (string-utf8 256)) uint)
```

### Administrative Functions

#### `initialize`
Mints the initial token supply to the contract owner. Can only be called by the contract owner.
```clarity
(initialize) -> (response bool uint)
```

#### `mint`
Mints additional tokens to a specified recipient. Can only be called by the contract owner.
```clarity
(mint (amount uint) (recipient principal)) -> (response bool uint)
```

#### `set-token-uri`
Sets the token metadata URI. Can only be called by the contract owner.
```clarity
(set-token-uri (new-uri (optional (string-utf8 256)))) -> (response bool uint)
```

#### `transfer-ownership`
Transfers contract ownership to a new address. Can only be called by the current owner.
```clarity
(transfer-ownership (new-owner principal)) -> (response bool uint)
```

### User Functions

#### `burn`
Burns tokens from the caller's balance, reducing the total supply.
```clarity
(burn (amount uint)) -> (response bool uint)
```

### Read-Only Functions

#### `get-contract-owner`
Returns the current contract owner.
```clarity
(get-contract-owner) -> principal
```

#### `get-token-info`
Returns comprehensive token information.
```clarity
(get-token-info) -> {
  name: "AnthoCoin",
  symbol: "ANTHO",
  decimals: u6,
  total-supply: uint,
  contract-owner: principal,
  token-uri: (optional (string-utf8 256))
}
```

#### `is-contract-owner`
Checks if a given address is the contract owner.
```clarity
(is-contract-owner (who principal)) -> bool
```

## Development Setup

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks smart contract development tool
- [Node.js](https://nodejs.org/) (for testing)
- [Git](https://git-scm.com/)

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd anthocoin
```

2. Install dependencies:
```bash
npm install
```

### Testing

Run the test suite:
```bash
npm test
```

Check contract syntax:
```bash
clarinet check
```

### Local Development

Start a local blockchain for testing:
```bash
clarinet integrate
```

This will start a local Stacks blockchain where you can deploy and test your contract.

## Deployment

### Testnet Deployment

1. Configure your deployment settings in `settings/Testnet.toml`
2. Deploy using Clarinet:
```bash
clarinet deploy --testnet
```

### Mainnet Deployment

1. Configure your deployment settings in `settings/Mainnet.toml`
2. Deploy using Clarinet:
```bash
clarinet deploy --mainnet
```

## Usage Examples

### Using with Stacks Wallet

Once deployed, the contract can be used with any SIP-010 compatible wallet:

1. **Add Token**: Use the contract address to add ANTHO to your wallet
2. **Transfer**: Send tokens to other addresses
3. **Check Balance**: View your token balance

### Contract Interaction

#### Initialize the Contract (Owner Only)
```javascript
// Using @stacks/transactions
const functionArgs = [];
const txOptions = {
  contractAddress: 'your-contract-address',
  contractName: 'anthocoin-token',
  functionName: 'initialize',
  functionArgs,
  // ... other options
};
```

#### Transfer Tokens
```javascript
const functionArgs = [
  uintCV(1000000), // 1 ANTHO (with 6 decimals)
  principalCV('sender-address'),
  principalCV('recipient-address'),
  noneCV() // no memo
];
const txOptions = {
  contractAddress: 'your-contract-address',
  contractName: 'anthocoin-token',
  functionName: 'transfer',
  functionArgs,
  // ... other options
};
```

## Error Codes

- `u100`: ERR_UNAUTHORIZED - Caller is not authorized to perform this action
- `u101`: ERR_NOT_TOKEN_OWNER - Caller does not own the tokens
- `u102`: ERR_INSUFFICIENT_BALANCE - Insufficient token balance
- `u103`: ERR_INVALID_AMOUNT - Invalid amount specified (must be > 0)
- `u104`: ERR_TRANSFER_FAILED - Token transfer failed

## Security Considerations

- **Owner Privileges**: The contract owner has special privileges (minting, ownership transfer)
- **Burn Function**: Users can only burn their own tokens
- **Transfer Validation**: All transfers are validated for authorization and sufficient balance
- **Immutable Supply**: Total supply is set at deployment (except for owner minting)

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

For questions or support, please open an issue on the GitHub repository.

## Acknowledgments

- Built with [Clarinet](https://github.com/hirosystems/clarinet)
- Follows [SIP-010](https://github.com/stacksgov/sips/blob/main/sips/sip-010/sip-010-fungible-token-standard.md) standard
- Deployed on the [Stacks](https://www.stacks.co/) blockchain