# Overview of Test Cases – Trust Anchor

This page lists all test cases for the BAS Trust Anchor: first the OIDF Sweden conformance tests, then the BAS conformance tests. Within each, the test cases are divided into standalone tests and tests that require a chain of test data. The purpose, instructions, expected results and test data of each test case are found in the test specification, which each test case ID links to. The OIDF Sweden conformance tests are carried out first. Test cases marked *Depends on BAS.Rules* get their expected values or conditions from the BAS federation rules, which are in preparation, and are to be updated when the rules are published.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

| Specification | Standalone | Chain | Total |
| :--- | ---: | ---: | ---: |
| [OIDF Sweden Conformance](#oidf-sweden-conformance) | 26 | 20 | 46 |
| [BAS Conformance](#bas-conformance) | 4 | 6 | 10 |
| **Total** | **30** | **26** | **56** |

<a name="oidf-sweden-conformance"></a>
## 1. OIDF Sweden Conformance

Tests against OpenID Federation and the Swedish OpenID Federation profile. They contain no BAS-specific requirement. Test specification: [ta_oidf_sweden_test.md](ta_oidf_sweden_test.md).

### 1.1. Standalone tests (26)

Can be carried out against the TA alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [TA-OS-001](ta_oidf_sweden_test.md#ta-os-001) | Retrieving the Entity Configuration |
| [TA-OS-002](ta_oidf_sweden_test.md#ta-os-002) | Verifying the signature of the Entity Configuration |
| [TA-OS-003](ta_oidf_sweden_test.md#ta-os-003) | Verifying the claims of the Entity Configuration |
| [TA-OS-004](ta_oidf_sweden_test.md#ta-os-004) | Verifying the validity period of the Entity Configuration *(Depends on BAS.Rules)* |
| [TA-OS-005](ta_oidf_sweden_test.md#ta-os-005) | Verifying that the Entity Configuration is renewed before it expires |
| [TA-OS-006](ta_oidf_sweden_test.md#ta-os-006) | Verifying the federation keys |
| [TA-OS-007](ta_oidf_sweden_test.md#ta-os-007) | Comparing the keys with the keys distributed out-of-band |
| [TA-OS-008](ta_oidf_sweden_test.md#ta-os-008) | Verifying the trust_mark_issuers claim *(Only if the federation uses Trust Marks; Depends on BAS.Rules)* |
| [TA-OS-009](ta_oidf_sweden_test.md#ta-os-009) | Verifying the trust_mark_owners claim *(Only if Trust Mark delegation is used; Depends on BAS.Rules)* |
| [TA-OS-010](ta_oidf_sweden_test.md#ta-os-010) | Verifying that the Trust Anchor does not act as Trust Mark Issuer |
| [TA-OS-011](ta_oidf_sweden_test.md#ta-os-011) | Verifying the fetch and list endpoints |
| [TA-OS-012](ta_oidf_sweden_test.md#ta-os-012) | Verifying the availability of a Federation Resolver |
| [TA-OS-013](ta_oidf_sweden_test.md#ta-os-013) | Verifying other endpoint parameters |
| [TA-OS-014](ta_oidf_sweden_test.md#ta-os-014) | Verifying informational metadata |
| [TA-OS-015](ta_oidf_sweden_test.md#ta-os-015) | Verifying client authentication metadata for federation endpoints |
| [TA-OS-016](ta_oidf_sweden_test.md#ta-os-016) | Verifying that no protocol key parameters are used |
| [TA-OS-017](ta_oidf_sweden_test.md#ta-os-017) | Fetch request for an unknown subject |
| [TA-OS-018](ta_oidf_sweden_test.md#ta-os-018) | Fetch request with sub set to the Trust Anchor itself |
| [TA-OS-019](ta_oidf_sweden_test.md#ta-os-019) | Fetch request without sub |
| [TA-OS-020](ta_oidf_sweden_test.md#ta-os-020) | Listing with Trust Mark parameters |
| [TA-OS-021](ta_oidf_sweden_test.md#ta-os-021) | Retrieving the historical keys *(Only if `federation_historical_keys_endpoint` is published)* |
| [TA-OS-022](ta_oidf_sweden_test.md#ta-os-022) | Unauthenticated requests |
| [TA-OS-023](ta_oidf_sweden_test.md#ta-os-023) | Format of error responses |
| [TA-OS-024](ta_oidf_sweden_test.md#ta-os-024) | Reviewing the federation rules *(Depends on BAS.Rules)* |
| [TA-OS-025](ta_oidf_sweden_test.md#ta-os-025) | Reviewing the Trust Mark Policy *(Only if the federation uses Trust Marks; Depends on BAS.Rules)* |
| [TA-OS-026](ta_oidf_sweden_test.md#ta-os-026) | Reviewing algorithm and interoperability rules *(Depends on BAS.Rules)* |

### 1.2. Tests requiring a chain of test data (20)

Need test data from other Entities in the federation, such as registered Federation Registration Entities, Leaf Entities registered under them, or key changes coordinated with other operators. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [TA-OS-027](ta_oidf_sweden_test.md#ta-os-027) | Verifying that the Trust Anchor is not chained directly to another Trust Anchor |
| [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028) | Fetching a Subordinate Statement about an Immediate Subordinate |
| [TA-OS-029](ta_oidf_sweden_test.md#ta-os-029) | Verifying the binding between the Subordinate Statement and the Subordinate |
| [TA-OS-030](ta_oidf_sweden_test.md#ta-os-030) | Verifying the validity period of Subordinate Statements *(Depends on BAS.Rules)* |
| [TA-OS-031](ta_oidf_sweden_test.md#ta-os-031) | Verifying the source_endpoint and ec_location claims |
| [TA-OS-032](ta_oidf_sweden_test.md#ta-os-032) | Fetch request for a Leaf Entity registered under an Intermediate |
| [TA-OS-033](ta_oidf_sweden_test.md#ta-os-033) | Fetch request with an unknown parameter |
| [TA-OS-034](ta_oidf_sweden_test.md#ta-os-034) | Verifying that the metadata policy is well-formed |
| [TA-OS-035](ta_oidf_sweden_test.md#ta-os-035) | Verifying that the metadata policy constrains rather than introduces |
| [TA-OS-036](ta_oidf_sweden_test.md#ta-os-036) | Verifying the metadata claim of Subordinate Statements |
| [TA-OS-037](ta_oidf_sweden_test.md#ta-os-037) | Verifying the constraints claim |
| [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038) | Resolving registered Entities through the Trust Anchor |
| [TA-OS-039](ta_oidf_sweden_test.md#ta-os-039) | Listing the Immediate Subordinates |
| [TA-OS-040](ta_oidf_sweden_test.md#ta-os-040) | Verifying that no Federation Protocol Entity is chained directly under the Trust Anchor |
| [TA-OS-041](ta_oidf_sweden_test.md#ta-os-041) | Listing with the entity_type parameter |
| [TA-OS-042](ta_oidf_sweden_test.md#ta-os-042) | Listing with the intermediate parameter |
| [TA-OS-043](ta_oidf_sweden_test.md#ta-os-043) | Authenticated requests *(Only if the TA declares `private_key_jwt` for any endpoint)* |
| [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044) | Federation key rollover *(Depends on BAS.Rules)* |
| [TA-OS-045](ta_oidf_sweden_test.md#ta-os-045) | Removing an Immediate Subordinate |
| [TA-OS-046](ta_oidf_sweden_test.md#ta-os-046) | Key change at an Immediate Subordinate |

<a name="bas-conformance"></a>
## 2. BAS Conformance

Tests of the requirements that BAS adds: BAS Metadata Requirements, BAS Security Requirements, the BAS federation rules and SIB Registration. Test specification: [ta_bas_test.md](ta_bas_test.md).

### 2.1. Standalone tests (4)

Can be carried out against the TA alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [TA-BAS-001](ta_bas_test.md#ta-bas-001) | Verifying the federation keys against the BAS rules *(Depends on BAS.Rules)* |
| [TA-BAS-002](ta_bas_test.md#ta-bas-002) | TLS configuration |
| [TA-BAS-003](ta_bas_test.md#ta-bas-003) | Reviewing how BAS handles algorithms and client authentication *(Depends on BAS.Rules)* |
| [TA-BAS-004](ta_bas_test.md#ta-bas-004) | Reviewing what the BAS specifications defer to the federation rules *(Depends on BAS.Rules)* |

### 2.2. Tests requiring a chain of test data (6)

Need test data from other Entities in the federation, such as registered Federation Registration Entities, Leaf Entities registered under them, or key changes coordinated with other operators. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [TA-BAS-005](ta_bas_test.md#ta-bas-005) | Verifying that the metadata policy matches the published BAS policy *(Depends on BAS.Rules)* |
| [TA-BAS-006](ta_bas_test.md#ta-bas-006) | Verifying client authentication and algorithm constraints in the policy |
| [TA-BAS-007](ta_bas_test.md#ta-bas-007) | Verifying the values that the policy assigns |
| [TA-BAS-008](ta_bas_test.md#ta-bas-008) | Verifying the Entity Types admitted in BAS |
| [TA-BAS-009](ta_bas_test.md#ta-bas-009) | Verifying the registration policy constraint *(Only if the Trust Anchor sets a `registration_policy` constraint; Depends on BAS.Rules)* |
| [TA-BAS-010](ta_bas_test.md#ta-bas-010) | Verifying the Resolved Metadata of registered Entities |
