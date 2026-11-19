# Testing of the BAS Trust Anchor – BAS Conformance

This document contains a set of test cases that are applied to the Trust Anchor of Federationskontext BAS (BAS), the federation context for machine-to-machine access within, and towards, the Swedish public sector. BAS is operated by the Federation Operator, the Swedish Agency for Digital Government (Digg).

Version: 0.2.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

This document holds the **BAS conformance tests**. The test cases in this document check the Trust Anchor against the requirements that BAS adds to the OIDF Sweden conformance tests. Within BAS, the federation-wide rules are enforced through the metadata policy that the Trust Anchor carries in its Subordinate Statements, controlled by the Federation Operator. Per-Entity values are set by the Federation Registration Entities, and are tested in [Testing of BAS Federation Registration Entities](fre_overview.md).

The BAS conformance tests complement the OIDF Sweden conformance tests, [ta_oidf_sweden_test.md](ta_oidf_sweden_test.md). Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md).

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

    [TA-BAS-003](#ta-bas-003) *Removed*

    [TA-BAS-004](#ta-bas-004) *Removed*

    2.2. [**Federation Structure and Endpoints**](#federation-structure-and-endpoints)

    [TA-BAS-011](#ta-bas-011) Verifying the Entity Identifier and resolve endpoint against the BAS structure

    [TA-BAS-012](#ta-bas-012) Federation endpoints without client authentication

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

<a name="sib-registration"></a>
**\[SIB.Registration\]**
> The Swedish Agency for Digital Government (Digg), "Registrering – Tillämpningskrav och vägledning", version 13, 29 September 2026.

<a name="ena-oauth2"></a>
**\[Ena.OAuth2\]**
> [Lindström, M., "Ena OAuth 2.0 Interoperability Profile 1.0 – draft 01", 16 October 2025](https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html).

<a name="test-setup"></a>
### 1.2. Test Setup

Each test case obtains the data it verifies itself, using the common procedures in [procedures.md](procedures.md), such as fetching an Entity Configuration ([P-EC](procedures.md#p-ec)) or building a Trust Chain ([P-CHAIN](procedures.md#p-chain)). No test case depends on the outcome of another. If a procedure cannot be completed, the test case is reported as *Inconclusive*, with the reason.

Before the tests are carried out, the tester collects the following information about the Trust Anchor (TA) under test:

| Item | Description |
| :--- | :--- |
| **TA Entity Identifier** | The Entity Identifier of the BAS Trust Anchor in the environment under test (for example the Sandbox), as published in Section 5 of \[[BAS.Structure](#bas-structure)\]. |
| **Out-of-band TA keys** | The Trust Anchor's Federation Entity Keys as distributed by the Federation Operator by other means than the Entity Configuration. They are to be published in Section 5 of \[[BAS.Structure](#bas-structure)\]. Until they are, they are provided by the Federation Operator. |
| **Expected Immediate Subordinates** | The Entity Identifiers of the Federation Registration Entities (connection services, Swedish: anslutningstjänster) of the Federation Registration Operators connected to BAS. These are the only Immediate Subordinates of the BAS Trust Anchor. They are listed in Section 5 of \[[BAS.Structure](#bas-structure)\]. Where no list is published for the environment under test, it is provided by the Federation Operator. |
| **Federation rules** | The BAS federation rules \[[BAS.Rules](#bas-rules)\]: validity periods for Entity Statements (Section 3.1), the constraints set by the Trust Anchor (Section 4.2) and the registration policies (Section 6). The federation-wide metadata policy, including the permitted grant types, is published in Section 7.1 of \[[BAS.Metadata](#bas-metadata)\]. |
| **Resolver** | The Entity Identifier and resolve endpoint of the Federation Resolver. In BAS, the resolver is the Trust Anchor itself (Section 4.1 of \[[BAS.Rules](#bas-rules)\]), and its resolve endpoint is published in Section 5 of \[[BAS.Structure](#bas-structure)\]. The resolver itself is tested according to [Testing of the BAS Federation Resolver](resolver_overview.md). |

Test cases that only apply under a condition, for example if Trust Marks are used, state this under "Applies to".

Note: Trust Marks are not yet defined in BAS, see Section 5 of \[[BAS.Rules](#bas-rules)\] and Section 4 of \[[BAS.Structure](#bas-structure)\]. The test cases for Trust Marks apply only if a later version of the BAS federation rules introduces them.

Note: The tool at https://jwt.io can be used to inspect Entity Statements and Trust Marks. For test cases that validate signatures and Trust Chains, an independent OpenID Federation implementation is used, so that the TA is not validated by its own software.

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the TA alone. They use what the TA publishes itself, and requests that the tester constructs.

<a name="keys-and-transport"></a>
### 2.1. Keys and Transport

<a name="ta-bas-001"></a>
#### TA-BAS-001: Verifying the federation keys against the BAS rules

- **Purpose**: Assert that the Trust Anchor's Federation Entity Keys meet the requirements that apply to them in BAS. \[[BAS.Security](#bas-security)\] does not apply to Federation Entity Keys. For them, Section 9 of \[[BAS.Rules](#bas-rules)\] makes Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] apply.
- **Instructions**: Fetch the Entity Configuration of the TA ([P-EC](procedures.md#p-ec)) and note the type and length of each key in its `jwks` claim. Compare them with the requirements in Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\].
- **Expected result**:
  - The keys MUST meet the requirements of Section 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], as Section 9 of \[[BAS.Rules](#bas-rules)\] requires.
  - Where those requirements state no key length, the keys are compared with a baseline: RSA keys of at least 2048 bits, and EC keys on one of the curves P-256, P-384 or P-521. Any deviation should be noted in the report as an observation.
- **References**: Section 1 of \[[BAS.Security](#bas-security)\], Section 9 of \[[BAS.Rules](#bas-rules)\] and Section 2.1 and 6 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-002"></a>
#### TA-BAS-002: TLS configuration

- **Purpose**: Assert that all TA endpoints are protected by TLS according to the federation's security requirements.
- **Instructions**: Analyze the TLS configuration of the hosts serving the Entity Configuration and all federation endpoints published in it ([P-EC](procedures.md#p-ec)), using a TLS analysis tool.
- **Expected result**:
  - The configuration MUST follow Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\], as required by Section 2 of \[[BAS.Security](#bas-security)\].
  - Weak protocol versions or cipher suites must be noted in the report.
- **References**: Section 2 of \[[BAS.Security](#bas-security)\] and Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\]

<a name="ta-bas-003"></a>
#### TA-BAS-003: Reviewing how BAS handles algorithms and client authentication

*Removed in version 0.1.0: the test case reviewed the BAS documents rather than what the Trust Anchor publishes. The policy that enforces the algorithms and the client authentication method is tested in [TA-BAS-006](#ta-bas-006).*

<a name="ta-bas-004"></a>
#### TA-BAS-004: Reviewing what the BAS specifications defer to the federation rules

*Removed in version 0.1.0: the test case reviewed the BAS documents rather than what the Trust Anchor publishes.*

<a name="federation-structure-and-endpoints"></a>
### 2.2. Federation Structure and Endpoints

<a name="ta-bas-011"></a>
#### TA-BAS-011: Verifying the Entity Identifier and resolve endpoint against the BAS structure

- **Purpose**: Assert that the Trust Anchor uses the Entity Identifier, and provides the resolve endpoint, that \[[BAS.Structure](#bas-structure)\] publishes for the environment, since participants configure trust in the federation from that information.
- **Instructions**: Before the test, note the Trust Anchor Entity Identifier and the resolve endpoint that Section 5 of \[[BAS.Structure](#bas-structure)\] gives for the environment under test. Fetch the Entity Configuration of the TA using that Entity Identifier ([P-EC](procedures.md#p-ec)), and inspect `iss`, `sub` and the `federation_resolve_endpoint` in its `federation_entity` metadata.
- **Expected result**:
  - `iss` and `sub` MUST equal the Entity Identifier given in Section 5 of \[[BAS.Structure](#bas-structure)\] for the environment.
  - `federation_resolve_endpoint` MUST be present and MUST equal the resolve endpoint given in Section 5 of \[[BAS.Structure](#bas-structure)\] for the environment, since the BAS Trust Anchor provides the resolver itself.
  - The keys are compared with the keys distributed out-of-band in [TA-OS-007](ta_oidf_sweden_test.md#ta-os-007).
- **References**: Section 2.1 and 4.1 of \[[BAS.Rules](#bas-rules)\] and Section 2 and 5 of \[[BAS.Structure](#bas-structure)\]

<a name="ta-bas-012"></a>
#### TA-BAS-012: Federation endpoints without client authentication

- **Purpose**: Assert that the federation endpoints of the Trust Anchor can be used without client authentication, as BAS states.
- **Instructions**: Fetch the Entity Configuration of the TA ([P-EC](procedures.md#p-ec)) and note every endpoint in its `federation_entity` metadata, and any `*_auth_methods` parameters. Without client authentication, list the Immediate Subordinates ([P-LIST](procedures.md#p-list)), fetch the Subordinate Statement about one of them ([P-FETCH](procedures.md#p-fetch)), and send a resolve request for the same Entity ([P-RESOLVE](procedures.md#p-resolve)). Send an unauthenticated GET request to every other endpoint published.
- **Expected result**:
  - Every federation endpoint MUST accept the unauthenticated requests. A response that requires client authentication, such as HTTP status code 401 or the error code `invalid_client`, is a failure.
  - Any `*_auth_methods` parameter must be noted in the report, together with the methods it declares.
- **References**: Section 2.4 of \[[BAS.Rules](#bas-rules)\] and Section 8.8 of \[[OpenID.Federation](#openid-federation)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="trust-anchor-metadata-policy"></a>
### 3.1. Trust Anchor Metadata Policy

<a name="ta-bas-005"></a>
#### TA-BAS-005: Verifying that the metadata policy matches the published BAS policy

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the TA applies exactly the metadata policy that the federation has published, to all Entities resolved through it.
- **Instructions**: For each expected Immediate Subordinate, fetch the Subordinate Statement from the TA ([P-FETCH](procedures.md#p-fetch)). Compare the `metadata_policy` claim of each Subordinate Statement with the policy published in Section 7.1 of \[[BAS.Metadata](#bas-metadata)\], for the Entity Types `oauth_client`, `oauth_authorization_server` and `oauth_resource`.
- **Expected result**:
  - For every Entity Type covered by the published policy, the policy in the Subordinate Statement MUST hold the same metadata parameters, operators and operator values.
  - The policy MUST be the same in all Subordinate Statements that the TA issues, since it is federation-wide.
  - Policies for other Entity Types, or additional parameters, must be noted in the report.
  - `oauth_client` / `grant_types` MUST be `essential` and MUST use `subset_of` and `superset_of`, both holding only `client_credentials`, the only grant type used in BAS.
  - `oauth_authorization_server` / `grant_types_supported` MUST be `essential`, MUST use `superset_of` holding `client_credentials`, and MUST NOT use `subset_of`, since an Authorization Server may also list grant types it supports outside BAS.
  - The client authentication and algorithm entries are tested in detail in [TA-BAS-006](#ta-bas-006).
- **References**: Section 2, 4, 5, 7 and 7.1 of \[[BAS.Metadata](#bas-metadata)\], Section 2 of \[[BAS.Security](#bas-security)\], Section 2.1 and 8 of \[[BAS.Rules](#bas-rules)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-006"></a>
#### TA-BAS-006: Verifying client authentication and algorithm constraints in the policy

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the policy enforces the single client authentication method of BAS and the signature algorithms that every Entity validates, so that any Client can authenticate at any Authorization Server.
- **Instructions**: For each expected Immediate Subordinate, fetch the Subordinate Statement from the TA ([P-FETCH](procedures.md#p-fetch)). Inspect the entries for client authentication and signature algorithms in its `metadata_policy` claim.
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
- **Instructions**: For each expected Immediate Subordinate, fetch the Subordinate Statement from the TA ([P-FETCH](procedures.md#p-fetch)). Identify the `value`, `add` and `default` operators in its `metadata_policy` claim.
- **Expected result**:
  - The only assigned value is expected to be an empty `response_types` array for `oauth_client`, set with the `value` operator. This follows from the `client_credentials` grant, which uses no response type.
  - Any other assigned value must be noted in the report, together with the requirement in the BAS documents that motivates it.
- **References**: Section 4 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 2.5 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="ta-bas-008"></a>
#### TA-BAS-008: Verifying the Entity Types admitted in BAS

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2, and the Federation Registration Entities listed in Section 5 of \[[BAS.Structure](#bas-structure)\] for the environment.
- **Purpose**: Assert that the Trust Anchor only admits the Entity Types that BAS covers, and that its Immediate Subordinates are the Federation Registration Entities.
- **Instructions**: For each expected Immediate Subordinate, fetch the Subordinate Statement from the TA ([P-FETCH](procedures.md#p-fetch)), and inspect the Entity Types covered by the `metadata_policy` claim and the `allowed_entity_types` constraint in its `constraints` claim. List the Immediate Subordinates of the TA ([P-LIST](procedures.md#p-list)) and compare the list with the Federation Registration Entities listed in Section 5 of \[[BAS.Structure](#bas-structure)\] for the environment under test. Where no list is published for the environment, the list is provided by the Federation Operator.
- **Expected result**:
  - The policy is expected to cover `oauth_client`, `oauth_authorization_server` and `oauth_resource`.
  - The `allowed_entity_types` constraint MUST be present and MUST hold exactly `oauth_client`, `oauth_authorization_server` and `oauth_resource`. It MUST NOT contain `federation_entity`, which is always allowed.
  - Every Immediate Subordinate is expected to be a listed Federation Registration Entity. Any other Immediate Subordinate must be noted in the report.
  - Each Federation Registration Operator is expected to provide one Federation Registration Entity. An operator with more than one must be noted in the report.
- **References**: Section 2.2, 4.2 and 7.1 of \[[BAS.Rules](#bas-rules)\], Section 2 and 5 of \[[BAS.Structure](#bas-structure)\], Section 1, 2 and 7 of \[[BAS.Metadata](#bas-metadata)\] and Section 6.2.3 of \[[OpenID.Federation](#openid-federation)\]

<a name="ta-bas-009"></a>
#### TA-BAS-009: Verifying the registration policy constraint

- **Test data**: Subordinate Statements about FED-FRE1 and FED-FRE2.
- **Purpose**: Assert that the Trust Anchor requires, when Trust Chains are built, that verification of organisational affiliation has been performed for every Entity.
- **Instructions**: For each expected Immediate Subordinate, fetch the Subordinate Statement from the TA ([P-FETCH](procedures.md#p-fetch)). Inspect the `registration_policy` constraint in its `constraints` claim.
- **Expected result**:
  - The `registration_policy` constraint MUST be present.
  - It MUST hold a rule whose `policy` is `["https://id.ena-infrastructure.se/regpolicy/v1/orgconnection"]`, and that applies to every Entity Type admitted in BAS, either by omitting `entity_types` or by listing `oauth_client`, `oauth_authorization_server` and `oauth_resource`.
  - Each rule MUST list a single policy, since a rule is satisfied if any one of the policies it lists has been applied.
  - Rules for other policies must be noted in the report together with their URIs. Verification of registration submitter is not yet defined, see Section 6.2 of \[[BAS.Rules](#bas-rules)\].
- **References**: Section 4.2, 6, 6.1 and 7.1 of \[[BAS.Rules](#bas-rules)\], Section 3 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\], Section 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="resolved-metadata"></a>
### 3.2. Resolved Metadata

<a name="ta-bas-010"></a>
#### TA-BAS-010: Verifying the Resolved Metadata of registered Entities

- **Test data**: All Entities registered under the Immediate Subordinates of FED-TA.
- **Purpose**: Assert that the BAS policy, together with the values set by the Federation Registration Entities, gives Resolved Metadata that meets the BAS requirements for every Entity in the federation.
- **Instructions**: List the Immediate Subordinates of the TA ([P-LIST](procedures.md#p-list)), and for each of them list the Entities it has registered ([P-LIST](procedures.md#p-list)). For each listed Leaf Entity, build the Trust Chain to the TA and resolve its metadata ([P-CHAIN](procedures.md#p-chain)). The check is expected to be carried out with a tool, since the number of Entities can be large. Compare the Resolved Metadata with the tables in Section 3 to 6 of \[[BAS.Metadata](#bas-metadata)\].
- **Expected result**:
  - For every Entity: `organization_name`, `organization_identifier` and `contacts` (with at least one email address) MUST be present. `organization_identifier` MUST be a GLUE-URI in the format `urn:glue:iso6523:<icd>:<identifier>`. For ICD 0007 (Swedish organization number), the identifier MUST be ten digits without a hyphen.
  - Client: `token_endpoint_auth_method` MUST be `private_key_jwt`, `grant_types` MUST be `["client_credentials"]`, `response_types` MUST be an empty array, and exactly one of `jwks` and `jwks_uri` MUST be present.
  - Authorization Server: `issuer` MUST equal the Entity Identifier, and `token_endpoint`, `jwks_uri`, `response_types_supported` and `scopes_supported` MUST be present. `grant_types_supported` MUST contain `client_credentials`, and `token_endpoint_auth_methods_supported` MUST be `["private_key_jwt"]`. `token_endpoint_auth_signing_alg_values_supported` MUST contain `RS256` and `ES256`, and MUST NOT contain `none`, `HS256`, `HS384` or `HS512`. If it lacks any of `RS384`, `RS512`, `ES384` and `ES512`, this should be noted in the report as an observation.
  - Authorization Server: if `revocation_endpoint` is present, `revocation_endpoint_auth_methods_supported` MUST be `["private_key_jwt"]`. If `introspection_endpoint` is present, `introspection_endpoint_auth_methods_supported` MUST be `["private_key_jwt"]`.
  - Protected Resource: `resource` MUST equal the Entity Identifier. If `authorization_servers` is present, it MUST contain the Entity Identifier of at least one Authorization Server in BAS.
  - Every JWK in the Entity's `jwks`, or in the JWK Set at its `jwks_uri`, MUST have a `kid`, unique within the set.
  - Every URL MUST use the `https` scheme.
  - Every deviation must be noted in the report, together with whether it is caused by the policy or by the Entity.
- **References**: Section 2, 2.2, 3, 3.1, 4, 5, 6 and 7 of \[[BAS.Metadata](#bas-metadata)\], Section 3.1 and 4 of \[[BAS.Security](#bas-security)\] and Section 8 of \[[BAS.Rules](#bas-rules)\]
