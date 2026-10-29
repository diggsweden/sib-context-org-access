# Overview of Test Cases – Federation Registration Entity

This page lists all test cases for the BAS Federation Registration Entity: first the OIDF Sweden conformance tests, then the BAS conformance tests. Within each, the test cases are divided into standalone tests and tests that require a chain of test data. The purpose, instructions, expected results and test data of each test case are found in the test specification, which each test case ID links to. Every test case can be carried out on its own and in any order, using the [common procedures](procedures.md). Test cases marked *Depends on BAS.Rules* get their expected values or conditions from the BAS federation rules, which are in preparation, and are to be updated when the rules are published.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md) · [procedures](procedures.md)

| Specification | Standalone | Chain | Total |
| :--- | ---: | ---: | ---: |
| [OIDF Sweden Conformance](#oidf-sweden-conformance) | 17 | 22 | 39 |
| [BAS Conformance](#bas-conformance) | 2 | 7 | 9 |
| **Total** | **19** | **29** | **48** |

<a name="oidf-sweden-conformance"></a>
## 1. OIDF Sweden Conformance

Tests against OpenID Federation and the Swedish OpenID Federation profile. They contain no BAS-specific requirement. Test specification: [fre_oidf_sweden_test.md](fre_oidf_sweden_test.md).

### 1.1. Standalone tests (17)

Can be carried out against the FRE alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [FRE-OS-001](fre_oidf_sweden_test.md#fre-os-001) | Retrieving the Entity Configuration |
| [FRE-OS-002](fre_oidf_sweden_test.md#fre-os-002) | Verifying the signature of the Entity Configuration |
| [FRE-OS-003](fre_oidf_sweden_test.md#fre-os-003) | Verifying the claims of the Entity Configuration |
| [FRE-OS-004](fre_oidf_sweden_test.md#fre-os-004) | Verifying the validity period of the Entity Configuration *(Depends on BAS.Rules)* |
| [FRE-OS-005](fre_oidf_sweden_test.md#fre-os-005) | Verifying that the Entity Configuration is renewed before it expires |
| [FRE-OS-006](fre_oidf_sweden_test.md#fre-os-006) | Verifying the federation keys |
| [FRE-OS-007](fre_oidf_sweden_test.md#fre-os-007) | Verifying the fetch and list endpoints |
| [FRE-OS-008](fre_oidf_sweden_test.md#fre-os-008) | Verifying other endpoint parameters |
| [FRE-OS-009](fre_oidf_sweden_test.md#fre-os-009) | Verifying informational metadata |
| [FRE-OS-010](fre_oidf_sweden_test.md#fre-os-010) | Verifying client authentication metadata for federation endpoints |
| [FRE-OS-011](fre_oidf_sweden_test.md#fre-os-011) | Verifying that no protocol key parameters are used |
| [FRE-OS-012](fre_oidf_sweden_test.md#fre-os-012) | Fetch request for an unknown subject |
| [FRE-OS-013](fre_oidf_sweden_test.md#fre-os-013) | Fetch request with sub set to the Intermediate itself |
| [FRE-OS-014](fre_oidf_sweden_test.md#fre-os-014) | Fetch request without sub |
| [FRE-OS-015](fre_oidf_sweden_test.md#fre-os-015) | Listing with the intermediate and Trust Mark parameters |
| [FRE-OS-016](fre_oidf_sweden_test.md#fre-os-016) | Retrieving the historical keys *(Only if `federation_historical_keys_endpoint` is published)* |
| [FRE-OS-017](fre_oidf_sweden_test.md#fre-os-017) | Format of error responses |

### 1.2. Tests requiring a chain of test data (22)

Need test data from other Entities in the federation, such as the Trust Anchor, Entities registered by the FRE, or changes made by the Federation Registration Operator. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [FRE-OS-018](fre_oidf_sweden_test.md#fre-os-018) | Verifying the Trust Chain from the Intermediate to the Trust Anchor |
| [FRE-OS-019](fre_oidf_sweden_test.md#fre-os-019) | Verifying Trust Marks held by the Intermediate *(Only if the FRE holds Trust Marks; Depends on BAS.Rules)* |
| [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020) | Fetching a Subordinate Statement about a registered Entity |
| [FRE-OS-021](fre_oidf_sweden_test.md#fre-os-021) | Verifying the binding between the Subordinate Statement and the registered Entity |
| [FRE-OS-022](fre_oidf_sweden_test.md#fre-os-022) | Verifying the validity period of Subordinate Statements *(Depends on BAS.Rules)* |
| [FRE-OS-023](fre_oidf_sweden_test.md#fre-os-023) | Verifying the source_endpoint and ec_location claims |
| [FRE-OS-024](fre_oidf_sweden_test.md#fre-os-024) | Fetch request for an Entity registered under another Intermediate |
| [FRE-OS-025](fre_oidf_sweden_test.md#fre-os-025) | Fetch request with an unknown parameter |
| [FRE-OS-026](fre_oidf_sweden_test.md#fre-os-026) | Verifying that protocol parameters are not set by the Intermediate |
| [FRE-OS-027](fre_oidf_sweden_test.md#fre-os-027) | Verifying Entity Types and structure of assigned metadata |
| [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028) | Resolving registered Entities |
| [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029) | Verifying the registration_policy claim |
| [FRE-OS-030](fre_oidf_sweden_test.md#fre-os-030) | Verifying that registration policies satisfy the Trust Anchor's constraints *(Only if the Trust Anchor sets a `registration_policy` constraint)* |
| [FRE-OS-031](fre_oidf_sweden_test.md#fre-os-031) | Verifying the constraints claim *(Only if the FRE sets constraints)* |
| [FRE-OS-032](fre_oidf_sweden_test.md#fre-os-032) | Listing the registered Entities |
| [FRE-OS-033](fre_oidf_sweden_test.md#fre-os-033) | Verifying that only Leaf Entities are registered |
| [FRE-OS-034](fre_oidf_sweden_test.md#fre-os-034) | Listing with the entity_type parameter |
| [FRE-OS-035](fre_oidf_sweden_test.md#fre-os-035) | Client authentication at federation endpoints |
| [FRE-OS-036](fre_oidf_sweden_test.md#fre-os-036) | Registering a new Entity |
| [FRE-OS-038](fre_oidf_sweden_test.md#fre-os-038) | Key change at a registered Entity |
| [FRE-OS-039](fre_oidf_sweden_test.md#fre-os-039) | Removing a registered Entity |
| [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040) | Federation key rollover at the Intermediate *(Depends on BAS.Rules)* |

<a name="bas-conformance"></a>
## 2. BAS Conformance

Tests of the requirements that BAS adds: BAS Metadata Requirements, BAS Security Requirements, the BAS federation rules and SIB Registration. Test specification: [fre_bas_test.md](fre_bas_test.md).

### 2.1. Standalone tests (2)

Can be carried out against the FRE alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [FRE-BAS-001](fre_bas_test.md#fre-bas-001) | Verifying the federation keys against the BAS rules *(Depends on BAS.Rules)* |
| [FRE-BAS-002](fre_bas_test.md#fre-bas-002) | TLS configuration |

### 2.2. Tests requiring a chain of test data (7)

Need test data from other Entities in the federation, such as the Trust Anchor, Entities registered by the FRE, or changes made by the Federation Registration Operator. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [FRE-BAS-003](fre_bas_test.md#fre-bas-003) | Verifying organization parameters |
| [FRE-BAS-004](fre_bas_test.md#fre-bas-004) | Verifying language-tagged values |
| [FRE-BAS-005](fre_bas_test.md#fre-bas-005) | Verifying that the FRE sets no other values |
| [FRE-BAS-006](fre_bas_test.md#fre-bas-006) | Verifying the BAS registration policies *(Depends on BAS.Rules)* |
| [FRE-BAS-007](fre_bas_test.md#fre-bas-007) | Verifying the Resolved Metadata of registered Entities |
| [FRE-BAS-008](fre_bas_test.md#fre-bas-008) | Registering a new Entity in BAS |
| [FRE-BAS-012](fre_bas_test.md#fre-bas-012) | Changing a verified value in the Entity Configuration |
