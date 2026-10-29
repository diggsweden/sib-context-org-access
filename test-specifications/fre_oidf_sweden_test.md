# Testing of BAS Federation Registration Entities – OIDF Sweden Conformance

This document contains a set of test cases that are applied to Intermediate Entities in Federationskontext BAS (BAS). Within BAS, the Intermediates are the Federation Registration Entities: the connection services (Swedish: anslutningstjänster) that Federation Registration Operators provide, and through which the OAuth 2.0 Clients, Authorization Servers and Protected Resources of Federation Members are registered under \[[SIB.Registration](#sib-registration)\].

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

This document holds the **OIDF Sweden conformance tests**. They test the Federation Registration Entity against OpenID Federation \[[OpenID.Federation](#openid-federation)\] and the Swedish OpenID Federation profile \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], with the extensions the profile references. They contain no BAS-specific requirement, and can be reused for any federation based on the Swedish profile. The requirements that BAS adds are tested in the BAS conformance tests, [fre_bas_test.md](fre_bas_test.md). Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md).

The test cases are grouped by the test data they need:

- **[Section 2](#tests-without-external-test-data)** holds tests that can be carried out against the FRE alone, using only what it publishes itself and requests that the tester constructs. They need no test data from superior or subordinate Entities, and can be run as soon as the FRE is deployed.
- **[Section 3](#tests-requiring-a-chain-of-test-data)** holds tests that need a chain of test data, such as a Trust Anchor, registered Entities, test Entities or coordination with other operators. Each test case states the data it needs under "Test data".

Note: Where the specifications do not state a concrete value or procedure, or where a value depends on the federation environment (Entity Identifiers, validity periods, registration procedures, test tooling), the test cases are given as an overall description. The tester completes such details from the federation rules and the environment before the test is carried out.

## Table of Contents

1. [**References**](#references)

    1.1. [**Normative Specifications**](#normative-specifications)

    1.2. [**Test Setup**](#test-setup)

2. [**Tests Without External Test Data**](#tests-without-external-test-data)

    2.1. [**Verification of the Intermediate's Entity Configuration**](#verification-of-the-intermediates-entity-configuration)

    [FRE-OS-001](#fre-os-001) Retrieving the Entity Configuration

    [FRE-OS-002](#fre-os-002) Verifying the signature of the Entity Configuration

    [FRE-OS-003](#fre-os-003) Verifying the claims of the Entity Configuration

    [FRE-OS-004](#fre-os-004) Verifying the validity period of the Entity Configuration

    [FRE-OS-005](#fre-os-005) Verifying that the Entity Configuration is renewed before it expires

    [FRE-OS-006](#fre-os-006) Verifying the federation keys

    2.2. [**Verification of the Intermediate's Metadata**](#verification-of-the-intermediates-metadata)

    [FRE-OS-007](#fre-os-007) Verifying the fetch and list endpoints

    [FRE-OS-008](#fre-os-008) Verifying other endpoint parameters

    [FRE-OS-009](#fre-os-009) Verifying informational metadata

    [FRE-OS-010](#fre-os-010) Verifying client authentication metadata for federation endpoints

    [FRE-OS-011](#fre-os-011) Verifying that no protocol key parameters are used

    2.3. [**Fetch Endpoint**](#fetch-endpoint)

    [FRE-OS-012](#fre-os-012) Fetch request for an unknown subject

    [FRE-OS-013](#fre-os-013) Fetch request with sub set to the Intermediate itself

    [FRE-OS-014](#fre-os-014) Fetch request without sub

    2.4. [**Subordinate Listing Endpoint**](#subordinate-listing-endpoint)

    [FRE-OS-015](#fre-os-015) Listing with the intermediate and Trust Mark parameters

    2.5. [**Other Endpoints and Error Handling**](#other-endpoints-and-error-handling)

    [FRE-OS-016](#fre-os-016) Retrieving the historical keys

    [FRE-OS-017](#fre-os-017) Format of error responses

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Verification of the Intermediate's Entity Configuration**](#verification-of-the-intermediates-entity-configuration-3.1)

    [FRE-OS-018](#fre-os-018) Verifying the Trust Chain from the Intermediate to the Trust Anchor

    [FRE-OS-019](#fre-os-019) Verifying Trust Marks held by the Intermediate

    3.2. [**Fetch Endpoint**](#fetch-endpoint-3.2)

    [FRE-OS-020](#fre-os-020) Fetching a Subordinate Statement about a registered Entity

    [FRE-OS-021](#fre-os-021) Verifying the binding between the Subordinate Statement and the registered Entity

    [FRE-OS-022](#fre-os-022) Verifying the validity period of Subordinate Statements

    [FRE-OS-023](#fre-os-023) Verifying the source_endpoint and ec_location claims

    [FRE-OS-024](#fre-os-024) Fetch request for an Entity registered under another Intermediate

    [FRE-OS-025](#fre-os-025) Fetch request with an unknown parameter

    3.3. [**Metadata in Subordinate Statements**](#metadata-in-subordinate-statements)

    [FRE-OS-026](#fre-os-026) Verifying that protocol parameters are not set by the Intermediate

    [FRE-OS-027](#fre-os-027) Verifying Entity Types and structure of assigned metadata

    [FRE-OS-028](#fre-os-028) Resolving registered Entities

    3.4. [**Registration Policy**](#registration-policy)

    [FRE-OS-029](#fre-os-029) Verifying the registration_policy claim

    [FRE-OS-030](#fre-os-030) Verifying that registration policies satisfy the Trust Anchor's constraints

    3.5. [**Constraints**](#constraints)

    [FRE-OS-031](#fre-os-031) Verifying the constraints claim

    3.6. [**Subordinate Listing Endpoint**](#subordinate-listing-endpoint-3.6)

    [FRE-OS-032](#fre-os-032) Listing the registered Entities

    [FRE-OS-033](#fre-os-033) Verifying that only Leaf Entities are registered

    [FRE-OS-034](#fre-os-034) Listing with the entity_type parameter

    3.7. [**Other Endpoints and Error Handling**](#other-endpoints-and-error-handling-3.7)

    [FRE-OS-035](#fre-os-035) Client authentication at federation endpoints

    3.8. [**New Entities**](#new-entities)

    [FRE-OS-036](#fre-os-036) Registering a new Entity

    3.9. [**Changes and Removal**](#changes-and-removal)

    [FRE-OS-038](#fre-os-038) Key change at a registered Entity

    [FRE-OS-039](#fre-os-039) Removing a registered Entity

    3.10. [**Key Management**](#key-management)

    [FRE-OS-040](#fre-os-040) Federation key rollover at the Intermediate

<a name="references"></a>
## 1. References

<a name="normative-specifications"></a>
### 1.1. Normative Specifications

This section contains the specifications that this document tests compliance against. Section numbers for \[[OpenID.Federation](#openid-federation)\] refer to OpenID Federation 1.1, which holds the protocol-independent parts of OpenID Federation 1.0 with unchanged section numbering.

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [Hedberg, R., Jones, M.B. (Ed.), De Marco, G., Solberg, A.Å., Bradley, J. and V. Dzhuvinov, "OpenID Federation 1.1", 5 May 2026](https://openid.net/specs/openid-federation-1_1.html).

<a name="oidc-sweden-federation"></a>
**\[OIDC.Sweden.Federation\]**
> [Lindström, M. and S. Santesson, "Swedish OpenID Federation Deployment and Interoperability Profile 1.0 - draft 03", 2 October 2026](https://www.oidc.se/specifications/swedish-openid-federation-profile.html).

<a name="openid-federation-regpolicy"></a>
**\[OpenID.Federation.RegPolicy\]**
> [Lindström, M. and S. Santesson, "OpenID Federation Registration Policy 1.0 - draft 01", 30 March 2026](https://www.oidc.se/openid-federation-registration-policy/main.html).

<a name="oidc-sweden-hosting"></a>
**\[OIDC.Sweden.Hosting\]**
> [Lindström, M. and S. Santesson, "OpenID Federation Entity Configuration Hosting 1.0", 9 January 2026](https://www.oidc.se/openid-federation-hosting/main.html).

<a name="bas-metadata"></a>
**\[BAS.Metadata\]**
> The Swedish Agency for Digital Government (Digg), "Federationskontext BAS: OAuth 2.0 Metadata Requirements 1.0, draft 02", 6 October 2026.

<a name="bas-rules"></a>
**\[BAS.Rules\]**
> The Swedish Agency for Digital Government (Digg), federation rules for Federationskontext BAS, in preparation.

<a name="sib-registration"></a>
**\[SIB.Registration\]**
> The Swedish Agency for Digital Government (Digg), "Registrering – Tillämpningskrav och vägledning", version 13, 29 September 2026.

<a name="test-setup"></a>
### 1.2. Test Setup

Each test case obtains the data it verifies itself, using the common procedures in [procedures.md](procedures.md), such as fetching an Entity Configuration ([P-EC](procedures.md#p-ec)) or building a Trust Chain ([P-CHAIN](procedures.md#p-chain)). No test case depends on the outcome of another. If a procedure cannot be completed, the test case is reported as *Inconclusive*, with the reason.

Before the tests are carried out, the tester collects the following information about the Intermediate (FRE) under test:

| Item | Description |
| :--- | :--- |
| **FRE Entity Identifier** | The Entity Identifier of the connection service under test, and the Federation Registration Operator that provides it. |
| **Trust Anchor** | The Entity Identifier and the out-of-band distributed keys of the Trust Anchor the FRE is registered under. |
| **Registered Entities** | A list of the Entities the FRE is expected to have registered, and their Entity Types. |
| **Test Entities** | At least one test Entity per Entity Type the FRE registers, which the tester controls and can have registered, changed and removed during the tests (see [Section 3](#tests-requiring-a-chain-of-test-data)). |
| **Registration documentation** | The registration policy URIs the FRE uses, and the expected time from a change, such as a newly added Entity, until it is published. The registration procedure itself is not tested, see \[[SIB.Registration](#sib-registration)\] and Section 7.2 of \[[BAS.Metadata](#bas-metadata)\]. |

Test cases that only apply under a condition state this under "Applies to".

Note: The tool at https://jwt.io can be used to inspect Entity Statements. For test cases that validate signatures and Trust Chains, an independent OpenID Federation implementation is used.

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the FRE alone. They use what the FRE publishes itself, and requests that the tester constructs.

<a name="verification-of-the-intermediates-entity-configuration"></a>
### 2.1. Verification of the Intermediate's Entity Configuration

This section contains tests that assert that the FRE publishes a valid Entity Configuration under `<FRE Entity Identifier>/.well-known/openid-federation`, and that it is correctly chained to the Trust Anchor.

<a name="fre-os-001"></a>
#### FRE-OS-001: Retrieving the Entity Configuration

- **Purpose**: Assert that the FRE publishes its Entity Configuration at the well-known location, which is mandatory for Intermediates, and that it is delivered as an Entity Statement over TLS.
- **Instructions**: Send an HTTP GET request to `<FRE Entity Identifier>/.well-known/openid-federation`. This is the retrieval step of [P-EC](procedures.md#p-ec).
- **Expected result**:
  - The FRE Entity Identifier MUST use the `https` scheme, MUST have a host component and MUST NOT contain query or fragment components.
  - The response MUST have HTTP status code 200 and the content type `application/entity-statement+jwt`.
  - The response body MUST be a signed JWT.
- **References**: Section 1.2, 9, 9.1 and 9.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-002"></a>
#### FRE-OS-002: Verifying the signature of the Entity Configuration

- **Purpose**: Assert that the Entity Configuration is correctly typed and self-signed with one of the FRE's Federation Entity Keys.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and check its header and signature.
- **Expected result**:
  - The `typ` header parameter MUST be `entity-statement+jwt`.
  - The `alg` header parameter MUST be present and MUST NOT be `none`. It SHOULD be one of `RS256`, `RS384`, `RS512`, `ES256`, `ES384` or `ES512`. Any other algorithm should be noted in the report.
  - The `kid` header parameter MUST be present, MUST NOT be empty, and MUST match the `kid` of a key in the `jwks` claim. The signature MUST validate using that key.
  - The JWT MUST NOT contain the `trust_chain` or `peer_trust_chain` header parameters.
- **References**: Section 3, 3.2, 4.3 and 4.4 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-003"></a>
#### FRE-OS-003: Verifying the claims of the Entity Configuration

- **Purpose**: Assert that the Entity Configuration contains the claims required for an Intermediate, and none of the claims that belong to other kinds of Entity Statements.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect its claims.
- **Expected result**:
  - `iss` and `sub` MUST both be equal to the FRE Entity Identifier.
  - `iat` and `exp` MUST be present and be JSON numbers, and `jwks` MUST be present (checked further in [FRE-OS-006](#fre-os-006)).
  - `authority_hints` MUST be present, MUST NOT be an empty array, and MUST contain the Entity Identifier of the Trust Anchor.
  - If `trust_anchor_hints` is present, it MUST NOT be an empty array.
  - `metadata` MUST be present and MUST contain the `federation_entity` Entity Type. It MUST NOT contain any Entity Type of a Federation Protocol Entity, such as `openid_provider`, `openid_relying_party`, `oauth_client`, `oauth_authorization_server` or `oauth_resource`.
  - The claims `metadata_policy`, `metadata_policy_crit`, `constraints`, `source_endpoint`, `aud` and `registration_policy` MUST NOT be present.
  - `trust_mark_issuers` and `trust_mark_owners` are ignored by others when published by an Entity that is not a Trust Anchor. Their presence should be noted in the report.
  - If `crit` is present, it MUST NOT be an empty array and MUST NOT list any claim defined by \[[OpenID.Federation](#openid-federation)\]. Its presence should be noted in the report.
- **References**: Section 3.1.1, 3.1.2, 3.1.3, 3.2 and 9.2 of \[[OpenID.Federation](#openid-federation)\], Section 2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 2 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\]

<a name="fre-os-004"></a>
#### FRE-OS-004: Verifying the validity period of the Entity Configuration

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The validity period for Entity Statements.
- **Purpose**: Assert that the Entity Configuration is valid at the time of testing, and that its validity period follows the federation rules.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and note the time of retrieval. Compare `iat` and `exp` with that time, with each other, and with the validity period stated in the federation rules.
- **Expected result**:
  - `iat` MUST NOT be later, and `exp` MUST be later, than the time of retrieval. A clock skew of 10 seconds is allowed.
  - `exp` minus `iat` is expected to equal the validity period stated in the federation rules. If the federation rules state no period, this should be noted in the report, and the period used should be noted.
- **References**: Section 3.1.1 and 3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 and 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-005"></a>
#### FRE-OS-005: Verifying that the Entity Configuration is renewed before it expires

- **Purpose**: Assert that the FRE publishes a new Entity Configuration well before the current one expires.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and note `iat` and `exp`. Fetch it again after half of the lifetime has elapsed, and again shortly before `exp`.
- **Expected result**:
  - Before the first `exp` is reached, the FRE MUST publish an Entity Configuration with a later `exp`.
  - It is RECOMMENDED that a new Entity Configuration is published when half of the lifetime has elapsed. Later renewal should be noted in the report.
- **References**: Section 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-006"></a>
#### FRE-OS-006: Verifying the federation keys

- **Purpose**: Assert that the FRE's Federation Entity Keys meet the security requirements and can be told apart during key rollover.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect each key in its `jwks` claim.
- **Expected result**:
  - `jwks` MUST be a valid JWK Set. Every key MUST have a `kid`, unique within the set. It is RECOMMENDED that the `kid` is the SHA-256 JWK Thumbprint of the key.
  - The set MUST NOT contain private or symmetric key material.
  - The tester notes the type and length of each key. Neither \[[OpenID.Federation](#openid-federation)\] nor \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] states a minimum key length. The key lengths are checked against the BAS requirements in [FRE-BAS-001](fre_bas_test.md#fre-bas-001).
- **References**: Section 3.1.1 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="verification-of-the-intermediates-metadata"></a>
### 2.2. Verification of the Intermediate's Metadata

<a name="fre-os-007"></a>
#### FRE-OS-007: Verifying the fetch and list endpoints

- **Purpose**: Assert that the FRE publishes the endpoints needed to build Trust Chains and to discover the Entities it has registered.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect `federation_fetch_endpoint` and `federation_list_endpoint` in the `federation_entity` metadata.
- **Expected result**:
  - Both parameters MUST be present. Publishing a list endpoint is mandatory for Intermediates, and is also stated for Federation Registration Entities by the Swedish profile.
  - Each URL MUST use the `https` scheme and MUST NOT contain a fragment component.
- **References**: Section 5.1.1, 8.1 and 8.2 of \[[OpenID.Federation](#openid-federation)\] and Section 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-008"></a>
#### FRE-OS-008: Verifying other endpoint parameters

- **Purpose**: Assert that any other federation endpoint the FRE publishes is correctly declared.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect all other parameters ending in `_endpoint` in the `federation_entity` metadata.
- **Expected result**:
  - Each URL MUST use the `https` scheme and MUST NOT contain a fragment component.
  - If `federation_resolve_endpoint` is present, the FRE takes on the role of Federation Resolver and is also tested according to [Testing of the BAS Federation Resolver](resolver_overview.md).
  - If Trust Mark endpoints are present, the FRE is also a Trust Mark Issuer. This should be noted in the report.
  - `federation_historical_keys_endpoint` is OPTIONAL. If present, it is tested in [FRE-OS-016](#fre-os-016).
- **References**: Section 5.1.1 of \[[OpenID.Federation](#openid-federation)\] and Section 4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-009"></a>
#### FRE-OS-009: Verifying informational metadata

- **Purpose**: Assert that the FRE states which organization operates it and how the operators can be reached.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect the informational parameters in the `federation_entity` metadata.
- **Expected result**:
  - `organization_name` is RECOMMENDED, and is expected to be the name of the organization that operates the FRE.
  - `contacts` is expected to hold at least one email address.
  - `policy_uri`, `organization_uri` and `information_uri` are OPTIONAL. If present, they MUST use the `https` scheme and point to existing web pages. It is recommended that `policy_uri` points to the registration procedure.
  - No metadata value MUST be `null`. Missing recommended values should be noted in the report.
- **References**: Section 5, 5.1.1 and 5.2.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-010"></a>
#### FRE-OS-010: Verifying client authentication metadata for federation endpoints

- **Purpose**: Assert that, where the FRE requires client authentication at its endpoints, it declares the methods and the mandatory signature algorithms.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect any `*_auth_methods` parameters and `endpoint_auth_signing_alg_values_supported` in the `federation_entity` metadata.
- **Expected result**:
  - If any `*_auth_methods` parameter contains `private_key_jwt`, `endpoint_auth_signing_alg_values_supported` MUST be present and MUST contain `RS256`, `RS384`, `RS512`, `ES256`, `ES384` and `ES512`.
  - `endpoint_auth_signing_alg_values_supported` MUST NOT contain `none`.
- **References**: Section 5.1.1, 8.8 and 8.8.1 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-011"></a>
#### FRE-OS-011: Verifying that no protocol key parameters are used

- **Purpose**: Assert that the FRE does not publish protocol keys in its `federation_entity` metadata.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect the `federation_entity` metadata.
- **Expected result**: `jwks`, `jwks_uri` and `signed_jwks_uri` MUST NOT be present in the `federation_entity` metadata.
- **References**: Section 5.2.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="fetch-endpoint"></a>
### 2.3. Fetch Endpoint

The tests in this section take the `federation_fetch_endpoint` from the FRE's Entity Configuration ([P-EC](procedures.md#p-ec)). Unless stated otherwise, requests are sent using GET without client authentication.

<a name="fre-os-012"></a>
#### FRE-OS-012: Fetch request for an unknown subject

- **Purpose**: Assert that the FRE does not issue a Subordinate Statement for an Entity it has not registered, and that it responds with a correct error.
- **Instructions**: Send a GET request to the fetch endpoint with `sub` set to an Entity Identifier that is not known to the federation ([P-ERROR](procedures.md#p-error)).
- **Expected result**:
  - No Entity Statement MUST be returned.
  - The response MUST have the content type `application/json` and contain `error` and `error_description`.
  - `error` SHOULD be `not_found` with HTTP status code 404. Any other code should be noted in the report.
- **References**: Section 8.1.2 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-013"></a>
#### FRE-OS-013: Fetch request with sub set to the Intermediate itself

- **Purpose**: Assert that the FRE does not issue a Subordinate Statement about itself.
- **Instructions**: Send a GET request to the fetch endpoint with `sub` set to the FRE Entity Identifier ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No Entity Statement MUST be returned. `error` SHOULD be `invalid_request` with HTTP status code 400. Any other code should be noted in the report.
- **References**: Section 8.1.2 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-014"></a>
#### FRE-OS-014: Fetch request without sub

- **Purpose**: Assert that the FRE rejects a fetch request that lacks the required `sub` parameter.
- **Instructions**: Send a GET request to the fetch endpoint without query parameters ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No Entity Statement MUST be returned. `error` SHOULD be `invalid_request` with HTTP status code 400, and the response MUST have the content type `application/json`. Anything else should be noted in the report.
- **References**: Section 8.1.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="subordinate-listing-endpoint"></a>
### 2.4. Subordinate Listing Endpoint

<a name="fre-os-015"></a>
#### FRE-OS-015: Listing with the intermediate and Trust Mark parameters

- **Purpose**: Assert that the FRE handles the remaining filter parameters correctly.
- **Instructions**: Send GET requests to the list endpoint of the FRE ([P-LIST](procedures.md#p-list)) with `intermediate=true`, with `trust_marked=true`, and with `trust_mark_type` set to a Trust Mark type recognized by the federation.
- **Expected result**:
  - With `intermediate=true`, the FRE is expected to return an empty list, or HTTP status code 400 with `unsupported_parameter`.
  - The Trust Mark parameters are expected to give HTTP status code 400 with `unsupported_parameter`, unless the FRE is also a Trust Mark Issuer.
  - The outcome must be noted in the report.
- **References**: Section 8.2 and 8.2.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="other-endpoints-and-error-handling"></a>
### 2.5. Other Endpoints and Error Handling

<a name="fre-os-016"></a>
#### FRE-OS-016: Retrieving the historical keys

- **Applies to**: Only if `federation_historical_keys_endpoint` is published
- **Purpose**: Assert that the FRE publishes its previously used Federation Entity Keys in a signed and correctly formed document.
- **Instructions**: Take the `federation_historical_keys_endpoint` from the FRE's Entity Configuration ([P-EC](procedures.md#p-ec)) and send a GET request to it.
- **Expected result**:
  - The response MUST have HTTP status code 200 and the content type `application/jwk-set+jwt`.
  - `typ` MUST be `jwk-set+jwt`, `kid` MUST be present, and the signature MUST validate with a key in the FRE's current `jwks`.
  - `iss` MUST be the FRE Entity Identifier, and `iat` and `keys` MUST be present. Every key MUST have `kid` and `exp`, and `revoked`, if present, MUST contain `revoked_at`.
- **References**: Section 8.7, 8.7.2 and 8.7.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-017"></a>
#### FRE-OS-017: Format of error responses

- **Purpose**: Assert that the FRE's error responses can be interpreted by participants.
- **Instructions**: Send the following requests to the FRE ([P-ERROR](procedures.md#p-error)) and verify each error response:
  - a fetch request with `sub` set to an Entity Identifier that is not known to the federation,
  - a fetch request with `sub` set to the FRE Entity Identifier,
  - a fetch request without query parameters,
  - list requests with `intermediate=true` and with `trust_marked=true`. A response that is not an error is disregarded.
- **Expected result**: Every error response SHOULD have the content type `application/json` and MUST contain `error` and `error_description`. The HTTP status code SHOULD match the error code.
- **References**: Section 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="verification-of-the-intermediates-entity-configuration-3.1"></a>
### 3.1. Verification of the Intermediate's Entity Configuration

This section contains tests that assert that the FRE publishes a valid Entity Configuration under `<FRE Entity Identifier>/.well-known/openid-federation`, and that it is correctly chained to the Trust Anchor.

<a name="fre-os-018"></a>
#### FRE-OS-018: Verifying the Trust Chain from the Intermediate to the Trust Anchor

- **Test data**: FED-TA, its out-of-band keys, and its Subordinate Statement about the FRE.
- **Purpose**: Assert that the FRE is registered under the Trust Anchor, so that Trust Chains for the Entities it registers can be built.
- **Instructions**: Fetch the Trust Anchor's Entity Configuration ([P-EC](procedures.md#p-ec)) and verify it with the out-of-band distributed keys. Fetch the Subordinate Statement about the FRE from the Trust Anchor ([P-FETCH](procedures.md#p-fetch)), and the FRE's Entity Configuration ([P-EC](procedures.md#p-ec)). Build and validate the Trust Chain consisting of the FRE's Entity Configuration, the Subordinate Statement and the Trust Anchor's Entity Configuration.
- **Expected result**:
  - The Subordinate Statement MUST have `iss` set to the Trust Anchor and `sub` set to the FRE, and MUST be signed with a key of the Trust Anchor.
  - The FRE's Entity Configuration MUST be signed with a key in the `jwks` claim of the Subordinate Statement.
  - The Trust Chain MUST validate according to Section 10.2 of \[[OpenID.Federation](#openid-federation)\].
- **References**: Section 4, 8.1 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-019"></a>
#### FRE-OS-019: Verifying Trust Marks held by the Intermediate

- **Applies to**: Only if the FRE holds Trust Marks
- **Test data**: FED-TMI, and the `trust_mark_issuers` claim of FED-TA.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that any Trust Marks in the FRE's Entity Configuration are valid.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and inspect its `trust_marks` claim, if present. Validate each Trust Mark against the Trust Mark Issuer's keys and the Trust Anchor's `trust_mark_issuers`.
- **Expected result**:
  - Each element MUST contain `trust_mark_type` and `trust_mark`, and `trust_mark_type` MUST equal the claim with the same name in the Trust Mark JWT.
  - Each Trust Mark MUST validate according to Section 7.3 of \[[OpenID.Federation](#openid-federation)\], with `sub` equal to the FRE Entity Identifier.
  - If no Trust Marks are present, this is not an error.
- **References**: Section 3.1.2, 3.2, 7 and 7.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="fetch-endpoint-3.2"></a>
### 3.2. Fetch Endpoint

The tests in this section take the `federation_fetch_endpoint` from the FRE's Entity Configuration ([P-EC](procedures.md#p-ec)). Unless stated otherwise, requests are sent using GET without client authentication.

<a name="fre-os-020"></a>
#### FRE-OS-020: Fetching a Subordinate Statement about a registered Entity

- **Test data**: REG-C1, REG-AS1 and REG-PR1, registered by the FRE.
- **Purpose**: Assert that the FRE issues a correctly formed and signed Subordinate Statement about each Entity it has registered.
- **Instructions**: For a selection of registered Entities, covering every Entity Type the FRE registers, send a GET request to the fetch endpoint with `sub` set to the Entity's Entity Identifier. This is the fetch step of [P-FETCH](procedures.md#p-fetch).
- **Expected result**: For each request:
  - The response MUST have HTTP status code 200 and the content type `application/entity-statement+jwt`.
  - `typ` MUST be `entity-statement+jwt`, `alg` MUST NOT be `none`, and `kid` MUST match a key in the `jwks` claim of the FRE's Entity Configuration. The signature MUST validate with that key.
  - `iss` MUST be the FRE Entity Identifier, and `sub` MUST be the requested Entity Identifier.
  - `iat`, `exp` and `jwks` MUST be present.
  - The claims `authority_hints`, `trust_anchor_hints`, `trust_marks`, `trust_mark_issuers` and `trust_mark_owners` MUST NOT be present.
  - The JWT MUST NOT contain the `trust_chain` or `peer_trust_chain` header parameters.
- **References**: Section 3, 3.1, 3.2, 4.3, 4.4, 8.1 and 8.1.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-021"></a>
#### FRE-OS-021: Verifying the binding between the Subordinate Statement and the registered Entity

- **Test data**: The Entity Configurations of REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the Subordinate Statement binds the registered Entity's Federation Entity Keys to its Entity Identifier.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and the Entity's Entity Configuration ([P-EC](procedures.md#p-ec)), from its well-known location or from `ec_location` if the Entity Configuration is hosted.
- **Expected result**:
  - The key that signed the Entity Configuration MUST be present in the `jwks` claim of the Subordinate Statement.
  - The keys in the Subordinate Statement are expected to be identical to those in the Entity Configuration. Differences must be noted in the report.
  - The `authority_hints` of the Entity Configuration MUST contain the FRE Entity Identifier.
- **References**: Section 3.1.1, 3.2 and 4 of \[[OpenID.Federation](#openid-federation)\] and Section 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-022"></a>
#### FRE-OS-022: Verifying the validity period of Subordinate Statements

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The validity period for Entity Statements.
- **Purpose**: Assert that Subordinate Statements are valid when issued and that their validity follows the federation rules.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and note the time of retrieval. Compare `iat` and `exp` with that time and with the federation rules.
- **Expected result**:
  - `iat` MUST NOT be later, and `exp` MUST be later, than the time of retrieval. A clock skew of 10 seconds is allowed.
  - `exp` minus `iat` is expected to follow the federation rules. Deviations should be noted in the report.
- **References**: Section 3.1.1 and 3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 and 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-023"></a>
#### FRE-OS-023: Verifying the source_endpoint and ec_location claims

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1, one of them with a hosted Entity Configuration if hosting is used.
- **Purpose**: Assert that optional location claims in Subordinate Statements are correct, and that hosted Entity Configurations can be found.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect `source_endpoint` and `ec_location`. If the FRE hosts Entity Configurations for some Entities, include at least one such Entity.
- **Expected result**:
  - If `source_endpoint` is present, it MUST be equal to the FRE's `federation_fetch_endpoint`.
  - Support for `ec_location` is OPTIONAL. If the FRE supports it, it is RECOMMENDED that the claim is included in all Subordinate Statements, also for Entities that publish their Entity Configuration at the well-known location.
  - If `ec_location` is present, the URL MUST return the Entity's Entity Configuration, which MUST meet the expected result of [FRE-OS-021](#fre-os-021).
  - For an Entity whose Entity Configuration is hosted, `ec_location` MUST be present.
- **References**: Section 3.1.3 of \[[OpenID.Federation](#openid-federation)\], Section 2.4.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], \[[OIDC.Sweden.Hosting](#oidc-sweden-hosting)\]

<a name="fre-os-024"></a>
#### FRE-OS-024: Fetch request for an Entity registered under another Intermediate

- **Test data**: REG-X, registered under FED-FRE2.
- **Purpose**: Assert that the FRE only issues Subordinate Statements about Entities it has registered itself.
- **Instructions**: Choose an Entity registered under another Intermediate of the same Trust Anchor. Send a GET request to the FRE's fetch endpoint with `sub` set to its Entity Identifier ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No Entity Statement MUST be returned. The response is expected to be an error that meets the expected result of [FRE-OS-012](#fre-os-012).
- **References**: Section 8.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-025"></a>
#### FRE-OS-025: Fetch request with an unknown parameter

- **Test data**: REG-C1.
- **Purpose**: Assert that the FRE ignores request parameters it does not understand.
- **Instructions**: Fetch the Subordinate Statement about REG-C1 from the FRE ([P-FETCH](procedures.md#p-fetch)). Repeat the fetch request with an additional parameter, for example `foo=bar`.
- **Expected result**: The response MUST be the same as the response to the request without the additional parameter.
- **References**: Section 8 of \[[OpenID.Federation](#openid-federation)\]

<a name="metadata-in-subordinate-statements"></a>
### 3.3. Metadata in Subordinate Statements

The tests in this section inspect the `metadata` and `metadata_policy` claims of the Subordinate Statements about the registered Entities, which each test fetches itself ([P-FETCH](procedures.md#p-fetch)). Under the Swedish profile, the Intermediate that registers an Entity sets the descriptive values it has verified at registration, while federation-wide rules are set by the Trust Anchor. Which values the FRE sets in BAS is tested in the BAS conformance tests, see [FRE-BAS-003](fre_bas_test.md#fre-bas-003).

<a name="fre-os-026"></a>
#### FRE-OS-026: Verifying that protocol parameters are not set by the Intermediate

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the FRE limits itself to descriptive values that it has verified, and leaves protocol parameters to the Entity and to the Trust Anchor's metadata policy.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)). Inspect its `metadata` and `metadata_policy` claims for parameters that are not descriptive values verified at registration.
- **Expected result**:
  - Values in the `metadata` claim SHOULD be limited to descriptive values controlled during registration.
  - The FRE SHOULD NOT set or constrain protocol parameters such as keys, algorithms, endpoints, grant types or authentication methods.
  - Every such parameter must be noted in the report, together with the reason given by the Federation Registration Operator.
- **References**: Section 2.5 and 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-027"></a>
#### FRE-OS-027: Verifying Entity Types and structure of assigned metadata

- **Test data**: Subordinate Statements and Entity Configurations of REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that assigned metadata and policies are well-formed and apply to the Entity's actual Entity Types.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and the Entity's Entity Configuration ([P-EC](procedures.md#p-ec)). Compare the Entity Types in the `metadata` and `metadata_policy` claims of each Subordinate Statement with the Entity Types in the Entity's Entity Configuration.
- **Expected result**:
  - The `metadata` claim SHOULD only contain Entity Types present in the Entity's Entity Configuration, since values for other types have no effect.
  - No metadata value MUST be `null`.
  - Any `metadata_policy` MUST be well-formed and use only allowed operator combinations.
  - If both `metadata` and `metadata_policy` set the same parameter, the outcome of applying `metadata` first and the policy after MUST be the intended value.
- **References**: Section 3.1.1, 5, 6.1.2, 6.1.3 and 6.1.4.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="fre-os-028"></a>
#### FRE-OS-028: Resolving registered Entities

- **Test data**: REG-C1, REG-AS1 and REG-PR1, and FED-TA with its metadata policy.
- **Purpose**: Assert that the metadata assigned by the FRE, merged with the Trust Anchor's policy, resolves without errors and gives the expected Resolved Metadata.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, build the Trust Chain to FED-TA and resolve the metadata ([P-CHAIN](procedures.md#p-chain)), or send a resolve request to the federation's resolver ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**:
  - The Trust Chain MUST validate, and metadata policy resolution MUST NOT produce a policy error.
  - The values assigned by the FRE MUST appear in the Resolved Metadata.
  - Any failure must be noted in the report, together with the reason. Whether the Resolved Metadata meets the BAS requirements is tested in [FRE-BAS-007](fre_bas_test.md#fre-bas-007).
- **References**: Section 6.1.4 and 10.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="registration-policy"></a>
### 3.4. Registration Policy

<a name="fre-os-029"></a>
#### FRE-OS-029: Verifying the registration_policy claim

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that, if the FRE states the registration policies it applied, the `registration_policy` claim is correctly formed and placed.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)), and fetch the FRE's own Entity Configuration ([P-EC](procedures.md#p-ec)). Inspect the `registration_policy` claim of each.
- **Expected result**:
  - Support for `registration_policy` is OPTIONAL in the Swedish profile. Whether the claim is used must be noted in the report.
  - If present, it MUST be an array of URI strings, each identifying a registration policy that was applied when the subject was registered.
  - The claim MUST NOT be present in the FRE's Entity Configuration.
  - The registration policies required in BAS are tested in [FRE-BAS-006](fre_bas_test.md#fre-bas-006).
- **References**: Section 2 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\] and Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-030"></a>
#### FRE-OS-030: Verifying that registration policies satisfy the Trust Anchor's constraints

- **Applies to**: Only if the Trust Anchor sets a `registration_policy` constraint
- **Test data**: The Subordinate Statement of FED-TA about the FRE, and Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that Trust Chains through the FRE satisfy the registration policy constraints set higher in the chain.
- **Instructions**: Fetch the Trust Anchor's Subordinate Statement about the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect its `constraints` claim. For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and the Entity's Entity Configuration ([P-EC](procedures.md#p-ec)). Evaluate each rule of the `registration_policy` constraint against the `registration_policy` claim of the FRE's Subordinate Statements, using the Entity Types of each Entity.
- **Expected result**: Every applicable rule MUST be satisfied for every registered Entity. Any Entity that fails must be noted in the report.
- **References**: Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\] and Section 6.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="constraints"></a>
### 3.5. Constraints

<a name="fre-os-031"></a>
#### FRE-OS-031: Verifying the constraints claim

- **Applies to**: Only if the FRE sets constraints
- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that any constraints the FRE places on its Subordinates are well-formed and consistent with what it registers.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect its `constraints` claim, if present.
- **Expected result**:
  - If `max_path_length` is present, it MUST be an integer greater than or equal to 0.
  - If `naming_constraints` is present, it MUST contain valid domain name constraints that the Entity's Entity Identifier satisfies.
  - If `allowed_entity_types` is present, it MUST NOT contain `federation_entity`, and MUST contain the Entity Types of the Entity.
  - If no constraints are present, this is not an error.
- **References**: Section 3.1.3 and 6.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="subordinate-listing-endpoint-3.6"></a>
### 3.6. Subordinate Listing Endpoint

<a name="fre-os-032"></a>
#### FRE-OS-032: Listing the registered Entities

- **Test data**: REG-C1, REG-AS1 and REG-PR1, the Entities the FRE is expected to have registered.
- **Purpose**: Assert that the FRE lists exactly the Entities it issues Subordinate Statements about.
- **Instructions**: Send a GET request to the `federation_list_endpoint` without parameters ([P-LIST](procedures.md#p-list)).
- **Expected result**:
  - The response MUST have HTTP status code 200 and the content type `application/json`, and MUST be a JSON array of Entity Identifiers.
  - The array MUST contain all Entities the FRE is expected to have registered (see [1.2](#test-setup)). Additional Entities must be noted in the report.
  - For every listed Entity, a Subordinate Statement MUST be available at the fetch endpoint.
- **References**: Section 8.2, 8.2.1 and 8.2.2 of \[[OpenID.Federation](#openid-federation)\] and Section 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-033"></a>
#### FRE-OS-033: Verifying that only Leaf Entities are registered

- **Test data**: The Entity Configurations of REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the FRE registers Federation Protocol Entities as Leaf Entities, and that the federation structure is TA, Intermediate and Leaf Entity.
- **Instructions**: List the Immediate Subordinates of the FRE ([P-LIST](procedures.md#p-list)). For each listed Entity, fetch its Entity Configuration ([P-EC](procedures.md#p-ec)) and inspect its claims.
- **Expected result**:
  - The Entity Configuration of a Federation Protocol Entity MUST NOT contain the `federation_entity` Entity Type.
  - Listed Entities are expected not to be Intermediates. Any Intermediate below the FRE must be noted in the report.
- **References**: Section 2.2 and 2.6.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-034"></a>
#### FRE-OS-034: Listing with the entity_type parameter

- **Test data**: REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the FRE either filters on Entity Type or reports that it does not support the filter.
- **Instructions**: Send GET requests to the list endpoint with `entity_type` set to an Entity Type the FRE registers (for example `oauth_client`), to an Entity Type it does not register, and with two `entity_type` parameters ([P-LIST](procedures.md#p-list)).
- **Expected result**: Two outcomes are accepted:<br/>1. The FRE filters the result: only Entities of the given type are listed, an Entity Type it does not register gives an empty list, and two parameters give the union.<br/>2. The FRE responds with HTTP status code 400, the content type `application/json` and the error code `unsupported_parameter`.<br/>The test fails if the FRE returns an unfiltered list. The outcome must be noted in the report.
- **References**: Section 8.2.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="other-endpoints-and-error-handling-3.7"></a>
### 3.7. Other Endpoints and Error Handling

<a name="fre-os-035"></a>
#### FRE-OS-035: Client authentication at federation endpoints

- **Test data**: REG-C1, whose Federation Entity Keys sign the client assertion.
- **Purpose**: Assert that the FRE's endpoints behave according to the client authentication methods it declares.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)). Send unauthenticated GET requests to each endpoint that does not declare a requirement for client authentication. If any endpoint declares `private_key_jwt`, send the requests described in test case [TA-OS-043](ta_oidf_sweden_test.md#ta-os-043) of the Trust Anchor to the FRE, with `aud` set to the FRE Entity Identifier.
- **Expected result**:
  - Endpoints that declare no `*_auth_methods` parameter, or declare `none`, MUST accept unauthenticated GET requests.
  - Endpoints that require `private_key_jwt` MUST accept correctly authenticated POST requests and MUST reject requests with another `aud`, signed with a key that is not a Federation Entity Key, or without authentication. The error code SHOULD be `invalid_client`.
- **References**: Section 8.8, 8.8.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="new-entities"></a>
### 3.8. New Entities

The test cases in this section and in Section 3.9 assert that what the FRE publishes is correct after an Entity has been added, changed or removed. The registration itself is treated as a black box: the change is made by the Federation Registration Operator according to its own routine, and is a precondition of the test case. The test cases verify only the published result, and the time from the change until it is visible.

<a name="fre-os-036"></a>
#### FRE-OS-036: Registering a new Entity

- **Test data**: TR1, added by the Federation Registration Operator.
- **Purpose**: Assert that a newly registered Entity becomes available in the federation with a correct Subordinate Statement.
- **Precondition**: TR1, a test Entity of an Entity Type the FRE registers whose metadata meets the federation's metadata requirements, has been added. The change is made by the Federation Registration Operator according to its own routine, which is not tested, and the operator states the time it was made.
- **Instructions**: Repeatedly list the registered Entities of the FRE ([P-LIST](procedures.md#p-list)) and fetch the Subordinate Statement about TR1 from the FRE ([P-FETCH](procedures.md#p-fetch)) until it is available. Fetch the Entity Configuration of TR1 ([P-EC](procedures.md#p-ec)), and build the Trust Chain and resolve the metadata ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**:
  - The Entity MUST appear in the list endpoint, and a Subordinate Statement MUST be available at the fetch endpoint, within the expected time stated by the Federation Registration Operator. The time from the stated time of the change must be noted in the report.
  - The Subordinate Statement MUST meet the expected results of [FRE-OS-020](#fre-os-020) to [FRE-OS-023](#fre-os-023), [FRE-OS-026](#fre-os-026), [FRE-OS-027](#fre-os-027) and [FRE-OS-029](#fre-os-029).
  - The Trust Chain and the Resolved Metadata MUST meet the expected result of [FRE-OS-028](#fre-os-028).
- **References**: Section 3 and 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="changes-and-removal"></a>
### 3.9. Changes and Removal

<a name="fre-os-038"></a>
#### FRE-OS-038: Key change at a registered Entity

- **Test data**: TR3, which carries out a key rollover.
- **Purpose**: Assert that the FRE updates the Subordinate Statement when a registered Entity replaces its Federation Entity Keys, so that the Entity's Trust Chain remains valid.
- **Precondition**: TR3 has added a new Federation Entity Key to its Entity Configuration, and the change has been made known to the FRE. The change is made by the Federation Registration Operator according to its own routine, which is not tested, and the operator states the time it was made.
- **Instructions**: Fetch the Subordinate Statement about TR3 from the FRE ([P-FETCH](procedures.md#p-fetch)) at regular intervals. When the new key appears, start signing the Entity Configuration of TR3 with it, and later remove the old key. Throughout, build the Trust Chain of TR3 ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**:
  - The new key MUST appear in the Subordinate Statement within the expected time. The time from the stated time of the change must be noted in the report.
  - The Trust Chain MUST validate throughout the rollover.
- **References**: Section 3.1.1, 4 and 11.1 of \[[OpenID.Federation](#openid-federation)\] and Section 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-os-039"></a>
#### FRE-OS-039: Removing a registered Entity

- **Test data**: TR4, which is removed.
- **Purpose**: Assert that an Entity that is removed from the federation stops being reachable through the FRE.
- **Precondition**: TR4 has been removed. The change is made by the Federation Registration Operator according to its own routine, which is not tested, and the operator states the time it was made.
- **Instructions**: Fetch the Subordinate Statement about TR4 from the FRE ([P-FETCH](procedures.md#p-fetch)) and list the registered Entities ([P-LIST](procedures.md#p-list)).
- **Expected result**:
  - Within the expected time after the stated time of removal, the fetch endpoint MUST NOT return a Subordinate Statement about the Entity, and the list endpoint MUST NOT list it.
  - The time until the last issued Subordinate Statement expires should be noted in the report, since peers may rely on it until then.
- **References**: Section 10.4 and 11.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="key-management"></a>
### 3.10. Key Management

<a name="fre-os-040"></a>
#### FRE-OS-040: Federation key rollover at the Intermediate

- **Test data**: A planned key rollover of the FRE, coordinated with the operator of FED-TA, and REG-C1, REG-AS1 and REG-PR1.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The key rollover periods for Federation Entity Keys.
- **Purpose**: Assert that the FRE can replace its Federation Entity Keys without breaking the Trust Chains of the Entities it has registered.
- **Instructions**: In coordination with the operators of the FRE and the Trust Anchor, follow a planned key rollover of the FRE. Retrieve the FRE's Entity Configuration ([P-EC](procedures.md#p-ec)), the Trust Anchor's Subordinate Statement about the FRE, and a Subordinate Statement about a registered Entity ([P-FETCH](procedures.md#p-fetch)) at regular intervals.
- **Expected result**:
  - The new key MUST be published in the FRE's `jwks`, and in the Trust Anchor's Subordinate Statement about the FRE, before it is used for signing. The time between publication and first use MUST be at least as long as the validity period of the FRE's Entity Configuration.
  - Trust Chains for registered Entities MUST validate throughout the rollover.
- **References**: Section 11.1 of \[[OpenID.Federation](#openid-federation)\]
