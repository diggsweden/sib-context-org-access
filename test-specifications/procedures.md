# Common Procedures

This page describes the procedures that the test cases use to obtain the data they verify, such as fetching an Entity Configuration or building a Trust Chain. The procedures only read what the federation publishes. A test case names the procedures it uses in its instructions, for example "Fetch the Entity Configuration of the TA (P-EC)", and carries them out itself.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

## 1. Independent Test Cases

Every test case can be carried out on its own, in any order. It depends only on the procedures on this page and on the test data in [test_data.md](test_data.md), never on the outcome or the data of another test case.

- **Procedures obtain data, test cases verify it.** A procedure states how to obtain something. It does not assert anything. Whether the data obtained is correct is verified by the test cases that test that step, for example `TA-OS-001` for the retrieval of the Trust Anchor's Entity Configuration.
- **A failed procedure makes the test case inconclusive.** If a procedure cannot be completed, for example because the endpoint does not respond, the test case is reported as *Inconclusive*, with the procedure and the reason, and not as *Failed*. The failure is reported once, by the test case that verifies that step. This keeps one fault from giving many failed test cases.
- **Expected results may be reused, results may not.** A test case may say that data it has obtained itself is to meet the expected result of another test case, for example "The Subordinate Statement MUST meet the expected result of FRE-OS-020". This refers to the criteria only, and the other test case need not have been carried out.
- **Registration is a black box.** How an Entity is registered, changed or removed is the Federation Registration Operator's routine, and is not tested. When a test case needs a change in the federation, such as a newly added Entity, the change is a precondition: the operator makes it according to its own routine and states the time it was made. The test case then verifies only what is published, and how long it takes until the change is visible.
- **Results may be reused for efficiency.** When test cases are carried out in one session, the tester may reuse data that another test case obtained with the same procedure and the same input, if it is still valid. This is an optimisation, and the test case is still to be reported on its own.

## 2. Procedures

<a name="p-ec"></a>
### P-EC: Fetch the Entity Configuration

**Input**: an Entity Identifier.

1. Send an HTTP GET request to `<Entity Identifier>/.well-known/openid-federation`. If the Entity Configuration is hosted by its Superior, use the URL in the `ec_location` claim of the Superior's Subordinate Statement about the Entity ([P-FETCH](#p-fetch)) instead.
2. Decode the JWT header and payload.

**Output**: the Entity Configuration, with its `jwks`, `metadata`, `authority_hints` and other claims, and the endpoints in its `federation_entity` metadata.

<a name="p-fetch"></a>
### P-FETCH: Fetch a Subordinate Statement

**Input**: the Entity Identifier of the issuer, and the Entity Identifier of the subject.

1. Fetch the Entity Configuration of the issuer ([P-EC](#p-ec)) and take the `federation_fetch_endpoint` from its `federation_entity` metadata.
2. Send a GET request to the fetch endpoint with `sub` set to the subject's Entity Identifier.
3. Decode the JWT header and payload.

**Output**: the Subordinate Statement, with its `jwks`, `metadata`, `metadata_policy`, `constraints` and other claims.

<a name="p-list"></a>
### P-LIST: List the Immediate Subordinates

**Input**: the Entity Identifier of the issuer, and any request parameters such as `entity_type`.

1. Fetch the Entity Configuration of the issuer ([P-EC](#p-ec)) and take the `federation_list_endpoint` from its `federation_entity` metadata.
2. Send a GET request to the list endpoint with the given parameters.

**Output**: the JSON array of Entity Identifiers.

<a name="p-hist"></a>
### P-HIST: Fetch the historical keys

**Input**: an Entity Identifier.

1. Fetch the Entity Configuration ([P-EC](#p-ec)) and take the `federation_historical_keys_endpoint` from its `federation_entity` metadata.
2. Send a GET request to the endpoint, and decode the JWT header and payload.

**Output**: the signed JWK Set of historical keys.

<a name="p-chain"></a>
### P-CHAIN: Build a Trust Chain and resolve metadata

**Input**: the Entity Identifier of a Leaf Entity, and the Trust Anchor with its out-of-band distributed keys.

1. Using the reference implementation (see [test_data.md](test_data.md#6-other-test-data)), collect the Entity Configurations ([P-EC](#p-ec)) and Subordinate Statements ([P-FETCH](#p-fetch)) from the Leaf Entity up to the Trust Anchor, following `authority_hints`.
2. Validate the Trust Chain, and apply the metadata policies and constraints of the chain.

**Output**: the Trust Chain, and the Resolved Metadata, or the error that the reference implementation reports.

<a name="p-resolve"></a>
### P-RESOLVE: Send a resolve request

**Input**: the Entity Identifier of the subject, the Trust Anchor, and any further request parameters such as `entity_type`.

1. Fetch the Entity Configuration of the resolver ([P-EC](#p-ec)) and take the `federation_resolve_endpoint` from its `federation_entity` metadata.
2. Send a GET request to the resolve endpoint with `sub`, `trust_anchor` and the further parameters.
3. If the response is a JWT, decode its header and payload.

**Output**: the HTTP response, and the resolve response with its `metadata`, `trust_chain` and other claims.

<a name="p-error"></a>
### P-ERROR: Send a request that is expected to fail

**Input**: an endpoint and the request to send, such as a fetch request with an unknown `sub`.

1. Fetch the Entity Configuration of the Entity under test ([P-EC](#p-ec)) and take the endpoint from its `federation_entity` metadata.
2. Send the request.
3. Record the HTTP status code, the content type and the response body.

**Output**: the error response, which the test case verifies against Section 8.9 of \[OpenID.Federation\].
