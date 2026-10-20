# Testing of the BAS Trust Anchor – BAS Conformance

This document contains a set of test cases that are applied to the Trust Anchor of Federationskontext BAS (BAS), the federation context for machine-to-machine access within, and towards, the Swedish public sector. BAS is operated by the Federation Operator, the Swedish Agency for Digital Government (Digg).

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

This document holds the **BAS conformance tests**. The test cases in this document check the Trust Anchor against the requirements that BAS adds to the OIDF Sweden conformance tests. Within BAS, the federation-wide rules are enforced through the metadata policy that the Trust Anchor carries in its Subordinate Statements, controlled by the Federation Operator. Per-Entity values are set by the Federation Registration Entities, and are tested in [Testing of BAS Federation Registration Entities](fre_overview.md).

The BAS conformance tests build on the OIDF Sweden conformance tests, [ta_oidf_sweden_test.md](ta_oidf_sweden_test.md), which are carried out first.

The test cases are grouped by the test data they need:

- **[Section 2](#tests-without-external-test-data)** holds tests that can be carried out against the TA alone, using only what it publishes itself and requests that the tester constructs. They need no test data from superior or subordinate Entities, and can be run as soon as the TA is deployed.
- **[Section 3](#tests-requiring-a-chain-of-test-data)** holds tests that need a chain of test data, such as a Trust Anchor, registered Entities, test Entities or coordination with other operators. Each test case states the data it needs under "Test data".

Note: Where the specifications do not state a concrete value or procedure, or where a value depends on the federation environment (Entity Identifiers, validity periods, test tooling), the test cases are given as an overall description. The tester completes such details from the federation rules and the environment before the test is carried out.

## Table of Contents

1. [**References**](#references)

    1.1. [**Normative Specifications**](#normative-specifications)

    1.2. [**Test Setup**](#test-setup)

2. [**Tests Without External Test Data**](#tests-without-external-test-data)

    2.1. [**Keys and Transport**](#keys-and-transport)

    [TA-BAS-001](#ta-bas-001) Verifying the federation keys against the BAS rules

    [TA-BAS-002](#ta-bas-002) TLS configuration

    2.2. [**Review of the BAS Documents**](#review-of-the-bas-documents)

    [TA-BAS-003](#ta-bas-003) Reviewing how BAS handles algorithms and client authentication

    [TA-BAS-004](#ta-bas-004) Reviewing what the BAS specifications defer to the federation rules

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Trust Anchor Metadata Policy**](#trust-anchor-metadata-policy)

    [TA-BAS-005](#ta-bas-005) Verifying that the metadata policy matches the published BAS policy

    [TA-BAS-006](#ta-bas-006) Verifying client authentication and algorithm constraints in the policy

    [TA-BAS-007](#ta-bas-007) Verifying the values that the policy assigns

    [TA-BAS-008](#ta-bas-008) Verifying the Entity Types admitted in BAS

    [TA-BAS-009](#ta-bas-009) Verifying the registration policy constraint

    3.2. [**Resolved Metadata**](#resolved-metadata)

    [TA-BAS-010](#ta-bas-010) Verifying the Resolved Metadata of registered Entities


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
> [Lindström, M. and S. Santesson, "Swedish OpenID Federation Deployment and Interoperability Profile 1.0 - draft 03", 2 October 2026](https://www.oidc.se/specifications/swedish-openid-federation-profile.html).

<a name="openid-federation-regpolicy"></a>
**\[OpenID.Federation.RegPolicy\]**
> [Lindström, M. and S. Santesson, "OpenID Federation Registration Policy 1.0 - draft 01", 30 March 2026](https://www.oidc.se/openid-federation-registration-policy/main.html).

<a name="bas-security"></a>
**\[BAS.Security\]**
> The Swedish Agency for Digital Government (Digg), "Federationskontext BAS: Security Requirements 1.0, draft 01", October 2026.

<a name="bas-metadata"></a>
**\[BAS.Metadata\]**
> The Swedish Agency for Digital Government (Digg), "Federationskontext BAS: OAuth 2.0 Metadata Requirements 1.0, draft 02", 6 October 2026.

<a name="bas-rules"></a>
**\[BAS.Rules\]**
> The Swedish Agency for Digital Government (Digg), federation rules for Federationskontext BAS, in preparation.

<a name="sib-registration"></a>
**\[SIB.Registration\]**
> The Swedish Agency for Digital Government (Digg), "Registrering – Tillämpningskrav och vägledning", version 13, 29 September 2026.

<a name="ena-oauth2"></a>
**\[Ena.OAuth2\]**
> ["Ena OAuth 2.0 Interoperability Profile"](https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html).

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

<a name="keys-and-transport"></a>
### 2.1. Keys and Transport

<a name="ta-bas-001"></a>
#### TA-BAS-001: Verifying the federation keys against the BAS rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The key length requirements for Federation Entity Keys.
- **Purpose**: Assert that the Trust Anchor's Federation Entity Keys have adequate lengths, although \[[BAS.Security](#bas-security)\] does not apply to Federation Entity Keys.
- **Instructions**: Use the key types and lengths noted in [TA-OS-006](ta_oidf_sweden_test.md#ta-os-006). Compare them with any key length requirement stated in \[[BAS.Rules](#bas-rules)\].
- **Expected result**:
  - If \[[BAS.Rules](#bas-rules)\] states key length requirements for Federation Entity Keys, the keys MUST meet them.
  - Otherwise, the keys are compared with a baseline: RSA keys of at least 2048 bits, and EC keys on one of the curves P-256, P-384 or P-521. Any deviation should be noted in the report as an observation, together with the absence of a requirement in the BAS rules.
- **References**: Section 1 of \[[BAS.Security](#bas-security)\], \[[BAS.Rules](#bas-rules)\] and Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-002"></a>
#### TA-BAS-002: TLS configuration

- **Purpose**: Assert that all TA endpoints are protected by TLS according to the federation's security requirements.
- **Instructions**: Analyze the TLS configuration of the hosts serving the Entity Configuration and all federation endpoints, using a TLS analysis tool.
- **Expected result**:
  - The configuration MUST follow Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\], as required by Section 2 of \[[BAS.Security](#bas-security)\].
  - Weak protocol versions or cipher suites must be noted in the report.
- **References**: Section 2 of \[[BAS.Security](#bas-security)\] and Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\]

<a name="review-of-the-bas-documents"></a>
### 2.2. Review of the BAS Documents

The test cases in this section are document reviews of the BAS documents.

<a name="ta-bas-003"></a>
#### TA-BAS-003: Reviewing how BAS handles algorithms and client authentication

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The algorithm and client authentication rules, together with BAS Security Requirements.
- **Purpose**: Assert that the BAS documents handle the interoperability issues that Section 7 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] requires federation rules to address (see [TA-OS-026](ta_oidf_sweden_test.md#ta-os-026)).
- **Instructions**: Review \[[BAS.Security](#bas-security)\] and \[[BAS.Rules](#bas-rules)\], and compare with the Trust Anchor metadata policy published in Section 7.1 of \[[BAS.Metadata](#bas-metadata)\]. Whether the Trust Anchor actually applies that policy is tested in [TA-BAS-006](#ta-bas-006).
- **Expected result**:
  - The rules MUST state the signature algorithms that every Entity validates. \[[BAS.Security](#bas-security)\] requires `RS256` and `ES256` and recommends `RS384`, `RS512`, `ES384` and `ES512`.
  - The rules MUST address encryption. \[[BAS.Security](#bas-security)\] states that protocol messages are not encrypted, so no encryption algorithms are mandatory.
  - The rules state that `private_key_jwt` is the only client authentication method, and that symmetric algorithms and shared secrets MUST NOT be used.
  - If Collaboration Contexts restrict the algorithms, they MUST NOT permit an algorithm that \[[BAS.Security](#bas-security)\] prohibits, and MUST NOT remove the requirement to support validation of `RS256` and `ES256`.
  - The rules are expected to be consistent with the Trust Anchor policy. Differences must be noted in the report.
- **References**: Section 2, 3, 3.1 and 3.2 of \[[BAS.Security](#bas-security)\] and Section 7 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-004"></a>
#### TA-BAS-004: Reviewing what the BAS specifications defer to the federation rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: Everything that the other BAS documents defer to BAS.Rules.
- **Purpose**: Assert that \[[BAS.Rules](#bas-rules)\] states what the other BAS documents leave to it, and what the Swedish profile expects of federation rules (see [TA-OS-024](ta_oidf_sweden_test.md#ta-os-024)).
- **Instructions**: Review \[[BAS.Rules](#bas-rules)\] and \[[SIB.Registration](#sib-registration)\].
- **Expected result**: The following are expected to be stated:
  - The grant types BAS permits, currently `client_credentials`.
  - How often Entities replace their keys.
  - Validity periods for Entity Statements, and key length requirements for Federation Entity Keys.
  - The registration checks and their registration policy URIs. URIs not yet assigned, such as for verification of registration submitter, must be noted in the report.
  - Whether Trust Marks are used in BAS, and if so, the Trust Mark Policy.
  - Since \[[BAS.Rules](#bas-rules)\] is in preparation, every missing item must be noted in the report.
- **References**: Section 4 of \[[BAS.Security](#bas-security)\], Section 2, 4 and 7 of \[[BAS.Metadata](#bas-metadata)\], \[[SIB.Registration](#sib-registration)\] and Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="trust-anchor-metadata-policy"></a>
### 3.1. Trust Anchor Metadata Policy

<a name="ta-bas-005"></a>
#### TA-BAS-005: Verifying that the metadata policy matches the published BAS policy

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: The grant types that BAS permits.
- **Purpose**: Assert that the TA applies exactly the metadata policy that the federation has published, to all Entities resolved through it.
- **Instructions**: Compare the `metadata_policy` claim of each Subordinate Statement with the policy published in Section 7.1 of \[[BAS.Metadata](#bas-metadata)\], for the Entity Types `oauth_client`, `oauth_authorization_server` and `oauth_resource`.
- **Expected result**:
  - For every Entity Type covered by the published policy, the policy in the Subordinate Statement MUST hold the same metadata parameters, operators and operator values.
  - The policy MUST be the same in all Subordinate Statements that the TA issues, since it is federation-wide.
  - Policies for other Entity Types, or additional parameters, must be noted in the report.
  - The `grant_types` and `grant_types_supported` values MUST correspond to the grant types that \[[BAS.Rules](#bas-rules)\] permits, currently only `client_credentials`.
  - The client authentication and algorithm entries are tested in detail in [TA-BAS-006](#ta-bas-006).
- **References**: Section 2 and 7.1 of \[[BAS.Metadata](#bas-metadata)\], Section 2 of \[[BAS.Security](#bas-security)\], \[[BAS.Rules](#bas-rules)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-006"></a>
#### TA-BAS-006: Verifying client authentication and algorithm constraints in the policy

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the policy enforces the single client authentication method of BAS and the signature algorithms that every Entity validates, so that any Client can authenticate at any Authorization Server.
- **Instructions**: Inspect the entries for client authentication and signature algorithms in the `metadata_policy` claim of the Subordinate Statements from [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028).
- **Expected result**:
  - `oauth_client` / `token_endpoint_auth_method` MUST be `essential` and restricted to `private_key_jwt` with `one_of`.
  - `oauth_authorization_server` / `token_endpoint_auth_methods_supported` MUST be `essential` and set to exactly `private_key_jwt`, using `subset_of` and `superset_of` with identical values. The same MUST apply to `revocation_endpoint_auth_methods_supported` and `introspection_endpoint_auth_methods_supported`, without `essential`.
  - `token_endpoint_auth_signing_alg_values_supported` MUST be `essential`, MUST use `superset_of` with `RS256` and `ES256`, and MUST use `subset_of` holding only algorithms that \[[BAS.Security](#bas-security)\] permits.
  - The `subset_of` values MUST NOT contain `none`, `HS256`, `HS384`, `HS512` or any algorithm based on SHA-1.
- **References**: Section 2 and 3.1 of \[[BAS.Security](#bas-security)\], Section 4.2, 5 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 6.1.3.1.8 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-bas-007"></a>
#### TA-BAS-007: Verifying the values that the policy assigns

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the only values the BAS policy assigns, rather than constrains, are values that follow from the BAS requirements, as the Swedish profile requires (see [TA-OS-035](ta_oidf_sweden_test.md#ta-os-035)).
- **Instructions**: Identify the `value`, `add` and `default` operators in the `metadata_policy` claim.
- **Expected result**:
  - The only assigned value is expected to be an empty `response_types` array for `oauth_client`, set with the `value` operator. This follows from the `client_credentials` grant, which uses no response type.
  - Any other assigned value must be noted in the report, together with the requirement in the BAS documents that motivates it.
- **References**: Section 4 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-008"></a>
#### TA-BAS-008: Verifying the Entity Types admitted in BAS

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2, and the list of connected Federation Registration Operators.
- **Purpose**: Assert that the Trust Anchor only admits the Entity Types that BAS covers, and that its Immediate Subordinates are the Federation Registration Entities.
- **Instructions**: Inspect the Entity Types covered by the `metadata_policy` claim and any `allowed_entity_types` constraint. Compare the list from [TA-OS-039](ta_oidf_sweden_test.md#ta-os-039) with the Federation Registration Entities of the connected Federation Registration Operators.
- **Expected result**:
  - The policy is expected to cover `oauth_client`, `oauth_authorization_server` and `oauth_resource`.
  - If `allowed_entity_types` is present, it is expected to list only these three Entity Types.
  - Every Immediate Subordinate is expected to be a Federation Registration Entity of a connected Federation Registration Operator. Any other Immediate Subordinate must be noted in the report.
- **References**: Section 1, 2 and 7 of \[[BAS.Metadata](#bas-metadata)\] and Section 6.2.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-bas-009"></a>
#### TA-BAS-009: Verifying the registration policy constraint

- **Applies to**: Only if the Trust Anchor sets a `registration_policy` constraint
- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Which registration checks are required, and their registration policy URIs.
- **Purpose**: Assert that the Trust Anchor requires, when Trust Chains are built, that verification of organisational affiliation has been performed for every Entity.
- **Instructions**: Inspect the `registration_policy` constraint in the `constraints` claim of the Subordinate Statements from [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028).
- **Expected result**:
  - A rule without `entity_types` is expected to require `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection`, since this check is always performed in BAS.
  - Rules for other checks, such as verification of registration submitter, must be noted in the report together with their URIs.
  - If the Trust Anchor sets no `registration_policy` constraint, this must be noted in the report. The requirement is then only upheld by the Federation Registration Entities, see [Testing of BAS Federation Registration Entities](fre_overview.md).
- **References**: Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\], Section 1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="resolved-metadata"></a>
### 3.2. Resolved Metadata

<a name="ta-bas-010"></a>
#### TA-BAS-010: Verifying the Resolved Metadata of registered Entities

- **Test data**: REG-C1, REG-AS1 and REG-PR1, and their Trust Chains.
- **Purpose**: Assert that the BAS policy, together with the values set by the Federation Registration Entities, gives Resolved Metadata that meets the BAS requirements.
- **Instructions**: Use the Trust Chains and Resolved Metadata from [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), with at least one Client, one Authorization Server and one Protected Resource. Compare the Resolved Metadata with the tables in Section 3 to 6 of \[[BAS.Metadata](#bas-metadata)\].
- **Expected result**:
  - For every Entity: `organization_name`, `organization_identifier` (in the format `urn:glue:iso6523:0007:<organization number>`) and `contacts` (with at least one email address) MUST be present.
  - Client: `token_endpoint_auth_method` MUST be `private_key_jwt`, `grant_types` MUST be `["client_credentials"]`, `response_types` MUST be an empty array, and exactly one of `jwks` and `jwks_uri` MUST be present.
  - Authorization Server: `issuer` MUST equal the Entity Identifier, and `token_endpoint`, `jwks_uri`, `response_types_supported` and `scopes_supported` MUST be present. `grant_types_supported` MUST be `["client_credentials"]` and `token_endpoint_auth_methods_supported` MUST be `["private_key_jwt"]`.
  - Protected Resource: `resource` MUST equal the Entity Identifier.
  - Every URL MUST use the `https` scheme.
  - Every deviation must be noted in the report, together with whether it is caused by the policy or by the Entity.
- **References**: Section 2, 3, 4, 5, 6 and 7 of \[[BAS.Metadata](#bas-metadata)\]
