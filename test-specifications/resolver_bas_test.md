# Testing of the BAS Federation Resolver – BAS Conformance

This document contains a set of test cases that are applied to the Federation Resolver of Federationskontext BAS (BAS). A Federation Resolver is a Trust Anchor or an Intermediate Entity that provides a `federation_resolve_endpoint`. The Swedish profile requires the Trust Anchor to ensure that at least one resolver is available, and recommends that the Trust Anchor provides it itself. Since peers in BAS obtain identifiers, keys, authentication methods and endpoints from Resolved Metadata, the resolver is central to how a party verifies the system identity and organization of another Entity.

Version: 0.2.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

This document holds the **BAS conformance tests**. The test cases in this document check that the resolver delivers the Resolved Metadata that BAS requires. Peers in BAS obtain identifiers, keys, authentication methods and endpoints from Resolved Metadata rather than agreeing on them bilaterally, so errors in the resolver directly affect whether a party can verify the system identity and organization of another Entity.

The BAS conformance tests complement the OIDF Sweden conformance tests, [resolver_oidf_sweden_test.md](resolver_oidf_sweden_test.md). Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md).

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

    2.1. [**Transport**](#transport)

    [RES-BAS-001](#res-bas-001) TLS configuration

    2.2. [**Resolver Provided by the Trust Anchor**](#resolver-provided-by-the-trust-anchor)

    [RES-BAS-009](#res-bas-009) Verifying that the resolver is the Trust Anchor

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Values Assigned and Constrained in BAS**](#values-assigned-and-constrained-in-bas)

    [RES-BAS-002](#res-bas-002) Resolved Metadata of an Authorization Server

    [RES-BAS-003](#res-bas-003) Resolved Metadata of a Client

    [RES-BAS-004](#res-bas-004) Organization parameters in Resolved Metadata

    3.2. [**Entities That Break the BAS Requirements**](#entities-that-break-the-bas-requirements)

    [RES-BAS-005](#res-bas-005) Entities that fail the BAS policy

    [RES-BAS-006](#res-bas-006) Entity registered without verification of organisational affiliation

    [RES-BAS-007](#res-bas-007) Entities that break requirements the policy cannot express

    [RES-BAS-010](#res-bas-010) Entity Type not admitted in BAS

    3.3. [**Protocol Keys**](#protocol-keys)

    [RES-BAS-008](#res-bas-008) Propagation of a new protocol key


<a name="references"></a>
## 1. References

<a name="normative-specifications"></a>
### 1.1. Normative Specifications

This section contains the specifications that this document tests compliance against, and the specifications of the OIDF Sweden conformance tests that it refers to.

<a name="openid-federation"></a>
**\[OpenID.Federation\]**
> [Hedberg, R., Jones, M.B. (Ed.), De Marco, G., Solberg, A.Å., Bradley, J. and V. Dzhuvinov, "OpenID Federation 1.1", 5 May 2026](https://openid.net/specs/openid-federation-1_1.html).

<a name="oidc-sweden-federation"></a>
**\[OIDC.Sweden.Federation\]**
> [Lindström, M. and S. Santesson, "Swedish OpenID Federation Deployment and Interoperability Profile 1.0", 16 October 2026](https://www.oidc.se/specifications/swedish-openid-federation-profile.html).

<a name="openid-federation-regpolicy"></a>
**\[OpenID.Federation.RegPolicy\]**
> [Lindström, M. and S. Santesson, "OpenID Federation Registration Policy 1.0 - draft 01", 30 March 2026](https://www.oidc.se/openid-federation-registration-policy/main.html).

<a name="bas-security"></a>
**\[BAS.Security\]**
> The Swedish Agency for Digital Government (Digg), "BAS: Federation Security Requirements 1.0 – draft 01", 23 October 2026.

<a name="bas-metadata"></a>
**\[BAS.Metadata\]**
> The Swedish Agency for Digital Government (Digg), "BAS Federation Metadata Requirements 1.0 – draft 01", 26 October 2026.

<a name="bas-rules"></a>
**\[BAS.Rules\]**
> The Swedish Agency for Digital Government (Digg), "BAS – Federation Rules and Policies 1.0 – draft 01", 27 October 2026.

<a name="bas-structure"></a>
**\[BAS.Structure\]**
> The Swedish Agency for Digital Government (Digg), "BAS: OpenID Federation Structure 1.0 – draft 01", 26 October 2026.

<a name="ena-oauth2"></a>
**\[Ena.OAuth2\]**
> [Lindström, M., "Ena OAuth 2.0 Interoperability Profile 1.0 – draft 01", 16 October 2025](https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html).

<a name="test-setup"></a>
### 1.2. Test Setup

Each test case obtains the data it verifies itself, using the common procedures in [procedures.md](procedures.md), such as fetching an Entity Configuration ([P-EC](procedures.md#p-ec)) or building a Trust Chain ([P-CHAIN](procedures.md#p-chain)). No test case depends on the outcome of another. If a procedure cannot be completed, the test case is reported as *Inconclusive*, with the reason.

Before the tests are carried out, the tester collects the following information about the resolver under test:

| Item | Description |
| :--- | :--- |
| **Resolver Entity Identifier** | The Entity Identifier of the Entity that provides the resolve endpoint. In BAS, the resolver is the Trust Anchor itself (Section 4.1 of \[[BAS.Rules](#bas-rules)\]), whose Entity Identifier is published in Section 5 of \[[BAS.Structure](#bas-structure)\]. |
| **Resolve endpoint** | The `federation_resolve_endpoint` from the resolver's metadata, as published in Section 5 of \[[BAS.Structure](#bas-structure)\]. |
| **Trust Anchor** | The Entity Identifier and the out-of-band distributed keys of the Trust Anchor the resolver resolves for, as published in Section 5 of \[[BAS.Structure](#bas-structure)\]. Until the keys are published there, they are provided by the Federation Operator. |
| **Request defaults** | Unless stated otherwise, resolve requests are sent using GET without client authentication, with `trust_anchor` set to the Trust Anchor Entity Identifier. |
| **Reference implementation** | An independent OpenID Federation implementation, used to build Trust Chains and compute Resolved Metadata that the resolver's responses are compared with. |

Test cases that only apply under a condition state this under "Applies to". Trust Marks are not yet defined in BAS, see Section 5 of \[[BAS.Rules](#bas-rules)\] and Section 4 of \[[BAS.Structure](#bas-structure)\], so the test cases for Trust Marks apply only if a later version of the BAS federation rules introduces them.

Note: When the resolver is provided by the Trust Anchor, its Entity Configuration is tested according to [Testing of the BAS Trust Anchor](ta_overview.md). When it is provided by an Intermediate, its Entity Configuration is tested according to [Testing of BAS Federation Registration Entities](fre_overview.md). This document covers the resolver role.

<a name="test-entities"></a>
### 1.3. Test Entities

The testing requires a set of test Entities in the BAS Sandbox, that each represent a case the resolver must handle. The Entity Identifiers are assigned when the test Entities are set up. The valid Entities TE1 to TE4 are registered under a Federation Registration Entity. The test Entities TE5 to TE19, most of which break a rule on purpose, are placed under FED-TI, a test Intermediate that the tester operates, so that no Federation Registration Operator has to publish incorrect data. See [test_data.md](test_data.md#2-federation-entities).

| ID | Description |
| :--- | :--- |
| **TE1** | A valid Leaf Entity registered under an Intermediate. In BAS an Authorization Server, see below. If Trust Marks are used, it holds at least one valid Trust Mark from an accredited Trust Mark Issuer. |
| **TE2** | A valid Leaf Entity of another Entity Type. In BAS a Client, see below. |
| **TE3** | A valid Entity with two protocol Entity Types, `oauth_client` and `oauth_resource`. |
| **TE4** | A valid Client or Protected Resource whose Entity Configuration is hosted by its Intermediate and found through `ec_location`. Only if hosting is supported. |
| **TE5** | An Entity that publishes a valid Entity Configuration, with `authority_hints` pointing at an Intermediate, but that is not registered. |
| **TE6** | A registered Entity whose Entity Configuration has expired (`exp` in the past). |
| **TE7** | A registered Entity whose Entity Configuration is signed with a key that is not in the Subordinate Statement about it. |
| **TE8** | A registered Entity whose metadata fails the Trust Anchor metadata policy, for example by lacking a parameter marked `essential`. The BAS variants are described below. |
| **TE9** | A registered Entity holding an expired Trust Mark. Only if Trust Marks are used. |
| **TE10** | A registered Entity holding a revoked Trust Mark (the Trust Mark Status endpoint returns `revoked`). Only if Trust Marks are used. |
| **TE11** | A registered Entity holding a Trust Mark from an issuer that is not listed for that type in the Trust Anchor's `trust_mark_issuers`. Only if Trust Marks are used. |
| **TE12** | A registered Entity whose Entity Configuration lists an unknown claim in `crit`. |
| **TE13** | A registered Entity whose Subordinate Statement lists an unknown operator in `metadata_policy_crit` and uses it. |
| **TE14** | A registered Entity whose Trust Chain breaks a constraint (`max_path_length`, `naming_constraints` or `allowed_entity_types`). |
| **TE15** | A registered Entity whose Subordinate Statement does not satisfy the Trust Anchor's `registration_policy` constraint. In BAS, the Trust Anchor sets this constraint (Section 4.2 of \[[BAS.Rules](#bas-rules)\]), and the policy URI for verification of organisational affiliation is missing. |
| **TE16** | An Entity whose `authority_hints` holds a large number of non-existent Intermediates, and an Entity whose `authority_hints` form a loop. |

For the tests in this document, the test Entities above are set up as follows, together with the additional test Entities TE8a to TE8f, TE17 and TE19:

| ID | Description |
| :--- | :--- |
| **TE1** | An Authorization Server. In addition to what BAS permits, it declares the grant type `authorization_code`, the client authentication method `client_secret_basic` and the signing algorithm `HS256`, so that the filtering of the Trust Anchor policy can be seen. It declares its own `organization_name`, which differs from the registered legal name. |
| **TE2** | A Client that publishes its keys using `jwks`. It declares `client_name#sv` and `client_name#en`, but not `client_name` without a language tag, and declares `response_types` as `["code"]`. |
| **TE8a** | A Client without `contacts` (`essential` in the BAS policy). |
| **TE8b** | A Client whose `grant_types` lacks `client_credentials` (`superset_of`). |
| **TE8c** | An Authorization Server whose `token_endpoint_auth_signing_alg_values_supported` lacks `ES256` (`superset_of`). |
| **TE8d** | A Client whose `token_endpoint_auth_method` is `client_secret_basic` (`one_of`). |
| **TE8e** | An Authorization Server whose `token_endpoint_auth_methods_supported` lacks `private_key_jwt` (`superset_of`). |
| **TE8f** | A Protected Resource without `resource` (`essential`). |
| **TE17** | A Client that publishes both `jwks` and `jwks_uri`, an Authorization Server whose `issuer` differs from its Entity Identifier, and a Protected Resource whose `resource` differs from its Entity Identifier. These break requirements that the BAS policy cannot express. |
| **TE19** | A Client that, in addition to `oauth_client`, declares metadata of the Entity Type `openid_relying_party`, which BAS does not admit. |

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the resolver alone. They use what the resolver publishes itself, and requests that the tester constructs.

<a name="transport"></a>
### 2.1. Transport

<a name="res-bas-001"></a>
#### RES-BAS-001: TLS configuration

- **Purpose**: Assert that the resolve endpoint is protected by TLS according to the federation's security requirements.
- **Instructions**: Analyze the TLS configuration of the resolve endpoint host using a TLS analysis tool.
- **Expected result**:
  - The configuration MUST follow Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\], as required by Section 2 of \[[BAS.Security](#bas-security)\].
  - Weak protocol versions or cipher suites must be noted in the report.
- **References**: Section 2 of \[[BAS.Security](#bas-security)\] and Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\]

<a name="resolver-provided-by-the-trust-anchor"></a>
### 2.2. Resolver Provided by the Trust Anchor

<a name="res-bas-009"></a>
#### RES-BAS-009: Verifying that the resolver is the Trust Anchor

- **Purpose**: Assert that the BAS resolver is provided by the Trust Anchor at the resolve endpoint published for the environment, and can be used without client authentication, so that an Entity that uses it needs to trust no other Entity than the Trust Anchor.
- **Instructions**: Before the test, note the Trust Anchor Entity Identifier and the resolve endpoint that Section 5 of \[[BAS.Structure](#bas-structure)\] gives for the environment under test. Fetch the Entity Configuration of the Trust Anchor ([P-EC](procedures.md#p-ec)) and inspect `federation_resolve_endpoint` in its `federation_entity` metadata. List the Immediate Subordinates of the Trust Anchor ([P-LIST](procedures.md#p-list)), and send a resolve request for one of them without client authentication ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**:
  - `federation_resolve_endpoint` in the Trust Anchor's Entity Configuration MUST equal the resolve endpoint given in Section 5 of \[[BAS.Structure](#bas-structure)\] for the environment.
  - The resolve response MUST be signed by the Trust Anchor, with `iss` equal to the Trust Anchor Entity Identifier given in Section 5 of \[[BAS.Structure](#bas-structure)\].
  - The resolve request MUST be accepted without client authentication.
- **References**: Section 2.4 and 4.1 of \[[BAS.Rules](#bas-rules)\], Section 2 and 5 of \[[BAS.Structure](#bas-structure)\] and Section 8.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="values-assigned-and-constrained-in-bas"></a>
### 3.1. Values Assigned and Constrained in BAS

<a name="res-bas-002"></a>
#### RES-BAS-002: Resolved Metadata of an Authorization Server

- **Test data**: TE1, set up as described for BAS.
- **Purpose**: Assert that the resolver applies the BAS policy to an Authorization Server, so that peers only see the client authentication method and algorithms that BAS permits, while grant types that the Authorization Server supports outside BAS remain visible.
- **Instructions**: Send a resolve request for TE1 with `entity_type` set to `oauth_authorization_server` ([P-RESOLVE](procedures.md#p-resolve)). Compare the `metadata` claim with the values below.
- **Expected result**:
  - `grant_types_supported` MUST contain `client_credentials`. It MUST also still contain `authorization_code`, since the policy only checks `grant_types_supported` with `superset_of`, which removes nothing.
  - `token_endpoint_auth_methods_supported` MUST be exactly `["private_key_jwt"]`.
  - `token_endpoint_auth_signing_alg_values_supported` MUST contain `RS256` and `ES256`, and MUST NOT contain `HS256`.
  - `issuer`, `token_endpoint`, `jwks_uri`, `response_types_supported` and `scopes_supported` MUST be present, and `issuer` MUST equal the Entity Identifier.
- **References**: Section 5 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 2 and 3.1 of \[[BAS.Security](#bas-security)\]

<a name="res-bas-003"></a>
#### RES-BAS-003: Resolved Metadata of a Client

- **Test data**: TE2, set up as described for BAS.
- **Purpose**: Assert that the resolver applies the BAS policy and the values set by the Federation Registration Entity to a Client.
- **Instructions**: Send a resolve request for TE2 with `entity_type` set to `oauth_client` ([P-RESOLVE](procedures.md#p-resolve)). Compare the `metadata` claim with the values below.
- **Expected result**:
  - `response_types` MUST be an empty array, although the Client declares `["code"]`.
  - `token_endpoint_auth_method` MUST be `private_key_jwt`, and `grant_types` MUST be `["client_credentials"]`.
  - `jwks` MUST be present, and `jwks_uri` MUST NOT be present.
  - `client_name` without a language tag MUST be present and hold the Swedish value.
- **References**: Section 2.1, 2.2, 4 and 7.1 of \[[BAS.Metadata](#bas-metadata)\]

<a name="res-bas-004"></a>
#### RES-BAS-004: Organization parameters in Resolved Metadata

- **Test data**: TE1 and TE2, and their registered legal names and organization identifiers.
- **Purpose**: Assert that the resolver delivers the verified organization values that the Federation Registration Entity has set, which is the primary purpose of BAS metadata.
- **Instructions**: Before the test, note the registered legal name and organization identifier for TE1 and TE2. Send a resolve request for TE1 and for TE2 ([P-RESOLVE](procedures.md#p-resolve)), and inspect the `metadata` claim of the responses.
- **Expected result**:
  - `organization_name` without a language tag MUST hold the registered legal name. For TE1, the value MUST replace the value the Entity declares itself.
  - `organization_identifier` MUST hold the registered organization identifier, as a GLUE-URI in the format `urn:glue:iso6523:<icd>:<identifier>`.
  - `contacts` MUST be present and hold at least one email address.
- **References**: Section 1, 3, 3.1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 6.1 of \[[BAS.Rules](#bas-rules)\]

<a name="entities-that-break-the-bas-requirements"></a>
### 3.2. Entities That Break the BAS Requirements

<a name="res-bas-005"></a>
#### RES-BAS-005: Entities that fail the BAS policy

- **Test data**: TE8a to TE8f.
- **Purpose**: Assert that the resolver applies the `essential`, `superset_of` and `one_of` checks of the BAS policy, for Clients, Authorization Servers and Protected Resources (see [RES-OS-025](resolver_oidf_sweden_test.md#res-os-025)).
- **Instructions**: Send a resolve request for each of TE8a to TE8f ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: For each Entity, no resolve response MUST be returned. `invalid_metadata` or `invalid_trust_chain` are expected. The code must be noted in the report.
- **References**: Section 4, 5, 6 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 6.1.3.1.6, 6.1.3.1.7 and 6.1.4 of \[[OpenID.Federation](#openid-federation)\]

<a name="res-bas-006"></a>
#### RES-BAS-006: Entity registered without verification of organisational affiliation

- **Test data**: TE15.
- **Purpose**: Assert that the resolver does not resolve an Entity whose registration lacks verification of organisational affiliation, which is always required in BAS (see [RES-OS-029](resolver_oidf_sweden_test.md#res-os-029)).
- **Instructions**: Send a resolve request for TE15 ([P-RESOLVE](procedures.md#p-resolve)), whose Subordinate Statement lacks `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection` in `registration_policy`.
- **Expected result**: No resolve response MUST be returned. `invalid_trust_chain` is expected.
- **References**: Section 4.2 and 6.1 of \[[BAS.Rules](#bas-rules)\], Section 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\]

<a name="res-bas-007"></a>
#### RES-BAS-007: Entities that break requirements the policy cannot express

- **Test data**: TE17.
- **Purpose**: Find out how the resolver handles metadata that breaks BAS requirements that the policy cannot express. Peers MUST NOT use Resolved Metadata that breaks the `issuer` or `resource` binding. How a peer acts on other deviations is left to the peer.
- **Instructions**: Send a resolve request for each Entity in TE17 ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**: The resolver is not required to detect these errors, since they are not expressed in the Trust Chain. Both a successful response and an error are accepted. The outcome must be noted in the report, so that peers know whether they have to check these requirements themselves.
- **References**: Section 2.2, 5.1, 6.1 and 7.3 of \[[BAS.Metadata](#bas-metadata)\]

<a name="res-bas-010"></a>
#### RES-BAS-010: Entity Type not admitted in BAS

- **Test data**: TE19.
- **Purpose**: Assert that the resolver applies the `allowed_entity_types` constraint that the Trust Anchor sets, so that peers do not see metadata of Entity Types that BAS does not admit.
- **Instructions**: Send a resolve request for TE19 without `entity_type`, and one with `entity_type` set to `openid_relying_party` ([P-RESOLVE](procedures.md#p-resolve)).
- **Expected result**:
  - The response to the request without `entity_type` MUST contain the `oauth_client` metadata, and MUST NOT contain `openid_relying_party` metadata.
  - The request with `entity_type` set to `openid_relying_party` MUST NOT return `openid_relying_party` metadata. Whether the resolver responds with an error or without that metadata must be noted in the report.
- **References**: Section 4.2 of \[[BAS.Rules](#bas-rules)\] and Section 6.2.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="protocol-keys"></a>
### 3.3. Protocol Keys

<a name="res-bas-008"></a>
#### RES-BAS-008: Propagation of a new protocol key

- **Test data**: TE2, whose `jwks` is changed during the test.
- **Purpose**: Assert that a new protocol key reaches peers that use the resolver before the Entity starts to use it, under the key rollover rules of BAS.
- **Instructions**: Send a resolve request for TE2 ([P-RESOLVE](procedures.md#p-resolve)) and note `exp` of the response. Add a new key to the `jwks` of TE2's `oauth_client` metadata and publish a new Entity Configuration. Resolve TE2 repeatedly, and note when the new key first appears.
- **Expected result**:
  - The new key MUST appear in the Resolved Metadata no later than `exp` of the last resolve response without it, since the Entity may start to use the key when the Entity Configuration without it has expired.
  - Every key in the resolved `jwks` MUST have a `kid`, unique within the set.
  - The time until the new key appears must be noted in the report.
- **References**: Section 4 of \[[BAS.Security](#bas-security)\], Section 2.2 of \[[BAS.Metadata](#bas-metadata)\], Section 3.1 and 7.3 of \[[BAS.Rules](#bas-rules)\], Section 8.3.2 of \[[OpenID.Federation](#openid-federation)\] and Section 4.2.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]
