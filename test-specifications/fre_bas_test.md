# Testing of BAS Federation Registration Entities – BAS Conformance

This document contains a set of test cases that are applied to Intermediate Entities in Federationskontext BAS (BAS). Within BAS, the Intermediates are the Federation Registration Entities: the connection services (Swedish: anslutningstjänster) that Federation Registration Operators provide, and through which the OAuth 2.0 Clients, Authorization Servers and Protected Resources of Federation Members are registered under \[[SIB.Registration](#sib-registration)\].

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

This document holds the **BAS conformance tests**. The test cases in this document check the Intermediate against the requirements that BAS adds to the OIDF Sweden conformance tests. Within BAS, the Intermediate is a Federation Registration Entity provided by a Federation Registration Operator. It registers Entities after the checks of \[[SIB.Registration](#sib-registration)\], sets the verified per-Entity values in the Subordinate Statement, and states the checks performed in the `registration_policy` claim. Federation-wide rules are set by the Trust Anchor and are tested in [Testing of the BAS Trust Anchor](ta_overview.md).

The BAS conformance tests build on the OIDF Sweden conformance tests, [fre_oidf_sweden_test.md](fre_oidf_sweden_test.md), which are carried out first.

The test cases are grouped by the test data they need:

- **[Section 2](#tests-without-external-test-data)** holds tests that can be carried out against the FRE alone, using only what it publishes itself and requests that the tester constructs. They need no test data from superior or subordinate Entities, and can be run as soon as the FRE is deployed.
- **[Section 3](#tests-requiring-a-chain-of-test-data)** holds tests that need a chain of test data, such as a Trust Anchor, registered Entities, test Entities or coordination with other operators. Each test case states the data it needs under "Test data".

Note: Where the specifications do not state a concrete value or procedure, or where a value depends on the federation environment (Entity Identifiers, validity periods, registration procedures, test tooling), the test cases are given as an overall description. The tester completes such details from the federation rules and the environment before the test is carried out.

## Table of Contents

1. [**References**](#references)

    1.1. [**Normative Specifications**](#normative-specifications)

    1.2. [**Test Setup**](#test-setup)

2. [**Tests Without External Test Data**](#tests-without-external-test-data)

    2.1. [**Keys and Transport**](#keys-and-transport)

    [FRE-BAS-001](#fre-bas-001) Verifying the federation keys against the BAS rules

    [FRE-BAS-002](#fre-bas-002) TLS configuration

3. [**Tests Requiring a Chain of Test Data**](#tests-requiring-a-chain-of-test-data)

    3.1. [**Per-Entity Values**](#per-entity-values)

    [FRE-BAS-003](#fre-bas-003) Verifying organization parameters

    [FRE-BAS-004](#fre-bas-004) Verifying language-tagged values

    [FRE-BAS-005](#fre-bas-005) Verifying that the FRE sets no other values

    [FRE-BAS-006](#fre-bas-006) Verifying the BAS registration policies

    3.2. [**Resolved Metadata**](#resolved-metadata)

    [FRE-BAS-007](#fre-bas-007) Verifying the Resolved Metadata of registered Entities

    3.3. [**Registration Checks**](#registration-checks)

    [FRE-BAS-008](#fre-bas-008) Registering a new Entity in BAS

    [FRE-BAS-009](#fre-bas-009) Registering an Entity with metadata that the BAS policy rejects

    [FRE-BAS-010](#fre-bas-010) Registering an Entity with metadata that the policy cannot check

    [FRE-BAS-011](#fre-bas-011) Registering an Entity with incorrect organization details

    3.4. [**Changes to Verified Values**](#changes-to-verified-values)

    [FRE-BAS-012](#fre-bas-012) Changing a verified value in the Entity Configuration


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

Before the tests are carried out, the tester collects the following information about the Intermediate (FRE) under test:

| Item | Description |
| :--- | :--- |
| **FRE Entity Identifier** | The Entity Identifier of the connection service under test, and the Federation Registration Operator that provides it. |
| **Trust Anchor** | The Entity Identifier and the out-of-band distributed keys of the Trust Anchor the FRE is registered under. |
| **Registered Entities** | A list of the Entities the FRE is expected to have registered, and their Entity Types. |
| **Test Entities** | At least one test Entity per Entity Type the FRE registers, which the tester controls and can have registered, changed and removed during the tests (see [Section 3](#tests-requiring-a-chain-of-test-data)). |
| **Registration documentation** | The registration procedure and the checks the FRE performs, including the registration policy URIs, see \[[SIB.Registration](#sib-registration)\] and Section 7.2 of \[[BAS.Metadata](#bas-metadata)\]. |

Test cases that only apply under a condition state this under "Applies to".

Note: The tool at https://jwt.io can be used to inspect Entity Statements. For test cases that validate signatures and Trust Chains, an independent OpenID Federation implementation is used.

<a name="tests-without-external-test-data"></a>
## 2. Tests Without External Test Data

The test cases in this section can be carried out against the FRE alone. They use what the FRE publishes itself, requests that the tester constructs, and, for document reviews, the federation's own documents.

<a name="keys-and-transport"></a>
### 2.1. Keys and Transport

<a name="fre-bas-001"></a>
#### FRE-BAS-001: Verifying the federation keys against the BAS rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The key length requirements for Federation Entity Keys.
- **Purpose**: Assert that the FRE's Federation Entity Keys have adequate lengths, although \[[BAS.Security](#bas-security)\] does not apply to Federation Entity Keys.
- **Instructions**: Use the key types and lengths noted in [FRE-OS-006](fre_oidf_sweden_test.md#fre-os-006). Compare them with any key length requirement stated in \[[BAS.Rules](#bas-rules)\].
- **Expected result**:
  - If \[[BAS.Rules](#bas-rules)\] states key length requirements for Federation Entity Keys, the keys MUST meet them.
  - Otherwise, the keys are compared with a baseline: RSA keys of at least 2048 bits, and EC keys on one of the curves P-256, P-384 or P-521. Any deviation should be noted in the report as an observation.
- **References**: Section 1 of \[[BAS.Security](#bas-security)\], \[[BAS.Rules](#bas-rules)\] and Section 2.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-bas-002"></a>
#### FRE-BAS-002: TLS configuration

- **Purpose**: Assert that all FRE endpoints, and any hosted Entity Configurations, are protected by TLS according to the federation's security requirements.
- **Instructions**: Analyze the TLS configuration of the hosts serving the Entity Configuration, the federation endpoints and any `ec_location` URLs, using a TLS analysis tool.
- **Expected result**:
  - The configuration MUST follow Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\], as required by Section 2 of \[[BAS.Security](#bas-security)\].
  - Weak protocol versions or cipher suites must be noted in the report.
- **References**: Section 2 of \[[BAS.Security](#bas-security)\] and Section 8.1 of \[[Ena.OAuth2](#ena-oauth2)\]

<a name="tests-requiring-a-chain-of-test-data"></a>
## 3. Tests Requiring a Chain of Test Data

The test cases in this section need test data from other Entities in the federation, such as the Trust Anchor, registered Entities, test Entities or coordinated changes. The data each test case needs is stated under "Test data", and the named test data (FED-, REG-, TR and TE) is described in [test_data.md](test_data.md).

<a name="per-entity-values"></a>
### 3.1. Per-Entity Values

The values in this section are set in the `metadata` claim of the Subordinate Statement, under the Entity Type of the Entity, and replace any value the Entity declares itself, see Section 7.2 of \[[BAS.Metadata](#bas-metadata)\].

<a name="fre-bas-003"></a>
#### FRE-BAS-003: Verifying organization parameters

- **Test data**: REG-C1, REG-AS1 and REG-PR1, and the registered legal name and organization number behind each.
- **Purpose**: Assert that the FRE assigns the verified name and identifier of the organization that owns the Entity, so that peers can see which organization an Entity is registered for.
- **Instructions**: Before the test, note the registered legal name and organization number of the organization behind each Entity. Inspect the `metadata` claim of the Subordinate Statements, under the Entity Type of each Entity.
- **Expected result**:
  - `organization_name` MUST be set in the `metadata` claim. The value without a language tag MUST be the legal name of the organization. `#sv` and `#en` values are expected when the organization has supplied them.
  - `organization_identifier` MUST be set in the `metadata` claim and MUST have the format `urn:glue:iso6523:0007:<organization number>`, where the organization number is ten digits without a hyphen.
  - Both values MUST match the registered values.
  - The values MUST be set in the `metadata` claim and not by metadata policy, so that they replace any value the Entity declares itself.
- **References**: Section 1, 3, 3.1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and \[[SIB.Registration](#sib-registration)\]

<a name="fre-bas-004"></a>
#### FRE-BAS-004: Verifying language-tagged values

- **Test data**: REG-C1 and REG-PR1, which declare human-readable parameters with language tags.
- **Purpose**: Assert that the Federation Registration Entity assigns a value without a language tag, holding the Swedish value, for human-readable parameters, so that implementations without language tag support can use them.
- **Instructions**: For each registered Entity, identify the human-readable parameters it declares with language tags (for example `client_name#sv`, `resource_name#sv`, `display_name#sv`). Inspect the `metadata` claim of the Subordinate Statement.
- **Expected result**:
  - For each such parameter, a corresponding parameter without a language tag, holding the Swedish value, MUST be assigned in the `metadata` claim.
  - If the display name has been verified and the Entity has not declared `display_name`, `display_name` MUST be assigned from `client_name` or `resource_name`.
  - A value without a language tag that the Entity declares itself is replaced by the assigned value.
- **References**: Section 2, 3 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="fre-bas-005"></a>
#### FRE-BAS-005: Verifying that the FRE sets no other values

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the Federation Registration Entity only sets the values that \[[BAS.Metadata](#bas-metadata)\] assigns to it, since all other assigned or constrained values are controlled by the Federation Operator through the Trust Anchor.
- **Instructions**: Inspect the `metadata` and `metadata_policy` claims of the Subordinate Statements from [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020).
- **Expected result**:
  - The `metadata` claim is expected to hold only `organization_name` (with any `#sv` and `#en` values), `organization_identifier`, `display_name` where the display name has been verified, and values without a language tag for human-readable parameters.
  - The Subordinate Statements are not expected to contain a `metadata_policy` claim. If they do, every entry must be noted in the report.
  - Every other value must be noted in the report.
- **References**: Section 1, 2, 7 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 2.5 and 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-bas-006"></a>
#### FRE-BAS-006: Verifying the BAS registration policies

- **Test data**: REG-C1, REG-AS1 and REG-PR1, and the registration checks performed for each.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Which registration checks are performed, and their registration policy URIs.
- **Purpose**: Assert that the FRE states the registration checks of \[[SIB.Registration](#sib-registration)\] that it performed when it registered each Entity, so that peers and the Trust Anchor can rely on them. The generic form of the claim is tested in [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029).
- **Instructions**: Before the test, note which registration checks were performed for each registered Entity. Inspect the `registration_policy` claim of the Subordinate Statements from [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020).
- **Expected result**:
  - `registration_policy` MUST be present and MUST be an array of URI strings.
  - It MUST list the registration policy URI of every check performed for the Entity, including `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection` for verification of organisational affiliation, which is always performed.
  - It MUST NOT list a check that has not been performed. URIs that are not yet assigned in \[[SIB.Registration](#sib-registration)\] should be noted in the report.
- **References**: Section 2 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\], Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="resolved-metadata"></a>
### 3.2. Resolved Metadata

<a name="fre-bas-007"></a>
#### FRE-BAS-007: Verifying the Resolved Metadata of registered Entities

- **Test data**: REG-C1, REG-AS1 and REG-PR1, and FED-TA with its metadata policy.
- **Purpose**: Assert that the values set by the FRE, together with the Trust Anchor policy, give Resolved Metadata that meets the BAS requirements for the Entities the FRE has registered.
- **Instructions**: Use the Resolved Metadata from [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028), with at least one Entity of each Entity Type the FRE registers. Compare it with the tables in Section 3 to 6 of \[[BAS.Metadata](#bas-metadata)\].
- **Expected result**:
  - `organization_name` and `organization_identifier` MUST hold the values set by the FRE, also when the Entity declares other values.
  - `contacts` MUST be present and hold at least one email address.
  - Human-readable parameters MUST be present without a language tag, holding the Swedish value.
  - The protocol parameters are expected to meet Section 4 to 6 of \[[BAS.Metadata](#bas-metadata)\]. Deviations must be noted in the report, together with whether they are caused by the Entity, the FRE or the Trust Anchor policy.
- **References**: Section 2, 3, 4, 5, 6 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="registration-checks"></a>
### 3.3. Registration Checks

The test cases in this section assert that the FRE performs the checks that BAS requires before it registers an Entity. They are carried out using the registration procedure of the FRE under test.

<a name="fre-bas-008"></a>
#### FRE-BAS-008: Registering a new Entity in BAS

- **Test data**: TR1.
- **Purpose**: Assert that a newly registered Entity gets a Subordinate Statement that meets the BAS requirements, in addition to the requirements tested in [FRE-OS-036](fre_oidf_sweden_test.md#fre-os-036).
- **Instructions**: Use the test Entity registered in [FRE-OS-036](fre_oidf_sweden_test.md#fre-os-036). Before registration, note the organization the Entity is registered for.
- **Expected result**:
  - The Subordinate Statement MUST pass [FRE-BAS-003](#fre-bas-003), [FRE-BAS-004](#fre-bas-004), [FRE-BAS-005](#fre-bas-005) and [FRE-BAS-006](#fre-bas-006).
  - The Entity MUST resolve according to [FRE-BAS-007](#fre-bas-007).
- **References**: Section 7.2 of \[[BAS.Metadata](#bas-metadata)\] and \[[SIB.Registration](#sib-registration)\]

<a name="fre-bas-009"></a>
#### FRE-BAS-009: Registering an Entity with metadata that the BAS policy rejects

- **Test data**: TR5, submitted for registration.
- **Purpose**: Find out whether the FRE detects, at registration, metadata that would make the Entity fail the Trust Anchor's metadata policy.
- **Instructions**: Try to register a test Entity that lacks a parameter the Trust Anchor policy marks as `essential` (for example `contacts`), or that does not declare a value required by `superset_of` (for example a Client whose `grant_types` lacks `client_credentials`, or an Authorization Server whose `token_endpoint_auth_signing_alg_values_supported` lacks `ES256`), or that declares a value outside `one_of` (for example a Client with `token_endpoint_auth_method` set to `client_secret_basic`).
- **Expected result**: The FRE is expected to reject the registration. If the FRE registers the Entity, the Entity's Trust Chain will be invalid. This must be noted in the report and discussed with the Federation Registration Operator.
- **References**: Section 6.1.4 of \[[OpenID.Federation](#openid-federation)\] and Section 7.1 of \[[BAS.Metadata](#bas-metadata)\]

<a name="fre-bas-010"></a>
#### FRE-BAS-010: Registering an Entity with metadata that the policy cannot check

- **Test data**: TR6, submitted for registration.
- **Purpose**: Assert that the FRE checks the requirements that cannot be expressed as a metadata policy.
- **Instructions**: Try to register test Entities that each break one of the following requirements:<br/>1. A Client that publishes both `jwks` and `jwks_uri`.<br/>2. An Authorization Server whose `issuer` differs from its Entity Identifier.<br/>3. A Protected Resource whose `resource` differs from its Entity Identifier, or contains a fragment component.<br/>4. A `jwks_uri` or `logo_uri` that does not use the `https` scheme.<br/>5. A Protected Resource whose `authorization_servers` does not contain any Authorization Server in BAS.<br/>6. Protocol keys that do not meet \[[BAS.Security](#bas-security)\], for example a JWK without `kid`.
- **Expected result**:
  - For cases 1 to 4, the FRE SHOULD reject the registration, since these requirements cannot be expressed in the Trust Anchor metadata policy. Any registration that is accepted must be noted in the report.
  - For cases 5 and 6, the FRE is expected to reject the registration. An accepted registration must be noted in the report.
- **References**: Section 4, 5, 6, 6.1 and 7.1 of \[[BAS.Metadata](#bas-metadata)\] and Section 4 of \[[BAS.Security](#bas-security)\]

<a name="fre-bas-011"></a>
#### FRE-BAS-011: Registering an Entity with incorrect organization details

- **Test data**: TR7, submitted for registration.
- **Purpose**: Assert that the FRE verifies organizational affiliation, and does not register an Entity with an organization name or number that does not belong to the applicant.
- **Instructions**: Try to register a test Entity on behalf of an organization the registration submitter does not represent, or declare an `organization_name` or `organization_identifier` that does not match the organization.
- **Expected result**: The FRE MUST NOT issue a Subordinate Statement with organization values that have not been verified. The outcome of the attempt must be noted in the report.
- **References**: Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\], Section 1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and \[[SIB.Registration](#sib-registration)\]

<a name="changes-to-verified-values"></a>
### 3.4. Changes to Verified Values

<a name="fre-bas-012"></a>
#### FRE-BAS-012: Changing a verified value in the Entity Configuration

- **Test data**: TR8, and FED-TA.
- **Purpose**: Assert that an Entity cannot change a verified value by changing its own Entity Configuration.
- **Instructions**: For a registered test Entity, change `organization_name` and `organization_identifier` in the Entity's own Entity Configuration, without a new registration. Resolve the Entity's metadata.
- **Expected result**: The Resolved Metadata MUST still hold the values assigned or pinned by the FRE.
- **References**: Section 2 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]
