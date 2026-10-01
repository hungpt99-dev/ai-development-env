# Domain Glossary (EXAMPLE — replace per project)

| Term | Definition |
|------|------------|
| Order | A customer intent to purchase; has exactly one payment state machine. |
| Shipment | Fulfillment of (part of) an order; many-to-one with Order. |
| Idempotency key | Client-supplied key that makes a POST safe to retry. |

Rules: one term = 2-4 lines. Link code names (`OrderService.create`) where useful. No invented synonyms — AI must use these spellings.
