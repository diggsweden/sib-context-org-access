# Testing of the BAS Federation Resolver – OIDF Sweden Conformance

This document contains a set of test cases that are applied to the Federation Resolver of Federationskontext BAS (BAS). A Federation Resolver is a Trust Anchor or an Intermediate Entity that provides a `federation_resolve_endpoint`. The Swedish profile requires the Trust Anchor to ensure that at least one resolver is available, and recommends that the Trust Anchor provides it itself. Since peers in BAS obtain identifiers, keys, authentication methods and endpoints from Resolved Metadata, the resolver is central to how a party verifies the system identity and organization of another Entity.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

This document holds the **OIDF Sweden conformance tests**. They test the Federation Resolver against OpenID Federation \[[OpenID.Federation](#openid-federation)\] and the Swedish OpenID Federation profile \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], with the extensions the profile references. They contain no BAS-specific requirement, and can be reused for any federation based on the Swedish profile. The requirements that BAS adds are tested in the BAS conformance tests, [resolver_bas_test.md](resolver_bas_test.md). Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md).

The test cases are grouped by the test data they need:

- **[Section 2](#tests-without-external-test-data)** holds tests that can be carried out against the resolver alone, using only what it publishes itself and requests that the tester constructs. They need no test data from superior or subordinate Entities, and can be run as soon as the resolver is deployed.
- **[Section 3](#tests-requiring-a-chain-of-test-data)** holds tests that need a chain of test data, such as a Trust Anchor, registered Entities, test Entities or coordination with other operators. Each test case states the data it needs under "Test data".

Note: Where the specifications do not state a concrete value or procedure, or where a value depends on the federation environment (Entity Identifiers, test Entities, validity periods, test tooling), the test cases are given as an overall description. The tester completes such details from the federation rules and the environment before the test is carried out.

## Table of Contents

1. [**References**](#references)

    1.1. [**Normative Specifications**](#normative-specifications)

    1.2. [**Test Setup**](#test-setup)

    1.3. [**Test Entities**](#test-entities)

2. [**Tests Without External Test Data**](#tests-without-external-test-data)

    2.1. [**Verification of the Resolver's Metadata and Trust**](#verification-of-the-resolvers-metadata-and-trust)

    [RES-OS-001](#res-os-001) Verifying the resolve endpoint

    2.2. [**Invalid Requests**](#invalid-requests)

    [RES-OS-002](#res-os-002) Request without sub

    [RES-OS-003](#res-os-003) Request without trust_anchor

    [RES-OS-004](#res-os-004) Unknown Trust Anchor

    [RES-OS-005](#res-os-005) Subject that does not exist

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Verification of the Resolver's Metadata and Trust**](#verification-of-the-resolvers-metadata-and-trust-3.1)

    [RES-OS-006](#res-os-006) Verifying that the resolver is trusted by the Trust Anchor

    3.2. [**Resolve Response**](#resolve-response)

    [RES-OS-007](#res-os-007) Basic resolve request

    [RES-OS-008](#res-os-008) Verifying the Trust Chain in the response

    [RES-OS-009](#res-os-009) Verifying the Resolved Metadata

    [RES-OS-010](#res-os-010) Verifying the validity of the resolve response

    [RES-OS-011](#res-os-011) Verifying the Trust Marks in the response

    [RES-OS-012](#res-os-012) Trust Marks obtained by the resolver

    [RES-OS-013](#res-os-013) Verifying aud and the trust_chain header parameter

    3.3. [**Request Parameters**](#request-parameters)

    [RES-OS-014](#res-os-014) Resolving one Entity Type

    [RES-OS-015](#res-os-015) Resolving several Entity Types

    [RES-OS-016](#res-os-016) Resolving an Entity Type the subject does not have

    [RES-OS-017](#res-os-017) Several trust_anchor parameters

    [RES-OS-018](#res-os-018) Unknown request parameter

    3.4. [**Other Subjects**](#other-subjects)

    [RES-OS-019](#res-os-019) Resolving an Entity with a hosted Entity Configuration

    [RES-OS-020](#res-os-020) Resolving an Intermediate

    [RES-OS-021](#res-os-021) Resolving the Trust Anchor

    3.5. [**Invalid Trust Chains**](#invalid-trust-chains)

    [RES-OS-022](#res-os-022) Entity that is not registered

    [RES-OS-023](#res-os-023) Expired Entity Configuration

    [RES-OS-024](#res-os-024) Entity Configuration signed with a key that is not bound by the Superior

    [RES-OS-025](#res-os-025) Metadata that does not comply with the policy

    [RES-OS-026](#res-os-026) Unknown critical claim

    [RES-OS-027](#res-os-027) Unknown critical policy operator

    [RES-OS-028](#res-os-028) Constraint violation

    [RES-OS-029](#res-os-029) Registration policy constraint violation

    3.6. [**Invalid Trust Marks**](#invalid-trust-marks)

    [RES-OS-030](#res-os-030) Expired Trust Mark

    [RES-OS-031](#res-os-031) Revoked Trust Mark

    [RES-OS-032](#res-os-032) Trust Mark from an issuer that is not accredited

    3.7. [**Format of Error Responses**](#format-of-error-responses)

    [RES-OS-033](#res-os-033) Verifying error responses

    3.8. [**Freshness**](#freshness)

    [RES-OS-034](#res-os-034) Propagation of changed metadata

    [RES-OS-035](#res-os-035) Removed Entity

    [RES-OS-036](#res-os-036) Newly registered Entity

    [RES-OS-037](#res-os-037) Federation key rollover at the resolver

    3.9. [**Robustness and Security**](#robustness-and-security)

    [RES-OS-038](#res-os-038) Large number of authority_hints and loops

    [RES-OS-039](#res-os-039) Unauthenticated requests for Entities not previously resolved

    [RES-OS-040](#res-os-040) Client authentication at the resolve endpoint


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

<a name="bas-rules"></a>
**\[BAS.Rules\]**
> The Swedish Agency for Digital Government (Digg), federation rules for Federationskontext BAS, in preparation.

<a name="test-setup"></a>
### 1.2. Test Setup

Each test case obtains the data it verifies itself, using the common procedures in [procedures.md](procedures.md), such as fetching an Entity Configuration ([P-EC](procedures.md#p-ec)) or building a Trust Chain ([P-CHAIN](procedures.md#p-chain)). No test case depends on the outcome of another. If a procedure cannot be completed, the test case is reported as *Inconclusive*, with the reason.

Before the tests are carried out, the tester collects the following information about the resolver under test:

| Item | Description |
| :--- | :--- |
| **Resolver Entity Identifier** | The Entity Identifier of the Entity that provides the resolve endpoint. The Swedish profile recommends that this is the Trust Anchor itself. |
| **Resolve endpoint** | The `federation_resolve_endpoint` from the resolver's metadata. |
| **Trust Anchor** | The Entity Identifier and the out-of-band distributed keys of the Trust Anchor the resolver resolves for. |
| **Request defaults** | Unless stated otherwise, resolve requests are sent using GET without client authentication, with `trust_anchor` set to the Trust Anchor Entity Identifier. |
| **Reference implementation** | An independent OpenID Federation implementation, used to build Trust Chains and compute Resolved Metadata that the resolver's responses are compared with. |

Test cases that only apply under a condition state this under "Applies to". The BAS specifications do not define any Trust Marks, so the test cases for Trust Marks apply only if the BAS federation rules introduce them.

Note: When the resolver is provided by the Trust Anchor, its Entity Configuration is tested according to [Testing of the BAS Trust Anchor](ta_overview.md). When it is provided by an Intermediate, its Entity Configuration is tested according to [Testing of BAS Federation Registration Entities](fre_overview.md). This document covers the resolver role.

<a name="test-entities"></a>
### 1.3. Test Entities

The testing requires a set of test Entities in the BAS Sandbox, that each represent a case the resolver must handle. The Entity Identifiers are assigned when the test Entities are set up. The valid Entities TE1 to TE4 are registered under a Federation Registration Entity. The test Entities TE5 to TE18, most of which break a rule on purpose, are placed under FED-TI, a test Intermediate that the tester operates, so that no Federation Registration Operator has to publish incorrect data. See [test_data.md](test_data.md#2-federation-entities).

| ID | Description |
| :--- | :--- |
| **TE1** | A valid Leaf Entity registered under an Intermediate. In BAS an Authorization Server, see [BAS Conformance](resolver_bas_test.md#test-entities). If Trust Marks are used, it holds at least one valid Trust Mark from an accredited Trust Mark Issuer. |
| **TE2** | A valid Leaf Entity of another Entity Type. In BAS a Client, see [BAS Conformance](resolver_bas_test.md#test-entities). |
| **TE3** | A valid Entity with two protocol Entity Types, `oauth_client` and `oauth_resource`. |
| **TE4** | A valid Client or Protected Resource whose Entity Configuration is hosted by its Intermediate and found through `ec_location`. Only if hosting is supported. |
| **TE5** | An Entity that publishes a valid Entity Configuration, with `authority_hints` pointing at an Intermediate, but that is not registered. |
| **TE6** | A registered Entity whose Entity Configuration has expired (`exp` in the past). |
| **TE7** | A registered Entity whose Entity Configuration is signed with a key that is not in the Subordinate Statement about it. |
| **TE8** | A registered Entity whose metadata fails the Trust Anchor metadata policy, for example by lacking a parameter marked `essential`. The BAS variants are described in [BAS Conformance](resolver_bas_test.md#test-entities). |
| **TE9** | A registered Entity holding an expired Trust Mark. Only if Trust Marks are used. |
| **TE10** | A registered Entity holding a revoked Trust Mark (the Trust Mark Status endpoint returns `revoked`). Only if Trust Marks are used. |
| **TE11** | A registered Entity holding a Trust Mark from an issuer that is not listed for that type in the Trust Anchor's `trust_mark_issuers`. Only if Trust Marks are used. |
| **TE12** | A registered Entity whose Entity Configuration lists an unknown claim in `crit`. |
| **TE13** | A registered Entity whose Subordinate Statement lists an unknown operator in `metadata_policy_crit` and uses it. |
| **TE14** | A registered Entity whose Trust Chain breaks a constraint (`max_path_length`, `naming_constraints` or `allowed_entity_types`). |
| **TE15** | A registered Entity whose Subordinate Statement does not satisfy the Trust Anchor's `registration_policy` constraint. Only if such a constraint is used. In BAS, the policy URI for verification of organisational affiliation is missing. |
| **TE16** | An Entity whose `authority_hints` holds a large number of non-existent Intermediates, and an Entity whose `authority_hints` form a loop. |
| **TE18** | A valid Entity that the tester adds under FED-TI during the test. |

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the resolver alone. They use what the resolver publishes itself, and requests that the tester constructs.

<a name="verification-of-the-resolvers-metadata-and-trust"></a>
### 2.1. Verification of the Resolver's Metadata and Trust

<a name="res-os-001"></a>
#### RES-OS-001: Verifying the resolve endpoint

- **Purpose**: Assert that the resolver publishes its resolve endpoint where participants find it.
- **Instructions**: Fetch the Entity Configuration of the resolver from `<Resolver Entity Identifier>/.well-known/openid-federation` ([P-EC](procedures.md#p-ec)) and inspect the `federation_entity` metadata.
- **Expected result**:
  - `federation_resolve_endpoint` MUST be present in the Entity Configuration, under `federation_entity`.
  - The URL MUST use the `https` scheme and MUST NOT contain a fragment component.
- **References**: Section 5.1.1 and 8.3 of \[[OpenID.Federation](#openid-federation)\] and Section 2.3 and 4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="invalid-requests"></a>
### 2.2. Invalid Requests

<a name="res-os-002"></a>
#### RES-OS-002: Request without sub

- **Purpose**: Assert that the resolver rejects a request that lacks the required `sub` parameter.
- **Instructions**: Send a resolve request with only `trust_anchor` ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No resolve response MUST be returned. `error` SHOULD be `invalid_request` with HTTP status code 400. Any other code should be noted in the report.
- **References**: Section 8.3.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-003"></a>
#### RES-OS-003: Request without trust_anchor

- **Purpose**: Assert that the resolver rejects a request that lacks the required `trust_anchor` parameter, rather than choosing a Trust Anchor itself.
- **Instructions**: Send a resolve request with `sub` set to any Entity Identifier and no `trust_anchor` ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No resolve response MUST be returned. `error` SHOULD be `invalid_request` with HTTP status code 400. Any other code should be noted in the report.
- **References**: Section 8.3.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-004"></a>
#### RES-OS-004: Unknown Trust Anchor

- **Purpose**: Assert that the resolver does not resolve for a Trust Anchor it is not configured for.
- **Instructions**: Send a resolve request with `sub` set to any Entity Identifier and `trust_anchor` set to an unknown Entity Identifier ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No resolve response MUST be returned. `error` SHOULD be `invalid_trust_anchor` with HTTP status code 404. Any other code should be noted in the report.
- **References**: Section 8.3.1 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-005"></a>
#### RES-OS-005: Subject that does not exist

- **Purpose**: Assert that the resolver responds with an error when the subject's Entity Configuration cannot be retrieved.
- **Instructions**: Send a resolve request with `sub` set to an Entity Identifier whose host does not exist, for example `https://does-not-exist.example.se` ([P-ERROR](procedures.md#p-error)).
- **Expected result**: No resolve response MUST be returned. `error` is expected to be `not_found` or `invalid_subject` with HTTP status code 404. The code must be noted in the report.
- **References**: Section 8.3 and 8.9 of \[[OpenID.Federation](#openid-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="verification-of-the-resolvers-metadata-and-trust-3.1"></a>
### 3.1. Verification of the Resolver's Metadata and Trust

<a name="res-os-006"></a>
#### RES-OS-006: Verifying that the resolver is trusted by the Trust Anchor

- **Test data**: FED-TA and its out-of-band keys, or the resolver's Trust Chain to FED-TA.
- **Purpose**: Assert that participants can establish trust in the resolver's keys.
- **Instructions**: If the resolver is the Trust Anchor, fetch its Entity Configuration ([P-EC](procedures.md#p-ec)) and compare the keys in it with the out-of-band distributed Trust Anchor keys. Otherwise, build and validate the resolver's Trust Chain to the Trust Anchor using the reference implementation ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**:
  - If the resolver is the Trust Anchor, the key that signs its Entity Configuration MUST be among the out-of-band distributed keys.
  - Otherwise, the resolver's Trust Chain MUST validate. This must be noted in the report, since participants that rely only on the resolver need to configure trust in two Federation Entity Keys.
- **References**: Section 8.3.3 and 17.3 of \[[OpenID.Federation](#openid-federation)\] and Section 2.3 and 4.2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="resolve-response"></a>
### 3.2. Resolve Response

Unless stated otherwise, requests are sent using GET without client authentication, with `trust_anchor` set to the Trust Anchor Entity Identifier.

<a name="res-os-007"></a>
#### RES-OS-007: Basic resolve request

- **Test data**: TE1.
- **Purpose**: Assert that the resolver returns a correctly formed and signed resolve response for a valid Entity.
- **Instructions**: Send a GET request to the resolve endpoint with `sub` set to TE1 and `trust_anchor` set to the Trust Anchor ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**:
  - The response MUST have HTTP status code 200 and the content type `application/resolve-response+jwt`.
  - `typ` MUST be `resolve-response+jwt`, `alg` MUST NOT be `none`, and `kid` MUST be present. The signature MUST validate with a Federation Entity Key of the resolver identified by `kid`.
  - `iss` MUST be the Resolver Entity Identifier, and `sub` MUST be TE1.
  - `iat`, `exp`, `metadata` and `trust_chain` MUST be present.
  - The `alg` SHOULD be one of `RS256`, `RS384`, `RS512`, `ES256`, `ES384` or `ES512`. Any other algorithm should be noted in the report.
- **References**: Section 8.3, 8.3.1 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-008"></a>
#### RES-OS-008: Verifying the Trust Chain in the response

- **Test data**: TE1, and FED-TA with its out-of-band keys.
- **Purpose**: Assert that the response contains a complete and valid Trust Chain from the subject to the requested Trust Anchor.
- **Instructions**: Send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)). Decode the `trust_chain` claim of the response and validate it with the reference implementation.
- **Expected result**:
  - `trust_chain` MUST be an array of Entity Statements, starting with TE1's Entity Configuration and ending with the Trust Anchor (its Subordinate Statement about the top-most Intermediate, followed by its Entity Configuration if included).
  - The Trust Chain MUST validate according to Section 10.2 of \[[OpenID.Federation](#openid-federation)\] against the out-of-band distributed Trust Anchor keys.
- **References**: Section 4, 8.3.2 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-009"></a>
#### RES-OS-009: Verifying the Resolved Metadata

- **Test data**: TE1 and TE2, and their Trust Chains.
- **Purpose**: Assert that the resolver applies the metadata, metadata policies and constraints of the Trust Chain correctly.
- **Instructions**: Send a resolve request for TE1 and for TE2 ([P-RESOLVE](procedures.md#p-resolve)). Build the Trust Chains for TE1 and TE2 and resolve their metadata with the reference implementation ([P-CHAIN](procedures.md#p-chain)). Compare the Resolved Metadata with the `metadata` claim of the resolve responses.
- **Expected result**:
  - The `metadata` claim MUST be equal to the computed Resolved Metadata for each Entity Type.
  - Values in the `metadata` claim of the Subordinate Statement about the subject MUST be applied before the metadata policy, and MUST override the values the Entity declares.
  - The values that BAS requires in the Resolved Metadata are tested in the BAS conformance tests, see [RES-BAS-002](resolver_bas_test.md#res-bas-002), [RES-BAS-003](resolver_bas_test.md#res-bas-003) and [RES-BAS-004](resolver_bas_test.md#res-bas-004).
  - No metadata value MUST be `null`.
- **References**: Section 3.1.1, 6.1.4, 6.2 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-010"></a>
#### RES-OS-010: Verifying the validity of the resolve response

- **Test data**: TE1 and its Trust Chain.
- **Purpose**: Assert that the resolve response does not claim to be valid longer than the Trust Chain and the Trust Marks it is derived from.
- **Instructions**: Send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)) and note the time of the request. For the response, compute the minimum `exp` of the Entity Statements in the Trust Chain and of the Trust Marks in the response. Compare with `exp` of the response.
- **Expected result**:
  - `iat` MUST NOT be later, and `exp` MUST be later, than the time of the request. A clock skew of 10 seconds is allowed.
  - `exp` MUST be equal to the computed minimum.
- **References**: Section 8.3.2 and 10.4 of \[[OpenID.Federation](#openid-federation)\] and Section 4.1 and 4.2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-011"></a>
#### RES-OS-011: Verifying the Trust Marks in the response

- **Applies to**: Only if Trust Marks are used
- **Test data**: TE1 with a valid Trust Mark, FED-TMI, and the `trust_mark_issuers` claim of FED-TA.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that the resolver only includes Trust Marks that it has verified, and that are issued by Trust Mark Issuers trusted by the Trust Anchor.
- **Instructions**: Send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)) and inspect the `trust_marks` claim of the response. Validate each Trust Mark according to Section 7.3 of \[[OpenID.Federation](#openid-federation)\], and compare with the `trust_mark_issuers` in the Trust Anchor's Entity Configuration ([P-EC](procedures.md#p-ec)).
- **Expected result**:
  - Each element MUST contain `trust_mark_type` and `trust_mark`, with matching types.
  - Each Trust Mark MUST be valid, MUST have `sub` equal to TE1, and MUST be issued by an issuer listed for its type in the Trust Anchor's `trust_mark_issuers`.
  - All valid Trust Marks held by TE1 are expected to be included. A missing Trust Mark must be noted in the report.
- **References**: Section 7.3, 8.3 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 4.1, 5.1 and 5.3 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-012"></a>
#### RES-OS-012: Trust Marks obtained by the resolver

- **Applies to**: Only if Trust Marks are used in BAS
- **Test data**: TE1 and TE2, and a Trust Mark granted to TE2 by FED-TMI.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Find out whether the resolver obtains Trust Marks that are not present in the Entity Configuration, or renews short-lived ones, which the Swedish profile allows.
- **Instructions**: Resolve TE2 ([P-RESOLVE](procedures.md#p-resolve)), which holds no Trust Marks in its Entity Configuration but for which an accredited Trust Mark Issuer has granted a Trust Mark, if such a setup is available. Also fetch TE1's Entity Configuration ([P-EC](procedures.md#p-ec)) and send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)), and compare `exp` of a Trust Mark in the Entity Configuration with `exp` of the same Trust Mark type in the resolve response.
- **Expected result**:
  - Both obtaining and not obtaining Trust Marks are accepted. The outcome must be noted in the report.
  - Any Trust Mark the resolver includes MUST be valid as in [RES-OS-011](#res-os-011).
- **References**: Section 4.1 and 5.3 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 8.6 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-013"></a>
#### RES-OS-013: Verifying aud and the trust_chain header parameter

- **Test data**: TE1.
- **Purpose**: Assert that the optional parts of the resolve response are correct.
- **Instructions**: Send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)) and inspect the claims and header of the response.
- **Expected result**:
  - Since the request is not authenticated, `aud` SHOULD NOT be present.
  - If the `trust_chain` header parameter is present, it MUST be a valid Trust Chain from the resolver to the requested Trust Anchor. Its presence should be noted in the report.
- **References**: Section 4.3 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="request-parameters"></a>
### 3.3. Request Parameters

<a name="res-os-014"></a>
#### RES-OS-014: Resolving one Entity Type

- **Test data**: TE3.
- **Purpose**: Assert that the resolver only returns the requested Entity Type.
- **Instructions**: Send a resolve request for TE3 with `entity_type` set to one of its two protocol Entity Types ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The `metadata` claim MUST contain the requested Entity Type and MUST NOT contain the other.
- **References**: Section 8.3.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-015"></a>
#### RES-OS-015: Resolving several Entity Types

- **Test data**: TE3.
- **Purpose**: Assert that the resolver handles repeated `entity_type` parameters, and returns all Entity Types when none is given.
- **Instructions**: Send a resolve request for TE3 with both its protocol Entity Types as two `entity_type` parameters, and then without `entity_type` ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: In both cases, the `metadata` claim MUST contain both protocol Entity Types.
- **References**: Section 8.3.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-016"></a>
#### RES-OS-016: Resolving an Entity Type the subject does not have

- **Test data**: TE1.
- **Purpose**: Find out how the resolver handles a request for an Entity Type the subject does not have.
- **Instructions**: Send a resolve request for TE1 with `entity_type` set to an Entity Type that TE1 does not have, for example `oauth_resource` for an Authorization Server ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: \[[OpenID.Federation](#openid-federation)\] does not state the outcome. A successful response without metadata for that type, and an error response, are both accepted. The resolver MUST NOT return metadata for the type. The outcome must be noted in the report.
- **References**: Section 8.3.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-017"></a>
#### RES-OS-017: Several trust_anchor parameters

- **Test data**: TE1.
- **Purpose**: Assert that the resolver can resolve when the caller gives several Trust Anchors, of which only one is known.
- **Instructions**: Send a resolve request for TE1 with two `trust_anchor` parameters: an unknown Trust Anchor (for example `https://unknown-ta.example.se`) and the Trust Anchor ([P-ERROR](procedures.md#p-error)).
- **Expected result**: The resolver MAY return a successful response using any of the given values. A successful response MUST hold a Trust Chain ending at the known Trust Anchor. An error response must be noted in the report.
- **References**: Section 8.3.1 of \[[OpenID.Federation](#openid-federation)\] and Section 4.2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-018"></a>
#### RES-OS-018: Unknown request parameter

- **Test data**: TE1.
- **Purpose**: Assert that the resolver ignores request parameters it does not understand.
- **Instructions**: Send a resolve request for TE1 ([P-RESOLVE](procedures.md#p-resolve)). Repeat the request with an additional parameter, for example `foo=bar`.
- **Expected result**: The response to the request with the additional parameter MUST be equivalent to the response to the request without it.
- **References**: Section 8 of \[[OpenID.Federation](#openid-federation)\]

<a name="other-subjects"></a>
### 3.4. Other Subjects

<a name="res-os-019"></a>
#### RES-OS-019: Resolving an Entity with a hosted Entity Configuration

- **Applies to**: Only if Entity Configuration hosting is supported in the federation
- **Test data**: TE4.
- **Purpose**: Assert that the resolver can resolve an Entity whose Entity Configuration is not published at the well-known location.
- **Instructions**: Send a resolve request for TE4 ([P-RESOLVE](procedures.md#p-resolve)). Build the Trust Chain for TE4 and resolve its metadata with the reference implementation ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**: The resolve request MUST succeed, and the response MUST meet the expected results of [RES-OS-007](#res-os-007) to [RES-OS-010](#res-os-010), with TE4 in place of TE1. The first element of `trust_chain` MUST be the Entity Configuration found at `ec_location`.
- **References**: Section 2.3 and 2.4.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and \[[OIDC.Sweden.Hosting](#oidc-sweden-hosting)\]

<a name="res-os-020"></a>
#### RES-OS-020: Resolving an Intermediate

- **Test data**: FED-FRE1.
- **Purpose**: Assert that the resolver can resolve a Federation Service Entity, such as an Intermediate that registers Entities.
- **Instructions**: Send a resolve request for an Intermediate of the Trust Anchor ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The resolve request is expected to succeed, with `metadata` holding `federation_entity` and a Trust Chain consisting of the Intermediate's Entity Configuration, the Trust Anchor's Subordinate Statement about it and the Trust Anchor's Entity Configuration. Any other outcome must be noted in the report.
- **References**: Section 4, 8.3 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-021"></a>
#### RES-OS-021: Resolving the Trust Anchor

- **Test data**: FED-TA.
- **Purpose**: Find out how the resolver handles a request where the subject is the Trust Anchor itself.
- **Instructions**: Send a resolve request with `sub` and `trust_anchor` both set to the Trust Anchor ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: Both a successful response, with a Trust Chain holding only the Trust Anchor's Entity Configuration, and an error response are accepted. The outcome must be noted in the report.
- **References**: Section 4, 4.1 and 8.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="invalid-trust-chains"></a>
### 3.5. Invalid Trust Chains

For every test case in this section, the resolver MUST NOT return a successful resolve response. The error code is expected to be `invalid_trust_chain` (HTTP status code 400), `invalid_metadata` (400) or `not_found` (404) as stated, and the code must be noted in the report.

<a name="res-os-022"></a>
#### RES-OS-022: Entity that is not registered

- **Test data**: TE5.
- **Purpose**: Assert that the resolver does not accept an Entity that points at an Intermediate without being registered there.
- **Instructions**: Send a resolve request for TE5 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `not_found` or `invalid_trust_chain` are expected.
- **References**: Section 8.3, 10.1 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-023"></a>
#### RES-OS-023: Expired Entity Configuration

- **Test data**: TE6.
- **Purpose**: Assert that the resolver does not use an expired Entity Statement.
- **Instructions**: Send a resolve request for TE6 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected.
- **References**: Section 3.2 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-024"></a>
#### RES-OS-024: Entity Configuration signed with a key that is not bound by the Superior

- **Test data**: TE7.
- **Purpose**: Assert that the resolver verifies that the subject's Entity Configuration is signed with a key from the Subordinate Statement about it.
- **Instructions**: Send a resolve request for TE7 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected.
- **References**: Section 4 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-025"></a>
#### RES-OS-025: Metadata that does not comply with the policy

- **Test data**: TE8.
- **Purpose**: Assert that the resolver applies the checks of the Trust Anchor metadata policy, and does not return metadata that breaks it.
- **Instructions**: Send a resolve request for TE8 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_metadata` or `invalid_trust_chain` are expected.
- **References**: Section 6.1.3.1.6, 6.1.3.1.7 and 6.1.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-026"></a>
#### RES-OS-026: Unknown critical claim

- **Test data**: TE12.
- **Purpose**: Assert that the resolver rejects an Entity Statement with a critical claim it does not understand.
- **Instructions**: Send a resolve request for TE12 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected.
- **References**: Section 3.2 and 13.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-027"></a>
#### RES-OS-027: Unknown critical policy operator

- **Test data**: TE13.
- **Purpose**: Assert that the resolver rejects a Trust Chain with a critical policy operator it does not understand.
- **Instructions**: Send a resolve request for TE13 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_metadata` or `invalid_trust_chain` are expected.
- **References**: Section 3.1.3, 6.1.3.2 and 6.1.4.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-028"></a>
#### RES-OS-028: Constraint violation

- **Test data**: TE14.
- **Purpose**: Assert that the resolver enforces the constraints in the Trust Chain.
- **Instructions**: Send a resolve request for TE14 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected.
- **References**: Section 6.2 and 10.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-029"></a>
#### RES-OS-029: Registration policy constraint violation

- **Applies to**: Only if the Trust Anchor sets a `registration_policy` constraint
- **Test data**: TE15.
- **Purpose**: Assert that the resolver enforces registration policy constraints set in the Trust Chain.
- **Instructions**: Send a resolve request for TE15 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected. If the resolver does not support the extension and returns a successful response, this must be noted in the report.
- **References**: Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\], Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="invalid-trust-marks"></a>
### 3.6. Invalid Trust Marks

The test cases in this section apply only if Trust Marks are used. For every test case, the resolve request is expected to succeed, since the Trust Chain is valid, but the invalid Trust Mark MUST NOT be included.

<a name="res-os-030"></a>
#### RES-OS-030: Expired Trust Mark

- **Applies to**: Only if Trust Marks are used
- **Test data**: TE9.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that the resolver does not include an expired Trust Mark.
- **Instructions**: Send a resolve request for TE9 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The expired Trust Mark MUST NOT be in `trust_marks`. If the resolver includes a newly obtained instance of the same type instead (see [RES-OS-012](#res-os-012)), it MUST be valid, and this should be noted in the report.
- **References**: Section 7.3, 8.3 and 8.3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 4.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-031"></a>
#### RES-OS-031: Revoked Trust Mark

- **Applies to**: Only if Trust Marks are used
- **Test data**: TE10.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that the resolver verifies that Trust Marks are active, and does not include a revoked Trust Mark.
- **Instructions**: Send a resolve request for TE10 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The revoked Trust Mark MUST NOT be in `trust_marks`.
- **References**: Section 7.3, 8.3 and 8.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-032"></a>
#### RES-OS-032: Trust Mark from an issuer that is not accredited

- **Applies to**: Only if Trust Marks are used
- **Test data**: TE11.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Whether Trust Marks are used in BAS, and if so, which Trust Mark types and issuers are recognized.
- **Purpose**: Assert that the resolver only includes Trust Marks from issuers the Trust Anchor trusts for the Trust Mark type.
- **Instructions**: Send a resolve request for TE11 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The Trust Mark MUST NOT be in `trust_marks`.
- **References**: Section 3.1.2, 8.3.2 and 17.5 of \[[OpenID.Federation](#openid-federation)\] and Section 5.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="format-of-error-responses"></a>
### 3.7. Format of Error Responses

<a name="res-os-033"></a>
#### RES-OS-033: Verifying error responses

- **Test data**: The test Entities used by the test cases for invalid requests and invalid Trust Chains.
- **Purpose**: Assert that the resolver's error responses can be interpreted by participants.
- **Instructions**: Send each of the invalid requests described in Section [2.2](#invalid-requests) and [3.5](#invalid-trust-chains) ([P-ERROR](procedures.md#p-error)), and review the error responses.
- **Expected result**: Every error response SHOULD have the content type `application/json` and MUST contain `error` and `error_description`. The HTTP status code SHOULD match the error code.
- **References**: Section 8.9 and 18.2 of \[[OpenID.Federation](#openid-federation)\]

<a name="freshness"></a>
### 3.8. Freshness

The test cases in this section are carried out over time, or in coordination with the Federation Operator, and are described at an overall level.

<a name="res-os-034"></a>
#### RES-OS-034: Propagation of changed metadata

- **Test data**: TE2, whose Entity Configuration is changed during the test.
- **Purpose**: Assert that the resolver does not serve outdated metadata longer than the validity of what it has already served.
- **Instructions**: Send a resolve request for TE2 ([P-RESOLVE](procedures.md#p-resolve)) and note `exp` of the response. Change a parameter in TE2's Entity Configuration, for example `contacts`, and publish a new Entity Configuration. Resolve TE2 repeatedly.
- **Expected result**: The changed value MUST be returned no later than `exp` of the first response. The time until the change is visible must be noted in the report.
- **References**: Section 10.4 and 11 of \[[OpenID.Federation](#openid-federation)\] and Section 2.4.1 and 4.2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="res-os-035"></a>
#### RES-OS-035: Removed Entity

- **Test data**: TE2, which is removed by its Intermediate during the test.
- **Purpose**: Assert that the resolver stops resolving an Entity that has been removed from the federation.
- **Instructions**: Send a resolve request for TE2 ([P-RESOLVE](procedures.md#p-resolve)) and note `exp`. Have TE2 removed by its Federation Registration Entity. Resolve TE2 repeatedly.
- **Expected result**: The resolver MUST NOT return a successful response after `exp` of the last successful response. The time until it stops must be noted in the report.
- **References**: Section 10.4 and 11.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-036"></a>
#### RES-OS-036: Newly registered Entity

- **Test data**: TE18, added under FED-TI by the tester.
- **Purpose**: Assert that the resolver finds Entities that have recently been added to the federation.
- **Precondition**: The tester has added TE18 under FED-TI, and noted the time.
- **Instructions**: When TE18 is listed by FED-TI ([P-LIST](procedures.md#p-list)), send resolve requests for it repeatedly ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The resolve request MUST succeed within a reasonable time. The time until it succeeds must be noted in the report, since peers rely on Resolved Metadata when they start to interact with a newly registered Entity.
- **References**: Section 8.3 and 10.5 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-037"></a>
#### RES-OS-037: Federation key rollover at the resolver

- **Test data**: A planned key rollover of the resolver, and TE1.
- **Purpose**: Assert that resolve responses remain verifiable when the resolver replaces its Federation Entity Keys.
- **Instructions**: In coordination with the Federation Operator, follow a planned key rollover of the resolver's Federation Entity Keys. Send resolve requests for TE1 at regular intervals ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: Every resolve response MUST be signed with a key present in the resolver's Entity Configuration at the time, and, if the resolver is not the Trust Anchor, in the Subordinate Statement about it.
- **References**: Section 8.3.2 and 11.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="robustness-and-security"></a>
### 3.9. Robustness and Security

<a name="res-os-038"></a>
#### RES-OS-038: Large number of authority_hints and loops

- **Test data**: TE16.
- **Purpose**: Assert that the resolver cannot be used to propagate a large number of HTTP requests, and that it detects loops.
- **Instructions**: Send a resolve request for each of the Entities in TE16 ([P-RESOLVE](procedures.md#p-resolve)). Note the response time, and, if possible, ask the Federation Operator for the number of outgoing requests the resolver made.
- **Expected result**:
  - The resolver MUST NOT return a successful response.
  - The resolver is expected to limit the number of `authority_hints` it inspects, and MUST NOT follow a loop. Unbounded outgoing requests, or a response time that suggests them, must be noted in the report.
- **References**: Section 10.1 and 18.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-039"></a>
#### RES-OS-039: Unauthenticated requests for Entities not previously resolved

- **Test data**: A valid Entity that has not been resolved before.
- **Purpose**: Find out whether the resolver starts Trust Chain resolution for any unauthenticated request, which the specification advises against.
- **Instructions**: If the resolver does not require client authentication, send a resolve request for a valid Entity that has not been resolved before ([P-RESOLVE](procedures.md#p-resolve)), and note whether the response is based on a fresh resolution.
- **Expected result**: Both resolving and serving only cached results are accepted. The behaviour, and any limitations such as rate limiting, must be noted in the report.
- **References**: Section 18.1 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-os-040"></a>
#### RES-OS-040: Client authentication at the resolve endpoint

- **Applies to**: Only if the resolver declares `federation_resolve_endpoint_auth_methods` with `private_key_jwt`
- **Test data**: REG-C1, whose Federation Entity Keys sign the client assertion.
- **Purpose**: Assert that the resolver accepts correctly authenticated requests and binds the response to the requester.
- **Instructions**: Fetch the Entity Configuration of the resolver ([P-EC](procedures.md#p-ec)) and take the `federation_resolve_endpoint`. Using a registered test Entity, send a POST request to it with a client assertion signed with its Federation Entity Key and `aud` set to the Resolver Entity Identifier. Repeat with `aud` set to the resolve endpoint URL, and without client authentication ([P-ERROR](procedures.md#p-error)).
- **Expected result**:
  - The correctly authenticated request MUST succeed, and the response SHOULD contain `aud` holding only the test Entity's Entity Identifier.
  - The other requests MUST be rejected. The error code SHOULD be `invalid_client` with HTTP status code 401.
  - `endpoint_auth_signing_alg_values_supported` MUST contain `RS256`, `RS384`, `RS512`, `ES256`, `ES384` and `ES512`.
- **References**: Section 8.3.2, 8.8 and 8.8.1 of \[[OpenID.Federation](#openid-federation)\] and Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]
