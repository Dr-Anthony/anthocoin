;; AnthoCoin - A SIP-010 compliant token contract
;; 
;; This contract implements a fungible token with the following features:
;; - SIP-010 compliant (Stacks Improvement Proposal for fungible tokens)
;; - Fixed supply of 1,000,000,000 tokens (1 billion)
;; - Minting capability (only by contract owner)
;; - Transfer functionality
;; - Token metadata
;; - Administrative controls

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant TOKEN_NAME "AnthoCoin")
(define-constant TOKEN_SYMBOL "ANTHO")
(define-constant TOKEN_DECIMALS u6)
(define-constant TOTAL_SUPPLY u1000000000000000) ;; 1 billion tokens with 6 decimals

;; Error constants
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_NOT_TOKEN_OWNER (err u101))
(define-constant ERR_INSUFFICIENT_BALANCE (err u102))
(define-constant ERR_INVALID_AMOUNT (err u103))
(define-constant ERR_TRANSFER_FAILED (err u104))

;; Data variables
(define-data-var contract-owner principal CONTRACT_OWNER)
(define-data-var token-uri (optional (string-utf8 256)) none)

;; Define the fungible token
(define-fungible-token anthocoin TOTAL_SUPPLY)

;; SIP-010 trait implementation
(define-trait sip-010-trait
  (
    (transfer (uint principal principal (optional (buff 34))) (response bool uint))
    (get-name () (response (string-ascii 32) uint))
    (get-symbol () (response (string-ascii 32) uint))
    (get-decimals () (response uint uint))
    (get-balance (principal) (response uint uint))
    (get-total-supply () (response uint uint))
    (get-token-uri () (response (optional (string-utf8 256)) uint))
  )
)

;; Private functions
(define-private (is-owner)
  (is-eq tx-sender (var-get contract-owner))
)

;; Public functions

;; Initialize the contract by minting all tokens to the contract owner
(define-public (initialize)
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (ft-mint? anthocoin TOTAL_SUPPLY CONTRACT_OWNER)
  )
)

;; Transfer tokens (SIP-010)
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) ERR_UNAUTHORIZED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-transfer? anthocoin amount sender recipient)
  )
)

;; Get token name (SIP-010)
(define-read-only (get-name)
  (ok TOKEN_NAME)
)

;; Get token symbol (SIP-010)
(define-read-only (get-symbol)
  (ok TOKEN_SYMBOL)
)

;; Get token decimals (SIP-010)
(define-read-only (get-decimals)
  (ok TOKEN_DECIMALS)
)

;; Get balance of an address (SIP-010)
(define-read-only (get-balance (who principal))
  (ok (ft-get-balance anthocoin who))
)

;; Get total supply (SIP-010)
(define-read-only (get-total-supply)
  (ok TOTAL_SUPPLY)
)

;; Get token URI (SIP-010)
(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Admin functions

;; Set token URI (only owner)
(define-public (set-token-uri (new-uri (optional (string-utf8 256))))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (var-set token-uri new-uri)
    (ok true)
  )
)

;; Transfer ownership (only current owner)
(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (var-set contract-owner new-owner)
    (ok true)
  )
)

;; Mint additional tokens (only owner) - for future expansions if needed
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-owner) ERR_UNAUTHORIZED)
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-mint? anthocoin amount recipient)
  )
)

;; Burn tokens (only token owner can burn their own tokens)
(define-public (burn (amount uint))
  (begin
    (asserts! (> amount u0) ERR_INVALID_AMOUNT)
    (ft-burn? anthocoin amount tx-sender)
  )
)

;; Read-only functions for additional information

;; Get contract owner
(define-read-only (get-contract-owner)
  (var-get contract-owner)
)

;; Get token info (convenience function)
(define-read-only (get-token-info)
  {
    name: TOKEN_NAME,
    symbol: TOKEN_SYMBOL,
    decimals: TOKEN_DECIMALS,
    total-supply: TOTAL_SUPPLY,
    contract-owner: (var-get contract-owner),
    token-uri: (var-get token-uri)
  }
)

;; Check if an address is the contract owner
(define-read-only (is-contract-owner (who principal))
  (is-eq who (var-get contract-owner))
)

