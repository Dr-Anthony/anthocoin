;; Anthobit - A Bitcoin-inspired token on Stacks
;; Implements SIP-010 fungible token standard

(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-insufficient-balance (err u102))
(define-constant err-invalid-amount (err u103))

;; Token definitions
(define-fungible-token anthobit)

;; Total supply: 21 million (like Bitcoin)
(define-constant total-supply u21000000000000) ;; 21M with 6 decimals

;; Data variables
(define-data-var token-uri (optional (string-utf8 256)) none)

;; SIP-010 Functions

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (try! (ft-transfer? anthobit amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-name)
  (ok "Anthobit")
)

(define-read-only (get-symbol)
  (ok "ABIT")
)

(define-read-only (get-decimals)
  (ok u6)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance anthobit who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply anthobit))
)

(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Additional functions

(define-public (set-token-uri (value (string-utf8 256)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (var-set token-uri (some value)))
  )
)

(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (<= (+ (ft-get-supply anthobit) amount) total-supply) err-invalid-amount)
    (ft-mint? anthobit amount recipient)
  )
)

(define-public (burn (amount uint) (sender principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (asserts! (> amount u0) err-invalid-amount)
    (ft-burn? anthobit amount sender)
  )
)

;; Initialize with supply to contract owner
(begin
  (try! (ft-mint? anthobit total-supply contract-owner))
)
