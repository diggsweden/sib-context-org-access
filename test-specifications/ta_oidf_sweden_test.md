# Testing of the BAS Trust Anchor – OIDF Sweden Conformance

This document contains a set of test cases that are applied to the Trust Anchor of Federationskontext BAS (BAS), the federation context for machine-to-machine access within, and towards, the Swedish public sector. BAS is operated by the Federation Operator, the Swedish Agency for Digital Government (Digg).

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

This document holds the **OIDF Sweden conformance tests**. They test the Trust Anchor against OpenID Federation \[[OpenID.Federation](#openid-federation)\] and the Swedish OpenID Federation profile \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], with the extensions the profile references. They contain no BAS-specific requirement, and can be reused for any federation based on the Swedish profile. The requirements that BAS adds are tested in the BAS conformance tests, [ta_bas_test.md](ta_bas_test.md). The OIDF Sweden conformance tests are carried out first.

The test cases are grouped by the test data they need:

- **[Section 2](#tests-without-external-test-data)** holds tests that can be carried out against the TA alone, using only what it publishes itself and requests that the tester constructs. They need no test data from superior or subordinate Entities, and can be run as soon as the TA is deployed.
- **[Section 3](#tests-requiring-a-chain-of-test-data)** holds tests that need a chain of test data, such as a Trust Anchor, registered Entities, test Entities or coordination with other operators. Each test case states the data it needs under "Test data".

Note: Where the specifications do not state a concrete value or procedure, or where a value depends on the federation environment (Entity Identifiers, validity periods, test tooling), the test cases are given as an overall description. The tester completes such details from the federation rules and the environment before the test is carried out.

## Table of Contents

1. [**References**](#references)

    1.1. [**Normative Specifications**](#normative-specifications)

    1.2. [**Test Setup**](#test-setup)

2. [**Tests Without External Test Data**](#tests-without-external-test-data)

    2.1. [**Verification of the Trust Anchor's Entity Configuration**](#verification-of-the-trust-anchors-entity-configuration)

    [TA-OS-001](#ta-os-001) Retrieving the Entity Configuration

    [TA-OS-002](#ta-os-002) Verifying the signature of the Entity Configuration

    [TA-OS-003](#ta-os-003) Verifying the claims of the Entity Configuration

    [TA-OS-004](#ta-os-004) Verifying the validity period of the Entity Configuration

    [TA-OS-005](#ta-os-005) Verifying that the Entity Configuration is renewed before it expires

    [TA-OS-006](#ta-os-006) Verifying the federation keys

    [TA-OS-007](#ta-os-007) Comparing the keys with the keys distributed out-of-band

    [TA-OS-008](#ta-os-008) Verifying the trust_mark_issuers claim

    [TA-OS-009](#ta-os-009) Verifying the trust_mark_owners claim

    [TA-OS-010](#ta-os-010) Verifying that the Trust Anchor does not act as Trust Mark Issuer

    2.2. [**Verification of the Trust Anchor's Metadata**](#verification-of-the-trust-anchors-metadata)

    [TA-OS-011](#ta-os-011) Verifying the fetch and list endpoints

    [TA-OS-012](#ta-os-012) Verifying the availability of a Federation Resolver

    [TA-OS-013](#ta-os-013) Verifying other endpoint parameters

    [TA-OS-014](#ta-os-014) Verifying informational metadata

    [TA-OS-015](#ta-os-015) Verifying client authentication metadata for federation endpoints

    [TA-OS-016](#ta-os-016) Verifying that no protocol key parameters are used

    2.3. [**Fetch Endpoint**](#fetch-endpoint)

    [TA-OS-017](#ta-os-017) Fetch request for an unknown subject

    [TA-OS-018](#ta-os-018) Fetch request with sub set to the Trust Anchor itself

    [TA-OS-019](#ta-os-019) Fetch request without sub

    2.4. [**Subordinate Listing Endpoint**](#subordinate-listing-endpoint)

    [TA-OS-020](#ta-os-020) Listing with Trust Mark parameters

    2.5. [**Historical Keys Endpoint**](#historical-keys-endpoint)

    [TA-OS-021](#ta-os-021) Retrieving the historical keys

    2.6. [**Client Authentication and Error Handling**](#client-authentication-and-error-handling)

    [TA-OS-022](#ta-os-022) Unauthenticated requests

    [TA-OS-023](#ta-os-023) Format of error responses

    2.7. [**Document Review**](#document-review)

    [TA-OS-024](#ta-os-024) Reviewing the federation rules

    [TA-OS-025](#ta-os-025) Reviewing the Trust Mark Policy

    [TA-OS-026](#ta-os-026) Reviewing algorithm and interoperability rules

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Verification of the Trust Anchor's Entity Configuration**](#verification-of-the-trust-anchors-entity-configuration-3.1)

    [TA-OS-027](#ta-os-027) Verifying that the Trust Anchor is not chained directly to another Trust Anchor

    3.2. [**Fetch Endpoint**](#fetch-endpoint-3.2)

    [TA-OS-028](#ta-os-028) Fetching a Subordinate Statement about an Immediate Subordinate

    [TA-OS-029](#ta-os-029) Verifying the binding between the Subordinate Statement and the Subordinate

    [TA-OS-030](#ta-os-030) Verifying the validity period of Subordinate Statements

    [TA-OS-031](#ta-os-031) Verifying the source_endpoint and ec_location claims

    [TA-OS-032](#ta-os-032) Fetch request for a Leaf Entity registered under an Intermediate

    [TA-OS-033](#ta-os-033) Fetch request with an unknown parameter

    3.3. [**Metadata Policy and Constraints**](#metadata-policy-and-constraints)

    [TA-OS-034](#ta-os-034) Verifying that the metadata policy is well-formed

    [TA-OS-035](#ta-os-035) Verifying that the metadata policy constrains rather than introduces

    [TA-OS-036](#ta-os-036) Verifying the metadata claim of Subordinate Statements

    [TA-OS-037](#ta-os-037) Verifying the constraints claim

    [TA-OS-038](#ta-os-038) Resolving registered Entities through the Trust Anchor

    3.4. [**Subordinate Listing Endpoint**](#subordinate-listing-endpoint-3.4)

    [TA-OS-039](#ta-os-039) Listing the Immediate Subordinates

    [TA-OS-040](#ta-os-040) Verifying that no Federation Protocol Entity is chained directly under the Trust Anchor

    [TA-OS-041](#ta-os-041) Listing with the entity_type parameter

    [TA-OS-042](#ta-os-042) Listing with the intermediate parameter

    3.5. [**Client Authentication and Error Handling**](#client-authentication-and-error-handling-3.5)

    [TA-OS-043](#ta-os-043) Authenticated requests

    3.6. [**Key Management and Availability**](#key-management-and-availability)

    [TA-OS-044](#ta-os-044) Federation key rollover

    [TA-OS-045](#ta-os-045) Removing an Immediate Subordinate

    [TA-OS-046](#ta-os-046) Key change at an Immediate Subordinate


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

<a name="rfc7517"></a>
**\[RFC7517\]**
> [Jones, M., "JSON Web Key (JWK)", RFC 7517, May 2015](https://tools.ietf.org/html/rfc7517).

<a name="test-setup"></a>
### 1.2. Test Setup

Before the tests are carried out, the tester collects the following information about the Trust Anchor (TA) under test:

| Item | Description |
| :--- | :--- |
| **TA Entity Identifier** | The Entity Identifier of the BAS Trust Anchor in the environment under test (for example the Sandbox). |
| **Out-of-band TA keys** | The Trust Anchor's Federation Entity Keys as distributed by the Federation Operator by other means than the Entity Configuration (for example on the federation web site). |
| **Expected Immediate Subordinates** | The Entity Identifiers of the Federation Registration Entities (connection services, Swedish: anslutningstjänster) of the Federation Registration Operators connected to BAS. These are the only Immediate Subordinates of the BAS Trust Anchor. |
| **Federation rules** | The BAS federation rules \[[BAS.Rules](#bas-rules)\]: validity periods for Entity Statements, key rollover intervals, permitted grant types, registration policies and, if Trust Marks are used, the Trust Mark Policy. The federation-wide metadata policy is published in Section 7.1 of \[[BAS.Metadata](#bas-metadata)\]. |
| **Resolver** | The Entity Identifier and resolve endpoint of the Federation Resolver that the Federation Operator provides for the TA. The resolver itself is tested according to [Testing of the BAS Federation Resolver](resolver_overview.md). |

Test cases that only apply under a condition, for example if Trust Marks are used, state this under "Applies to".

Note: The BAS specifications do not define any Trust Marks. The test cases for Trust Marks apply only if the BAS federation rules introduce them.

Note: The tool at https://jwt.io can be used to inspect Entity Statements and Trust Marks. For test cases that validate signatures and Trust Chains, an independent OpenID Federation implementation is used, so that the TA is not validated by its own software.

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the TA alone. They use what the TA publishes itself, requests that the tester constructs, and, for document reviews, the federation's own documents.

<a name="verification-of-the-trust-anchors-entity-configuration"></a>
### 2.1. Verification of the Trust Anchor's Entity Configuration

This section contains tests that assert that the TA publishes a valid Entity Configuration under `<TA Entity Identifier>/.well-known/openid-federation`. The tests check compliance against Section 3 and 9 of \[[OpenID.Federation](#openid-federation)\] and against the Swedish profile.

Note: The contents of the `metadata` claim are tested in Section [2.2](#verification-of-the-trust-anchors-metadata).

<a name="ta-os-001"></a>
#### TA-OS-001: Retrieving the Entity Configuration

- **Purpose**: Assert that the TA publishes its Entity Configuration at the well-known location, which is mandatory for Trust Anchors, and that it is delivered as an Entity Statement over TLS.
- **Instructions**: Send an HTTP GET request to `<TA Entity Identifier>/.well-known/openid-federation`.
- **Expected result**:
  - The TA Entity Identifier MUST use the `https` scheme, MUST have a host component and MUST NOT contain query or fragment components.
  - The response MUST have HTTP status code 200.
  - The response MUST have the content type `application/entity-statement+jwt`.
  - The response body MUST be a signed JWT.
- **References**: Section 1.2, 9, 9.1 and 9.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-002"></a>
#### TA-OS-002: Verifying the signature of the Entity Configuration

- **Purpose**: Assert that the Entity Configuration is correctly typed and self-signed with one of the TA's Federation Entity Keys.
- **Instructions**: Decode the JWT from [TA-OS-001](#ta-os-001) and check its header and signature.
- **Expected result**:
  - The `typ` header parameter MUST be `entity-statement+jwt`.
  - The `alg` header parameter MUST be present and MUST NOT be `none`. It SHOULD be one of `RS256`, `RS384`, `RS512`, `ES256`, `ES384` or `ES512`, since these are the algorithms all federation members must be able to validate. Any other algorithm should be noted in the report.
  - The `kid` header parameter MUST be present, MUST NOT be empty, and MUST match the `kid` of a key in the `jwks` claim of the Entity Configuration.
  - The signature MUST validate using that key.
  - The JWT MUST NOT contain the `trust_chain` or `peer_trust_chain` header parameters.
- **References**: Section 3, 3.2, 4.3 and 4.4 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-003"></a>
#### TA-OS-003: Verifying the claims of the Entity Configuration

- **Purpose**: Assert that the Entity Configuration contains the claims required for a Trust Anchor, and none of the claims that belong to other kinds of Entity Statements.
- **Instructions**: Decode the JWT from [TA-OS-001](#ta-os-001) and inspect its claims.
- **Expected result**:
  - `iss` and `sub` MUST both be equal to the TA Entity Identifier.
  - `iat` and `exp` MUST be present and be JSON numbers.
  - `jwks` MUST be present (checked further in [TA-OS-006](#ta-os-006)).
  - `authority_hints` and `trust_anchor_hints` MUST NOT be present, since the TA has no Superiors. If the TA has a Superior (a hierarchy of federations), this must be noted in the report, see also [TA-OS-027](#ta-os-027).
  - `metadata` MUST be present and MUST contain the `federation_entity` Entity Type.
  - `metadata` MUST NOT contain any Entity Type of a Federation Protocol Entity, such as `openid_provider`, `openid_relying_party`, `oauth_client`, `oauth_authorization_server` or `oauth_resource`.
  - The claims `metadata_policy`, `metadata_policy_crit`, `constraints`, `source_endpoint`, `aud` and `registration_policy` MUST NOT be present.
  - If `crit` is present, it MUST NOT be an empty array and MUST NOT list any claim defined by \[[OpenID.Federation](#openid-federation)\]. Its presence should be noted in the report.
- **References**: Section 3.1.1, 3.1.2, 3.1.3, 3.2, 9.2 and 13.4 of \[[OpenID.Federation](#openid-federation)\], Section 2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 2 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\]

<a name="ta-os-004"></a>
#### TA-OS-004: Verifying the validity period of the Entity Configuration

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The validity period for Entity Statements.
- **Purpose**: Assert that the Entity Configuration is valid at the time of testing, and that its validity period follows the federation rules.
- **Instructions**: Retrieve the Entity Configuration according to [TA-OS-001](#ta-os-001) and note the time of retrieval. Compare `iat` and `exp` with that time, with each other, and with the validity period stated in the federation rules.
- **Expected result**:
  - `iat` MUST NOT be later than the time of retrieval.
  - `exp` MUST be later than the time of retrieval.
  - `exp` minus `iat` is expected to equal the validity period stated in the federation rules. If the federation rules state no period, this should be noted in the report, and the period used by the TA should be noted.
  - A clock skew of 10 seconds is allowed for all comparisons against the tester's clock.
- **References**: Section 3.1.1, 3.2 and 11.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 and 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-005"></a>
#### TA-OS-005: Verifying that the Entity Configuration is renewed before it expires

- **Purpose**: Assert that the TA publishes a new Entity Configuration well before the current one expires, so that participants always find a valid Entity Configuration.
- **Instructions**: Retrieve the Entity Configuration and note `iat` and `exp`. Retrieve it again after half of the lifetime (`(exp - iat) / 2`) has elapsed, and again shortly before `exp`.
- **Expected result**:
  - Before the first `exp` is reached, the TA MUST publish an Entity Configuration with a later `exp`.
  - It is RECOMMENDED that a new Entity Configuration is published when half of the lifetime has elapsed. If the TA renews later than that, this should be noted in the report.
- **References**: Section 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 11.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-006"></a>
#### TA-OS-006: Verifying the federation keys

- **Purpose**: Assert that the TA's Federation Entity Keys meet the security requirements and can be told apart during key rollover.
- **Instructions**: Inspect each key in the `jwks` claim of the Entity Configuration.
- **Expected result**:
  - `jwks` MUST be a valid JWK Set.
  - Every key MUST have a `kid`, and each `kid` MUST be unique within the set. It is RECOMMENDED that the `kid` is the SHA-256 JWK Thumbprint of the key. Other `kid` values should be noted in the report.
  - The set MUST NOT contain private or symmetric key material.
  - The tester notes the type and length of each key. Neither \[[OpenID.Federation](#openid-federation)\] nor \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] states a minimum key length. The profile recommends that the federation rules do, and the key lengths are checked against the BAS requirements in [TA-BAS-001](ta_bas_test.md#ta-bas-001).
- **References**: Section 3.1.1 and 13.1 of \[[OpenID.Federation](#openid-federation)\], Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and \[[RFC7517](#rfc7517)\]

<a name="ta-os-007"></a>
#### TA-OS-007: Comparing the keys with the keys distributed out-of-band

- **Purpose**: Assert that the keys in the Entity Configuration are the keys that the Federation Operator distributes by other means, since federation participants configure their trust in the TA from those.
- **Instructions**: Obtain the TA keys that the Federation Operator publishes independently of the Entity Configuration. Compare them with the keys in the `jwks` claim.
- **Expected result**:
  - The key that signed the Entity Configuration MUST be among the keys distributed out-of-band.
  - The two sets SHOULD be identical. Differences, for example during an ongoing key rollover, must be noted in the report.
  - If the Federation Operator provides no independent means of retrieving the TA keys, this should be noted in the report, since it is RECOMMENDED.
- **References**: Section 4, 11.2 and 11.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-008"></a>
#### TA-OS-008: Verifying the trust_mark_issuers claim

- **Applies to**: Only if the federation uses Trust Marks
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that the TA states which Trust Mark Issuers are accredited to issue each Trust Mark type recognized by the federation, in accordance with the Trust Mark Policy.
- **Instructions**: Before the test, note the Trust Mark types and Trust Mark Issuers that the federation's Trust Mark Policy recognizes. Inspect the `trust_mark_issuers` claim of the Entity Configuration.
- **Expected result**:
  - `trust_mark_issuers` MUST be a JSON object whose member names are Trust Mark type identifiers and whose values are arrays of Entity Identifiers.
  - Each recognized Trust Mark type MUST be present, with exactly the Trust Mark Issuers that the Trust Mark Policy authorizes.
  - Trust Mark type identifiers SHOULD be built from the federation's base URL.
  - An empty array means that anyone may issue the Trust Mark type. Any empty array must be noted in the report and justified by the Trust Mark Policy.
- **References**: Section 3.1.2, 7 and 7.1 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1, 5.1 and 5.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-009"></a>
#### TA-OS-009: Verifying the trust_mark_owners claim

- **Applies to**: Only if Trust Mark delegation is used
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks, and Trust Mark delegation, are used in BAS.
- **Purpose**: Assert that the TA states the owners of Trust Mark types that are issued by delegation, so that delegated Trust Marks can be validated.
- **Instructions**: Inspect the `trust_mark_owners` claim of the Entity Configuration, if present.
- **Expected result**:
  - If the Federation Operator knows that a Trust Mark type is owned by an Entity other than its issuer, `trust_mark_owners` MUST be present for that type.
  - Each member MUST be a JSON object with `sub` holding an Entity Identifier and `jwks` holding a valid JWK Set.
  - If the claim is absent, this is not an error. Its absence should be noted in the report.
- **References**: Section 3.1.2, 3.2, 7.2 and 7.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-010"></a>
#### TA-OS-010: Verifying that the Trust Anchor does not act as Trust Mark Issuer

- **Purpose**: Assert that the TA is not also a Trust Mark Issuer, which the Swedish profile advises against since it makes Trust Chain evaluation ambiguous for other federations that chain to the Trust Anchor's Subordinates.
- **Instructions**: Inspect the `federation_entity` metadata and the `trust_mark_issuers` claim of the Entity Configuration.
- **Expected result**:
  - The `federation_entity` metadata SHOULD NOT contain `federation_trust_mark_endpoint`, `federation_trust_mark_status_endpoint` or `federation_trust_mark_list_endpoint`.
  - The TA Entity Identifier SHOULD NOT be listed as an issuer in `trust_mark_issuers`.
  - If the TA acts as Trust Mark Issuer, this must be noted in the report.
- **References**: Section 2.6.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 17.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="verification-of-the-trust-anchors-metadata"></a>
### 2.2. Verification of the Trust Anchor's Metadata

This section contains tests for the `federation_entity` part of the `metadata` claim of the TA's Entity Configuration.

<a name="ta-os-011"></a>
#### TA-OS-011: Verifying the fetch and list endpoints

- **Purpose**: Assert that the TA publishes the endpoints that participants need to build Trust Chains and to discover the federation.
- **Instructions**: Inspect `federation_fetch_endpoint` and `federation_list_endpoint` in the `federation_entity` metadata.
- **Expected result**:
  - Both parameters MUST be present.
  - Each URL MUST use the `https` scheme and MUST NOT contain a fragment component.
- **References**: Section 5.1.1, 8.1 and 8.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-012"></a>
#### TA-OS-012: Verifying the availability of a Federation Resolver

- **Purpose**: Assert that the Federation Operator makes at least one Federation Resolver available for the TA, preferably provided by the TA itself.
- **Instructions**: Inspect `federation_resolve_endpoint` in the `federation_entity` metadata. If it is absent, find out from the Federation Operator which Entity provides the resolver for the TA, and retrieve that Entity's Entity Configuration.
- **Expected result**:
  - A Federation Resolver that supports resolving for the TA MUST be available.
  - It is RECOMMENDED that the resolver is provided by the TA itself, that is, that `federation_resolve_endpoint` is present in the TA's metadata. If it is present, the URL MUST use the `https` scheme and MUST NOT contain a fragment component.
  - If the resolver is provided by another Entity, this must be noted in the report, since participants that rely on the resolver then need to configure trust in two Federation Entity Keys.
- **References**: Section 2.3 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 5.1.1, 8.3.3 and 17.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-013"></a>
#### TA-OS-013: Verifying other endpoint parameters

- **Purpose**: Assert that any other federation endpoint the TA publishes is correctly declared.
- **Instructions**: Inspect all parameters ending in `_endpoint` in the `federation_entity` metadata, other than those tested in [TA-OS-011](#ta-os-011) and [TA-OS-012](#ta-os-012).
- **Expected result**:
  - Each URL MUST use the `https` scheme and MUST NOT contain a fragment component.
  - `federation_historical_keys_endpoint` is OPTIONAL. If present, it is tested in [TA-OS-021](#ta-os-021).
  - The endpoints of a Trust Mark Issuer are covered by [TA-OS-010](#ta-os-010).
- **References**: Section 5.1.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-014"></a>
#### TA-OS-014: Verifying informational metadata

- **Purpose**: Assert that the TA states who operates it, how the operators can be reached, and where the federation rules are found.
- **Instructions**: Inspect the informational parameters in the `federation_entity` metadata.
- **Expected result**:
  - `organization_name` is RECOMMENDED and is expected to be the name of the Federation Operator.
  - `contacts` is expected to hold at least one email address.
  - `policy_uri`, `organization_uri` and `information_uri` are OPTIONAL. If present, they MUST use the `https` scheme and point to existing web pages. It is recommended that `policy_uri` points to the federation rules.
  - Human-readable values are expected in Swedish and English, using language tags. Missing values should be noted in the report.
  - No metadata value MUST be `null`.
- **References**: Section 5, 5.1.1, 5.2.2 and 14 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-015"></a>
#### TA-OS-015: Verifying client authentication metadata for federation endpoints

- **Purpose**: Assert that, where the TA requires client authentication at its endpoints, it declares the methods and the mandatory signature algorithms.
- **Instructions**: Inspect any `*_auth_methods` parameters and `endpoint_auth_signing_alg_values_supported` in the `federation_entity` metadata.
- **Expected result**:
  - If no `*_auth_methods` parameter is present, all endpoints are expected to accept unauthenticated requests (tested in [TA-OS-022](#ta-os-022)).
  - If any `*_auth_methods` parameter contains `private_key_jwt`, `endpoint_auth_signing_alg_values_supported` MUST be present and MUST contain `RS256`, `RS384`, `RS512`, `ES256`, `ES384` and `ES512`.
  - `endpoint_auth_signing_alg_values_supported` MUST NOT contain `none`.
- **References**: Section 5.1.1, 8.8 and 8.8.1 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-016"></a>
#### TA-OS-016: Verifying that no protocol key parameters are used

- **Purpose**: Assert that the TA does not publish protocol keys in its `federation_entity` metadata, since its Federation Entity Keys belong in the `jwks` claim.
- **Instructions**: Inspect the `federation_entity` metadata.
- **Expected result**: `jwks`, `jwks_uri` and `signed_jwks_uri` MUST NOT be present in the `federation_entity` metadata.
- **References**: Section 5.2.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="fetch-endpoint"></a>
### 2.3. Fetch Endpoint

The tests in this section use the `federation_fetch_endpoint` found in [TA-OS-011](#ta-os-011). Unless stated otherwise, requests are sent using GET without client authentication.

<a name="ta-os-017"></a>
#### TA-OS-017: Fetch request for an unknown subject

- **Purpose**: Assert that the TA does not issue a Subordinate Statement for an Entity it has not registered, and that it responds with a correct error.
- **Instructions**: Send a GET request to the fetch endpoint with `sub` set to an Entity Identifier that is not known to the federation, for example `https://unknown.example.se`.
- **Expected result**:
  - No Entity Statement MUST be returned.
  - The response MUST have the content type `application/json` and contain `error` and `error_description`.
  - `error` SHOULD be `not_found` with HTTP status code 404. Any other code should be noted in the report.
- **References**: Section 8.1.2 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-018"></a>
#### TA-OS-018: Fetch request with sub set to the Trust Anchor itself

- **Purpose**: Assert that the TA does not issue a Subordinate Statement about itself.
- **Instructions**: Send a GET request to the fetch endpoint with `sub` set to the TA Entity Identifier.
- **Expected result**:
  - No Entity Statement MUST be returned.
  - `error` SHOULD be `invalid_request` with HTTP status code 400. Any other code should be noted in the report.
- **References**: Section 8.1.2 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-019"></a>
#### TA-OS-019: Fetch request without sub

- **Purpose**: Assert that the TA rejects a fetch request that lacks the required `sub` parameter.
- **Instructions**: Send a GET request to the fetch endpoint without query parameters.
- **Expected result**:
  - No Entity Statement MUST be returned.
  - `error` SHOULD be `invalid_request` with HTTP status code 400, and the response MUST have the content type `application/json`. Anything else should be noted in the report.
- **References**: Section 8.1.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="subordinate-listing-endpoint"></a>
### 2.4. Subordinate Listing Endpoint

<a name="ta-os-020"></a>
#### TA-OS-020: Listing with Trust Mark parameters

- **Purpose**: Find out how the TA handles Trust Mark filtering, which is only meaningful for a Trust Mark Issuer.
- **Instructions**: Send GET requests to the list endpoint with `trust_marked=true`, and with `trust_mark_type` set to one of the types in `trust_mark_issuers`.
- **Expected result**: Since the TA is not expected to issue Trust Marks (see [TA-OS-010](#ta-os-010)), it is expected to respond with HTTP status code 400 and the error code `unsupported_parameter`. If it returns a list, the contents must be noted in the report.
- **References**: Section 8.2.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="historical-keys-endpoint"></a>
### 2.5. Historical Keys Endpoint

<a name="ta-os-021"></a>
#### TA-OS-021: Retrieving the historical keys

- **Applies to**: Only if `federation_historical_keys_endpoint` is published
- **Purpose**: Assert that the TA publishes its previously used Federation Entity Keys in a signed and correctly formed document, so that historical Trust Chains can be verified.
- **Instructions**: Send a GET request to the `federation_historical_keys_endpoint`.
- **Expected result**:
  - The response MUST have HTTP status code 200 and the content type `application/jwk-set+jwt`.
  - `typ` MUST be `jwk-set+jwt`, `kid` MUST be present, and the signature MUST validate with a key in the TA's current `jwks`.
  - `iss` MUST be the TA Entity Identifier, and `iat` and `keys` MUST be present.
  - Every key MUST have `kid` and `exp`. If `revoked` is present, it MUST contain `revoked_at`, and `reason`, if present, SHOULD be one of `unspecified`, `compromised` or `superseded`.
  - Keys that the tester knows have been rolled over by the TA are expected to be listed.
- **References**: Section 8.7, 8.7.1, 8.7.2 and 8.7.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="client-authentication-and-error-handling"></a>
### 2.6. Client Authentication and Error Handling

<a name="ta-os-022"></a>
#### TA-OS-022: Unauthenticated requests

- **Purpose**: Assert that the TA's endpoints behave according to the client authentication methods it declares.
- **Instructions**: For each endpoint, check the corresponding `*_auth_methods` parameter from [TA-OS-015](#ta-os-015). Send an unauthenticated GET request to each endpoint that does not declare a requirement for client authentication.
- **Expected result**: An endpoint that declares no `*_auth_methods` parameter, or declares `none`, MUST accept unauthenticated GET requests.
- **References**: Section 8.8 and 8.8.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-023"></a>
#### TA-OS-023: Format of error responses

- **Purpose**: Assert that the TA's error responses can be interpreted by participants.
- **Instructions**: Review the error responses received in [TA-OS-017](#ta-os-017), [TA-OS-018](#ta-os-018), [TA-OS-019](#ta-os-019) and in Section [2.4](#subordinate-listing-endpoint).
- **Expected result**: Every error response SHOULD have the content type `application/json` and MUST contain `error` and `error_description`. The HTTP status code SHOULD match the error code as stated in Section 8.9 of \[[OpenID.Federation](#openid-federation)\].
- **References**: Section 8.9 and 18.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="document-review"></a>
### 2.7. Document Review

The test cases in this section are document reviews. They assert that the Federation Operator, as manifested by the TA, has defined the rules the Swedish profile requires. How the BAS documents fulfil the rules is reviewed in the BAS conformance tests, see [TA-BAS-003](ta_bas_test.md#ta-bas-003) and [TA-BAS-004](ta_bas_test.md#ta-bas-004).

<a name="ta-os-024"></a>
#### TA-OS-024: Reviewing the federation rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The content of the federation rules as a whole.
- **Purpose**: Assert that the federation rules cover what the Swedish profile requires of a Federation Operator.
- **Instructions**: Review the published federation rules.
- **Expected result**: The federation rules:
  - MUST define the rules and requirements for joining the federation. Registration Policies are RECOMMENDED.
  - MUST define the protocol-specific requirements, including referenced standards and profiles, algorithm support and metadata requirements.
  - SHOULD define a Trust Mark Policy (see [TA-OS-025](#ta-os-025)).
  - SHOULD define federation-wide security requirements, such as minimum key lengths, key rollover frequency and client authentication requirements.
  - SHOULD define recommended validity periods for Entity Statements.
  - SHOULD define a base URL for the federation, used for collision-resistant identifiers.
  - Every missing item must be noted in the report.
- **References**: Section 2.1, 2.4.1 and 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-025"></a>
#### TA-OS-025: Reviewing the Trust Mark Policy

- **Applies to**: Only if the federation uses Trust Marks
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The Trust Mark Policy, if Trust Marks are used in BAS.
- **Purpose**: Assert that the Trust Mark Policy defines how Trust Marks are issued, recognized and obtained, and that it matches what the TA publishes.
- **Instructions**: Review the Trust Mark Policy and compare it with `trust_mark_issuers` (see [TA-OS-008](#ta-os-008)).
- **Expected result**: The Trust Mark Policy SHOULD define:
  - How Trust Mark Issuers are accredited, and the requirements that apply to them.
  - The Trust Mark types recognized by the federation, their identifiers, and which Trust Mark Issuers may issue each type.
  - Whether Trust Mark Issuers may issue types that are not recognized federation-wide.
  - Whether Entities are required to include their Trust Marks in their Entity Configurations, or whether peers and resolvers may obtain them from the Trust Mark Issuer.
  - Rules for validating Trust Marks, including status checking, MAY be defined, and it is RECOMMENDED that they cover status checking.
  - The policy is expected to match `trust_mark_issuers`. Differences must be noted in the report.
- **References**: Section 5.1, 5.2 and 5.3 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 7 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-026"></a>
#### TA-OS-026: Reviewing algorithm and interoperability rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The algorithm and client authentication rules, together with BAS Security Requirements.
- **Purpose**: Assert that the federation rules handle the interoperability issues that arise when protocol metadata is consumed by many peers.
- **Instructions**: Review the federation rules for the items listed in Section 7 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\].
- **Expected result**:
  - If support for OpenID Connect Relying Party Metadata Choices is not mandated, the rules SHOULD state the algorithms that are mandatory to support for signature validation and, where encryption is used, for encryption and decryption.
  - It is RECOMMENDED that the rules state which client authentication methods servers support.
  - It is RECOMMENDED that the rules require OpenID Providers to support both the `public` and `pairwise` subject types, where the federation admits OpenID Providers. Not applicable to BAS.
  - Missing items must be noted in the report.
- **References**: Section 7 and 7.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="verification-of-the-trust-anchors-entity-configuration-3.1"></a>
### 3.1. Verification of the Trust Anchor's Entity Configuration

This section contains tests that assert that the TA publishes a valid Entity Configuration under `<TA Entity Identifier>/.well-known/openid-federation`. The tests check compliance against Section 3 and 9 of \[[OpenID.Federation](#openid-federation)\] and against the Swedish profile.

Note: The contents of the `metadata` claim are tested in Section [2.2](#verification-of-the-trust-anchors-metadata).

<a name="ta-os-027"></a>
#### TA-OS-027: Verifying that the Trust Anchor is not chained directly to another Trust Anchor

- **Test data**: Information from the Federation Operator about any other Trust Anchor that FED-TA is registered under.
- **Purpose**: Assert that the TA is not a direct Subordinate of another Trust Anchor, which increases the risk of metadata policy merge conflicts.
- **Instructions**: Ask the Federation Operator whether the TA is registered as a Subordinate of any other Trust Anchor. If so, fetch the Subordinate Statement about the TA from that Trust Anchor.
- **Expected result**: The TA SHOULD NOT be chained directly to another Trust Anchor. Any such chaining must be noted in the report, together with the other Trust Anchor's Entity Identifier.
- **References**: Section 2.6.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 4.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="fetch-endpoint-3.2"></a>
### 3.2. Fetch Endpoint

The tests in this section use the `federation_fetch_endpoint` found in [TA-OS-011](#ta-os-011). Unless stated otherwise, requests are sent using GET without client authentication.

<a name="ta-os-028"></a>
#### TA-OS-028: Fetching a Subordinate Statement about an Immediate Subordinate

- **Test data**: FED-FRE1 and FED-FRE2, registered as Immediate Subordinates of FED-TA.
- **Purpose**: Assert that the TA issues a correctly formed and signed Subordinate Statement about each of its Immediate Subordinates.
- **Instructions**: For each expected Immediate Subordinate (see [1.2](#test-setup)), send a GET request to the fetch endpoint with `sub` set to the Subordinate's Entity Identifier.
- **Expected result**: For each request:
  - The response MUST have HTTP status code 200 and the content type `application/entity-statement+jwt`.
  - `typ` MUST be `entity-statement+jwt`, `alg` MUST NOT be `none`, and `kid` MUST match a key in the `jwks` claim of the TA's Entity Configuration. The signature MUST validate with that key.
  - `iss` MUST be the TA Entity Identifier, and `sub` MUST be the requested Entity Identifier.
  - `iat`, `exp` and `jwks` MUST be present.
  - The claims `authority_hints`, `trust_anchor_hints`, `trust_marks`, `trust_mark_issuers` and `trust_mark_owners` MUST NOT be present.
  - The JWT MUST NOT contain the `trust_chain` or `peer_trust_chain` header parameters.
- **References**: Section 3, 3.1, 3.2, 4.3, 4.4, 8.1 and 8.1.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-029"></a>
#### TA-OS-029: Verifying the binding between the Subordinate Statement and the Subordinate

- **Test data**: The Entity Configurations of FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the Subordinate Statement binds the correct Federation Entity Keys to the Subordinate, so that a Trust Chain can be built.
- **Instructions**: For each Subordinate Statement from [TA-OS-028](#ta-os-028), retrieve the Subordinate's Entity Configuration from its well-known location.
- **Expected result**:
  - The key that signed the Subordinate's Entity Configuration MUST be present in the `jwks` claim of the Subordinate Statement.
  - The keys in the Subordinate Statement are expected to be identical to the keys in the Subordinate's Entity Configuration. Differences, for example during a key rollover, must be noted in the report.
  - The `authority_hints` of the Subordinate's Entity Configuration MUST contain the TA Entity Identifier.
  - If the Subordinate Statement contains `metadata`, it MUST only contain Entity Types that are present in the Subordinate's Entity Configuration.
- **References**: Section 3.1.1, 3.2 and 4 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-030"></a>
#### TA-OS-030: Verifying the validity period of Subordinate Statements

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The validity period for Entity Statements.
- **Purpose**: Assert that Subordinate Statements are valid when issued and that their validity follows the federation rules.
- **Instructions**: For each Subordinate Statement from [TA-OS-028](#ta-os-028), compare `iat` and `exp` with the time of retrieval and with the validity period in the federation rules.
- **Expected result**:
  - `iat` MUST NOT be later, and `exp` MUST be later, than the time of retrieval. A clock skew of 10 seconds is allowed.
  - `exp` minus `iat` is expected to follow the federation rules. Deviations, or the absence of a stated period, should be noted in the report.
- **References**: Section 3.1.1, 3.2 and 10.4 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 and 2.4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-031"></a>
#### TA-OS-031: Verifying the source_endpoint and ec_location claims

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that optional location claims in Subordinate Statements are correct.
- **Instructions**: Inspect `source_endpoint` and `ec_location` in the Subordinate Statements from [TA-OS-028](#ta-os-028).
- **Expected result**:
  - If `source_endpoint` is present, it MUST be equal to the TA's `federation_fetch_endpoint`.
  - Support for `ec_location` is OPTIONAL. If present, the URL MUST return the Subordinate's Entity Configuration. Its presence should be noted in the report.
- **References**: Section 3.1.3 and 3.2 of \[[OpenID.Federation](#openid-federation)\], Section 2.4.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and \[[OIDC.Sweden.Hosting](#oidc-sweden-hosting)\]

<a name="ta-os-032"></a>
#### TA-OS-032: Fetch request for a Leaf Entity registered under an Intermediate

- **Test data**: REG-C1, registered under FED-FRE1.
- **Purpose**: Assert that the TA only issues Subordinate Statements about its Immediate Subordinates, and not about Entities registered further down the hierarchy.
- **Instructions**: Choose a Leaf Entity registered under one of the Intermediates (in BAS, an OAuth 2.0 Client registered by a Federation Registration Entity). Send a GET request to the TA's fetch endpoint with `sub` set to its Entity Identifier.
- **Expected result**: No Entity Statement MUST be returned. The response is expected to be an error as in [TA-OS-017](#ta-os-017).
- **References**: Section 4 and 8.1 of \[[OpenID.Federation](#openid-federation)\] and Section 2.6.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-033"></a>
#### TA-OS-033: Fetch request with an unknown parameter

- **Test data**: FED-FRE1.
- **Purpose**: Assert that the TA ignores request parameters it does not understand.
- **Instructions**: Repeat one request from [TA-OS-028](#ta-os-028) with an additional parameter, for example `foo=bar`.
- **Expected result**: The response MUST be the same as in [TA-OS-028](#ta-os-028).
- **References**: Section 8 of \[[OpenID.Federation](#openid-federation)\]

<a name="metadata-policy-and-constraints"></a>
### 3.3. Metadata Policy and Constraints

The tests in this section inspect the `metadata_policy`, `metadata`, `metadata_policy_crit` and `constraints` claims of the Subordinate Statements from [TA-OS-028](#ta-os-028). They check that the policy and constraints are well-formed and used as the Swedish profile intends. That the policy holds the values BAS requires is tested in the BAS conformance tests, see [TA-BAS-005](ta_bas_test.md#ta-bas-005).

<a name="ta-os-034"></a>
#### TA-OS-034: Verifying that the metadata policy is well-formed

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the metadata policy can be resolved by any compliant implementation without producing a policy error.
- **Instructions**: Validate the `metadata_policy` claim of each Subordinate Statement against the rules of Section 6.1 of \[[OpenID.Federation](#openid-federation)\], for example using an independent implementation.
- **Expected result**:
  - The structure MUST have the three levels Entity Type, metadata parameter and operator, with no duplicate member names.
  - Every operator MUST be configured with a JSON value type that the operator supports, and only allowed operator combinations MUST be used (for example, the values of `value` within `one_of`, and `subset_of` being a superset of `superset_of`).
  - If operators other than the standard ones are used, they MUST be listed in `metadata_policy_crit` if they have to be understood. `metadata_policy_crit`, if present, MUST NOT be an empty array and MUST NOT list standard operators.
  - No operator value MUST be `null`, except for the `value` operator when a parameter is to be removed.
- **References**: Section 3.1.3, 6.1.2, 6.1.3, 6.1.3.1 and 6.1.3.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-035"></a>
#### TA-OS-035: Verifying that the metadata policy constrains rather than introduces

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the policy is used to constrain, filter or refine what Entities declare, and that values added by the policy are values that every Entity in the federation is required to support.
- **Instructions**: Identify the operators in the policy that add values (`value`, `add` and `default`). For each, find the requirement in the federation rules that motivates it.
- **Expected result**:
  - Values added by the policy SHOULD NOT introduce capabilities or preferences that an Entity may not support. Values that the federation rules require every Entity to support are accepted. The values added by the BAS policy are reviewed in [TA-BAS-007](ta_bas_test.md#ta-bas-007).
  - Every added value that is not backed by a requirement in the federation rules must be noted in the report.
- **References**: Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-036"></a>
#### TA-OS-036: Verifying the metadata claim of Subordinate Statements

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the TA does not set per-Entity values for Entities other than its Immediate Subordinates, since such values are set by the Intermediate that registers an Entity.
- **Instructions**: Inspect the `metadata` claim, if present, of each Subordinate Statement.
- **Expected result**:
  - If present, the `metadata` claim SHOULD only hold descriptive values for the Immediate Subordinate itself, such as `organization_name` under `federation_entity`.
  - The TA MUST NOT use the `metadata` claim to set values for protocol Entity Types, since these would only apply to the Intermediate and not to the Leaf Entities.
  - No metadata value MUST be `null`.
- **References**: Section 3.1.1 and 5 of \[[OpenID.Federation](#openid-federation)\], Section 2.5 and 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-037"></a>
#### TA-OS-037: Verifying the constraints claim

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that any constraints the TA places on its Subordinates are well-formed and consistent with the federation structure.
- **Instructions**: Inspect the `constraints` claim, if present, of each Subordinate Statement. Compare it with the federation structure (TA, Intermediate, Leaf Entity).
- **Expected result**:
  - If `max_path_length` is present, it MUST be an integer greater than or equal to 0, and MUST allow the Intermediate (at least 1 when the Intermediate is counted between the TA and the Leaf).
  - If `naming_constraints` is present, the `permitted` and `excluded` names MUST be valid domain name constraints, and MUST allow the Entity Identifiers of Entities already registered.
  - If `allowed_entity_types` is present, it MUST NOT contain `federation_entity`, and is expected to list only the Entity Types that the federation admits. For BAS, see [TA-BAS-008](ta_bas_test.md#ta-bas-008).
  - If the `registration_policy` constraint is used, each rule MUST contain a non-empty `policy` array of URIs, and `entity_types`, if present, MUST be a non-empty array. The registration policies required in BAS are tested in [TA-BAS-009](ta_bas_test.md#ta-bas-009).
  - Constraints that do not match the federation structure must be noted in the report.
- **References**: Section 3.1.3, 6.2, 6.2.1, 6.2.2 and 6.2.3 of \[[OpenID.Federation](#openid-federation)\], Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\]

<a name="ta-os-038"></a>
#### TA-OS-038: Resolving registered Entities through the Trust Anchor

- **Test data**: REG-C1, REG-AS1 and REG-PR1 under FED-FRE1, and REG-X under FED-FRE2.
- **Purpose**: Assert that the policy and constraints of the TA, merged with those of the Intermediates, can be resolved for registered Entities without errors.
- **Instructions**: For each Immediate Subordinate, choose at least one registered Leaf Entity of each Entity Type it registers. Build and validate the Trust Chain from the Leaf Entity to the TA using an independent implementation, and resolve its metadata.
- **Expected result**:
  - The Trust Chain MUST validate, and metadata policy resolution MUST NOT produce a policy error.
  - Whether the Resolved Metadata meets the BAS requirements is tested in [TA-BAS-010](ta_bas_test.md#ta-bas-010).
  - Any Leaf Entity that fails must be noted in the report, together with the reason.
- **References**: Section 6.1.4, 6.2 and 10.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="subordinate-listing-endpoint-3.4"></a>
### 3.4. Subordinate Listing Endpoint

<a name="ta-os-039"></a>
#### TA-OS-039: Listing the Immediate Subordinates

- **Test data**: FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the TA lists exactly the Entities it issues Subordinate Statements about.
- **Instructions**: Send a GET request to the `federation_list_endpoint` without parameters.
- **Expected result**:
  - The response MUST have HTTP status code 200 and the content type `application/json`, and MUST be a JSON array of Entity Identifiers.
  - The array MUST contain all expected Immediate Subordinates (see [1.2](#test-setup)). Additional Entities must be noted in the report.
  - For every listed Entity, a Subordinate Statement MUST be available at the fetch endpoint.
- **References**: Section 8.2, 8.2.1 and 8.2.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-040"></a>
#### TA-OS-040: Verifying that no Federation Protocol Entity is chained directly under the Trust Anchor

- **Test data**: The Entity Configurations of FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that Federation Protocol Entities are registered under an Intermediate and not directly under the TA.
- **Instructions**: For each Entity in the list from [TA-OS-039](#ta-os-039), retrieve its Entity Configuration and inspect the Entity Types in its `metadata` claim.
- **Expected result**: Every Immediate Subordinate SHOULD hold only the `federation_entity` Entity Type. Any Federation Protocol Entity directly under the TA must be noted in the report.
- **References**: Section 2.2 and 2.6.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-041"></a>
#### TA-OS-041: Listing with the entity_type parameter

- **Test data**: FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the TA either filters on Entity Type or reports that it does not support the filter.
- **Instructions**: Send GET requests to the list endpoint with `entity_type=federation_entity`, with `entity_type=oauth_client`, and with both parameters together.
- **Expected result**: Two outcomes are accepted:<br/>1. The TA filters the result. With `federation_entity`, all Intermediates are listed. With `oauth_client` alone, the list is expected to be empty (see [TA-OS-040](#ta-os-040)). With both, the union is listed.<br/>2. The TA responds with HTTP status code 400, the content type `application/json` and the error code `unsupported_parameter`.<br/>The test fails if the TA returns an unfiltered list. The outcome must be noted in the report.
- **References**: Section 8.2.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-042"></a>
#### TA-OS-042: Listing with the intermediate parameter

- **Test data**: FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the TA either filters on whether its Subordinates are Intermediates or reports that it does not support the filter.
- **Instructions**: Send a GET request to the list endpoint with `intermediate=true`.
- **Expected result**: Either all Intermediates are listed (in practice the same list as in [TA-OS-039](#ta-os-039)), or the TA responds with HTTP status code 400 and the error code `unsupported_parameter`. The outcome must be noted in the report.
- **References**: Section 8.2.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="client-authentication-and-error-handling-3.5"></a>
### 3.5. Client Authentication and Error Handling

<a name="ta-os-043"></a>
#### TA-OS-043: Authenticated requests

- **Applies to**: Only if the TA declares `private_key_jwt` for any endpoint
- **Test data**: REG-C1, whose Federation Entity Keys sign the client assertion.
- **Purpose**: Assert that the TA accepts correctly authenticated requests, and rejects authentication that is not bound to it or not signed with a Federation Entity Key.
- **Instructions**: Using a test Entity registered in the federation, send POST requests to an endpoint that requires `private_key_jwt`:<br/>1. With a client assertion signed with the test Entity's Federation Entity Key and `aud` set to the TA Entity Identifier.<br/>2. With `aud` set to the endpoint URL instead.<br/>3. With a client assertion signed with a key that is not a Federation Entity Key of the test Entity.<br/>4. Without client authentication, using GET.
- **Expected result**:
  - Request 1 MUST succeed.
  - Requests 2, 3 and 4 MUST be rejected. The error code SHOULD be `invalid_client` with HTTP status code 401. Any other code should be noted in the report.
- **References**: Section 8.8, 8.8.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="key-management-and-availability"></a>
### 3.6. Key Management and Availability

The test cases in this section are carried out over time, or in coordination with the Federation Operator, and are described at an overall level.

<a name="ta-os-044"></a>
#### TA-OS-044: Federation key rollover

- **Test data**: A planned key rollover of FED-TA, coordinated with the Federation Operator, and REG-C1, REG-AS1 and REG-PR1.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The key rollover periods, including how long an old key is kept after a new key is put into use.
- **Purpose**: Assert that the TA can replace its Federation Entity Keys without disrupting federation participants.
- **Instructions**: In coordination with the Federation Operator, follow a planned key rollover of the TA in the Sandbox. Retrieve the Entity Configuration, the out-of-band published keys and a Subordinate Statement at regular intervals during the rollover.
- **Expected result**:
  - The new key MUST be published in `jwks`, and out-of-band, before it is used for signing. The time between publication and first use MUST be at least as long as the validity period of the Entity Configuration (`exp` minus `iat`).
  - During that time, the Entity Configuration and the Subordinate Statements MUST still be signed with the old key.
  - After the switch, the old key is removed after a period stated by the federation rules. If a historical keys endpoint is published, the old key is expected to appear there.
  - Trust Chains for registered Entities MUST validate throughout the rollover (see [TA-OS-038](#ta-os-038)).
- **References**: Section 11.1, 11.2 and 8.7 of \[[OpenID.Federation](#openid-federation)\] and Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-os-045"></a>
#### TA-OS-045: Removing an Immediate Subordinate

- **Test data**: FED-IMT, which the Federation Operator adds and removes.
- **Purpose**: Assert that an Intermediate that is removed from the federation stops being reachable through the TA.
- **Instructions**: In coordination with the Federation Operator, have a test Intermediate added under the TA and then removed. After removal, send a fetch request and a list request for it.
- **Expected result**:
  - After removal, the fetch endpoint MUST NOT return a Subordinate Statement about the Intermediate, and the list endpoint MUST NOT list it.
  - The time until the last issued Subordinate Statement expires should be noted in the report, since participants may use it until then.
- **References**: Section 10.4 and 11.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-os-046"></a>
#### TA-OS-046: Key change at an Immediate Subordinate

- **Test data**: FED-IMT, whose operator carries out a key rollover.
- **Purpose**: Assert that the TA issues an updated Subordinate Statement when an Intermediate replaces its Federation Entity Keys, before the Intermediate starts signing with the new key.
- **Instructions**: In coordination with the Federation Operator and the operator of a test Intermediate, follow a key rollover at the Intermediate. Fetch the Subordinate Statement about it at regular intervals.
- **Expected result**: The new key MUST appear in the Subordinate Statement before the Intermediate's Entity Configuration is signed with it, so that Trust Chains through the Intermediate validate throughout the rollover.
- **References**: Section 3.1.1, 4 and 11.1 of \[[OpenID.Federation](#openid-federation)\]
