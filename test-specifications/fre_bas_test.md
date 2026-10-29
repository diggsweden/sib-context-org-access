# Testing of BAS Federation Registration Entities – BAS Conformance

This document contains a set of test cases that are applied to Intermediate Entities in Federationskontext BAS (BAS). Within BAS, the Intermediates are the Federation Registration Entities: the connection services (Swedish: anslutningstjänster) that Federation Registration Operators provide, and through which the OAuth 2.0 Clients, Authorization Servers and Protected Resources of Federation Members are registered under \[[SIB.Registration](#sib-registration)\].

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

This document holds the **BAS conformance tests**. The test cases in this document check the Intermediate against the requirements that BAS adds to the OIDF Sweden conformance tests. Within BAS, the Intermediate is a Federation Registration Entity provided by a Federation Registration Operator. It registers Entities after the checks of \[[SIB.Registration](#sib-registration)\], sets the verified per-Entity values in the Subordinate Statement, and states the checks performed in the `registration_policy` claim. Federation-wide rules are set by the Trust Anchor and are tested in [Testing of the BAS Trust Anchor](ta_overview.md).

The BAS conformance tests complement the OIDF Sweden conformance tests, [fre_oidf_sweden_test.md](fre_oidf_sweden_test.md). Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md).

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

    3.3. [**New Entities**](#new-entities)

    [FRE-BAS-008](#fre-bas-008) Registering a new Entity in BAS

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

<a name="keys-and-transport"></a>
### 2.1. Keys and Transport

<a name="fre-bas-001"></a>
#### FRE-BAS-001: Verifying the federation keys against the BAS rules

- **Depends on** \[[BAS.Rules](#bas-rules)\]: The key length requirements for Federation Entity Keys.
- **Purpose**: Assert that the FRE's Federation Entity Keys have adequate lengths, although \[[BAS.Security](#bas-security)\] does not apply to Federation Entity Keys.
- **Instructions**: Fetch the Entity Configuration of the FRE ([P-EC](procedures.md#p-ec)) and note the type and length of each key in its `jwks` claim. Compare them with any key length requirement stated in \[[BAS.Rules](#bas-rules)\].
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
- **Instructions**: Before the test, note the registered legal name and organization number of the organization behind each Entity. For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect its `metadata` claim, under the Entity Type of the Entity.
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
- **Instructions**: For REG-C1 and REG-PR1, fetch the Entity Configuration ([P-EC](procedures.md#p-ec)) and the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)). Identify the human-readable parameters the Entity declares with language tags (for example `client_name#sv`, `resource_name#sv`, `display_name#sv`). Inspect the `metadata` claim of the Subordinate Statement.
- **Expected result**:
  - For each such parameter, a corresponding parameter without a language tag, holding the Swedish value, MUST be assigned in the `metadata` claim.
  - If the display name has been verified and the Entity has not declared `display_name`, `display_name` MUST be assigned from `client_name` or `resource_name`.
  - A value without a language tag that the Entity declares itself is replaced by the assigned value.
- **References**: Section 2, 3 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="fre-bas-005"></a>
#### FRE-BAS-005: Verifying that the FRE sets no other values

- **Test data**: Subordinate Statements about REG-C1, REG-AS1 and REG-PR1.
- **Purpose**: Assert that the Federation Registration Entity only sets the values that \[[BAS.Metadata](#bas-metadata)\] assigns to it, since all other assigned or constrained values are controlled by the Federation Operator through the Trust Anchor.
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect its `metadata` and `metadata_policy` claims.
- **Expected result**:
  - The `metadata` claim is expected to hold only `organization_name` (with any `#sv` and `#en` values), `organization_identifier`, `display_name` where the display name has been verified, and values without a language tag for human-readable parameters.
  - The Subordinate Statements are not expected to contain a `metadata_policy` claim. If they do, every entry must be noted in the report.
  - Every other value must be noted in the report.
- **References**: Section 1, 2, 7 and 7.2 of \[[BAS.Metadata](#bas-metadata)\] and Section 2.5 and 3.1 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\]

<a name="fre-bas-006"></a>
#### FRE-BAS-006: Verifying the BAS registration policies

- **Test data**: REG-C1, REG-AS1 and REG-PR1.
- **Depends on** \[[BAS.Rules](#bas-rules)\]: Which registration checks are required, and their registration policy URIs.
- **Purpose**: Assert that the FRE states, for each Entity it publishes, the registration checks of \[[SIB.Registration](#sib-registration)\] that apply to it, so that peers and the Trust Anchor can rely on them. The generic form of the claim is tested in [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029).
- **Instructions**: For REG-C1, REG-AS1 and REG-PR1, fetch the Subordinate Statement from the FRE ([P-FETCH](procedures.md#p-fetch)) and inspect its `registration_policy` claim.
- **Expected result**:
  - `registration_policy` MUST be present and MUST be an array of URI strings.
  - It MUST list the registration policy URI of every check that BAS requires for the Entity, including `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection` for verification of organisational affiliation, which is always performed.
  - Any URI that is not defined in \[[SIB.Registration](#sib-registration)\] must be noted in the report.
- **References**: Section 2 of \[[OpenID.Federation.RegPolicy](#openid-federation-regpolicy)\], Section 3.2 of \[[OIDC.Sweden.Federation](#oidc-sweden-federation)\] and Section 1 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="resolved-metadata"></a>
### 3.2. Resolved Metadata

<a name="fre-bas-007"></a>
#### FRE-BAS-007: Verifying the Resolved Metadata of registered Entities

- **Test data**: All Entities registered by the FRE, and FED-TA with its metadata policy.
- **Purpose**: Assert that every Entity the FRE publishes meets the BAS requirements, so that the registration, seen as a black box, has admitted only Entities that meet them.
- **Instructions**: List all Entities registered by the FRE ([P-LIST](procedures.md#p-list)). For each listed Entity, build the Trust Chain to FED-TA and resolve the metadata ([P-CHAIN](procedures.md#p-chain)). The check is expected to be carried out with a tool, since the number of Entities can be large. Compare the Resolved Metadata with the tables in Section 3 to 6 of \[[BAS.Metadata](#bas-metadata)\].
- **Expected result**:
  - Every listed Entity MUST resolve without errors.
  - `organization_name` and `organization_identifier` MUST hold the values set by the FRE, also when the Entity declares other values. `organization_identifier` MUST have the format `urn:glue:iso6523:0007:<organization number>`, and is expected to match the organization in the national register of organizations.
  - `contacts` MUST be present and hold at least one email address.
  - Human-readable parameters MUST be present without a language tag, holding the Swedish value.
  - The protocol parameters are expected to meet Section 4 to 6 of \[[BAS.Metadata](#bas-metadata)\]. Every Entity that deviates must be noted in the report, together with whether the deviation is caused by the Entity, the FRE or the Trust Anchor policy.
- **References**: Section 2, 3, 4, 5, 6 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]

<a name="new-entities"></a>
### 3.3. New Entities

The registration itself is treated as a black box: the change is made by the Federation Registration Operator according to its own routine, and is a precondition of the test case. That the FRE publishes only Entities that meet the BAS requirements is asserted on all registered Entities in [FRE-BAS-007](#fre-bas-007).

<a name="fre-bas-008"></a>
#### FRE-BAS-008: Registering a new Entity in BAS

- **Test data**: TR1, added by the Federation Registration Operator.
- **Purpose**: Assert that a newly registered Entity gets a Subordinate Statement that meets the BAS requirements, in addition to the requirements tested in [FRE-OS-036](fre_oidf_sweden_test.md#fre-os-036).
- **Precondition**: TR1 has been added for a known organization. The change is made by the Federation Registration Operator according to its own routine, which is not tested, and the operator states the time it was made.
- **Instructions**: Fetch the Subordinate Statement about TR1 from the FRE ([P-FETCH](procedures.md#p-fetch)), and build the Trust Chain and resolve the metadata ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**:
  - The Subordinate Statement MUST meet the expected results of [FRE-BAS-003](#fre-bas-003), [FRE-BAS-004](#fre-bas-004), [FRE-BAS-005](#fre-bas-005) and [FRE-BAS-006](#fre-bas-006).
  - The Resolved Metadata MUST meet the expected result of [FRE-BAS-007](#fre-bas-007).
- **References**: Section 7.2 of \[[BAS.Metadata](#bas-metadata)\] and \[[SIB.Registration](#sib-registration)\]

<a name="changes-to-verified-values"></a>
### 3.4. Changes to Verified Values

<a name="fre-bas-012"></a>
#### FRE-BAS-012: Changing a verified value in the Entity Configuration

- **Test data**: TR8, and FED-TA.
- **Purpose**: Assert that an Entity cannot change a verified value by changing its own Entity Configuration.
- **Instructions**: For a registered test Entity, change `organization_name` and `organization_identifier` in the Entity's own Entity Configuration, without a new registration. Build the Trust Chain to FED-TA and resolve the metadata ([P-CHAIN](procedures.md#p-chain)).
- **Expected result**: The Resolved Metadata MUST still hold the values assigned or pinned by the FRE.
- **References**: Section 2 and 7.2 of \[[BAS.Metadata](#bas-metadata)\]
