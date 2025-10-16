import { describe, expect, it } from "vitest";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!;
const wallet1 = accounts.get("wallet_1")!;
const wallet2 = accounts.get("wallet_2")!;

const CONTRACT_NAME = "anthocoin-token";

describe("AnthoCoin Token Tests", () => {
  it("should ensure simnet is initialized", () => {
    expect(simnet.blockHeight).toBeDefined();
  });

  it("should have correct token metadata", () => {
    const name = simnet.callReadOnlyFn(CONTRACT_NAME, "get-name", [], deployer);
    const symbol = simnet.callReadOnlyFn(CONTRACT_NAME, "get-symbol", [], deployer);
    const decimals = simnet.callReadOnlyFn(CONTRACT_NAME, "get-decimals", [], deployer);
    const totalSupply = simnet.callReadOnlyFn(CONTRACT_NAME, "get-total-supply", [], deployer);
    
    expect(name.result).toBeOk("AnthoCoin");
    expect(symbol.result).toBeOk("ANTHO");
    expect(decimals.result).toBeOk(6);
    expect(totalSupply.result).toBeOk(1000000000000000); // 1 billion with 6 decimals
  });

  it("should allow owner to initialize contract", () => {
    const initResult = simnet.callPublicFn(CONTRACT_NAME, "initialize", [], deployer);
    expect(initResult.result).toBeOk(true);
    
    // Check deployer balance after initialization
    const balance = simnet.callReadOnlyFn(CONTRACT_NAME, "get-balance", [deployer], deployer);
    expect(balance.result).toBeOk(1000000000000000);
  });

  it("should not allow non-owner to initialize", () => {
    const initResult = simnet.callPublicFn(CONTRACT_NAME, "initialize", [], wallet1);
    expect(initResult.result).toBeErr(100); // ERR_UNAUTHORIZED
  });

  it("should allow token transfers", () => {
    // First initialize the contract
    simnet.callPublicFn(CONTRACT_NAME, "initialize", [], deployer);
    
    // Transfer 1000 tokens (1000000000 with 6 decimals)
    const transferAmount = 1000000000;
    const transferResult = simnet.callPublicFn(
      CONTRACT_NAME,
      "transfer",
      [transferAmount, deployer, wallet1, null],
      deployer
    );
    expect(transferResult.result).toBeOk(true);
    
    // Check balances
    const wallet1Balance = simnet.callReadOnlyFn(CONTRACT_NAME, "get-balance", [wallet1], deployer);
    expect(wallet1Balance.result).toBeOk(transferAmount);
  });

  it("should not allow unauthorized transfers", () => {
    // Initialize first
    simnet.callPublicFn(CONTRACT_NAME, "initialize", [], deployer);
    
    // Try to transfer from deployer as wallet1 (should fail)
    const transferResult = simnet.callPublicFn(
      CONTRACT_NAME,
      "transfer",
      [1000000, deployer, wallet2, null],
      wallet1
    );
    expect(transferResult.result).toBeErr(100); // ERR_UNAUTHORIZED
  });

  it("should allow token burning", () => {
    // Initialize and give wallet1 some tokens
    simnet.callPublicFn(CONTRACT_NAME, "initialize", [], deployer);
    const transferAmount = 1000000000; // 1000 tokens
    simnet.callPublicFn(CONTRACT_NAME, "transfer", [transferAmount, deployer, wallet1, null], deployer);
    
    // Burn 500 tokens (500000000 with 6 decimals)
    const burnAmount = 500000000;
    const burnResult = simnet.callPublicFn(CONTRACT_NAME, "burn", [burnAmount], wallet1);
    expect(burnResult.result).toBeOk(true);
    
    // Check balance after burn
    const balance = simnet.callReadOnlyFn(CONTRACT_NAME, "get-balance", [wallet1], deployer);
    expect(balance.result).toBeOk(transferAmount - burnAmount);
  });

  it("should allow owner to mint additional tokens", () => {
    // Initialize first
    simnet.callPublicFn(CONTRACT_NAME, "initialize", [], deployer);
    
    // Mint 1000 additional tokens to wallet1
    const mintAmount = 1000000000;
    const mintResult = simnet.callPublicFn(CONTRACT_NAME, "mint", [mintAmount, wallet1], deployer);
    expect(mintResult.result).toBeOk(true);
    
    // Check wallet1 balance
    const balance = simnet.callReadOnlyFn(CONTRACT_NAME, "get-balance", [wallet1], deployer);
    expect(balance.result).toBeOk(mintAmount);
  });

  it("should not allow non-owner to mint tokens", () => {
    const mintResult = simnet.callPublicFn(CONTRACT_NAME, "mint", [1000000, wallet2], wallet1);
    expect(mintResult.result).toBeErr(100); // ERR_UNAUTHORIZED
  });

  it("should return correct contract owner", () => {
    const owner = simnet.callReadOnlyFn(CONTRACT_NAME, "get-contract-owner", [], deployer);
    expect(owner.result).toBe(deployer);
    
    const isOwner = simnet.callReadOnlyFn(CONTRACT_NAME, "is-contract-owner", [deployer], deployer);
    expect(isOwner.result).toBe(true);
    
    const isNotOwner = simnet.callReadOnlyFn(CONTRACT_NAME, "is-contract-owner", [wallet1], deployer);
    expect(isNotOwner.result).toBe(false);
  });

  it("should allow ownership transfer", () => {
    // Transfer ownership to wallet1
    const transferResult = simnet.callPublicFn(CONTRACT_NAME, "transfer-ownership", [wallet1], deployer);
    expect(transferResult.result).toBeOk(true);
    
    // Check new owner
    const newOwner = simnet.callReadOnlyFn(CONTRACT_NAME, "get-contract-owner", [], deployer);
    expect(newOwner.result).toBe(wallet1);
  });

  it("should return comprehensive token info", () => {
    const tokenInfo = simnet.callReadOnlyFn(CONTRACT_NAME, "get-token-info", [], deployer);
    expect(tokenInfo.result).toBeOk({
      "name": "AnthoCoin",
      "symbol": "ANTHO",
      "decimals": 6,
      "total-supply": 1000000000000000,
      "contract-owner": deployer,
      "token-uri": null
    });
  });
});
