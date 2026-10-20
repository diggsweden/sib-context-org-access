# Overview of Test Cases – Federation Resolver

This page lists all test cases for the BAS Federation Resolver: first the OIDF Sweden conformance tests, then the BAS conformance tests. Within each, the test cases are divided into standalone tests and tests that require a chain of test data. The purpose, instructions, expected results and test data of each test case are found in the test specification, which each test case ID links to. The OIDF Sweden conformance tests are carried out first. Test cases marked *Depends on BAS.Rules* get their expected values or conditions from the BAS federation rules, which are in preparation, and are to be updated when the rules are published.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

| Specification | Standalone | Chain | Total |
| :--- | ---: | ---: | ---: |
| [OIDF Sweden Conformance](#oidf-sweden-conformance) | 5 | 35 | 40 |
| [BAS Conformance](#bas-conformance) | 1 | 7 | 8 |
| **Total** | **6** | **42** | **48** |

<a name="oidf-sweden-conformance"></a>
## 1. OIDF Sweden Conformance

Tests against OpenID Federation and the Swedish OpenID Federation profile. They contain no BAS-specific requirement. Test specification: [resolver_oidf_sweden_test.md](resolver_oidf_sweden_test.md).

### 1.1. Standalone tests (5)

Can be carried out against the resolver alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [RES-OS-001](resolver_oidf_sweden_test.md#res-os-001) | Verifying the resolve endpoint |
| [RES-OS-002](resolver_oidf_sweden_test.md#res-os-002) | Request without sub |
| [RES-OS-003](resolver_oidf_sweden_test.md#res-os-003) | Request without trust_anchor |
| [RES-OS-004](resolver_oidf_sweden_test.md#res-os-004) | Unknown Trust Anchor |
| [RES-OS-005](resolver_oidf_sweden_test.md#res-os-005) | Subject that does not exist |

### 1.2. Tests requiring a chain of test data (35)

Need test data from other Entities in the federation, such as the Trust Anchor and the test Entities TE1 to TE17. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [RES-OS-006](resolver_oidf_sweden_test.md#res-os-006) | Verifying that the resolver is trusted by the Trust Anchor |
| [RES-OS-007](resolver_oidf_sweden_test.md#res-os-007) | Basic resolve request |
| [RES-OS-008](resolver_oidf_sweden_test.md#res-os-008) | Verifying the Trust Chain in the response |
| [RES-OS-009](resolver_oidf_sweden_test.md#res-os-009) | Verifying the Resolved Metadata |
| [RES-OS-010](resolver_oidf_sweden_test.md#res-os-010) | Verifying the validity of the resolve response |
| [RES-OS-011](resolver_oidf_sweden_test.md#res-os-011) | Verifying the Trust Marks in the response *(Only if Trust Marks are used; Depends on BAS.Rules)* |
| [RES-OS-012](resolver_oidf_sweden_test.md#res-os-012) | Trust Marks obtained by the resolver *(Only if Trust Marks are used in BAS; Depends on BAS.Rules)* |
| [RES-OS-013](resolver_oidf_sweden_test.md#res-os-013) | Verifying aud and the trust_chain header parameter |
| [RES-OS-014](resolver_oidf_sweden_test.md#res-os-014) | Resolving one Entity Type |
| [RES-OS-015](resolver_oidf_sweden_test.md#res-os-015) | Resolving several Entity Types |
| [RES-OS-016](resolver_oidf_sweden_test.md#res-os-016) | Resolving an Entity Type the subject does not have |
| [RES-OS-017](resolver_oidf_sweden_test.md#res-os-017) | Several trust_anchor parameters |
| [RES-OS-018](resolver_oidf_sweden_test.md#res-os-018) | Unknown request parameter |
| [RES-OS-019](resolver_oidf_sweden_test.md#res-os-019) | Resolving an Entity with a hosted Entity Configuration *(Only if Entity Configuration hosting is supported in the federation)* |
| [RES-OS-020](resolver_oidf_sweden_test.md#res-os-020) | Resolving an Intermediate |
| [RES-OS-021](resolver_oidf_sweden_test.md#res-os-021) | Resolving the Trust Anchor |
| [RES-OS-022](resolver_oidf_sweden_test.md#res-os-022) | Entity that is not registered |
| [RES-OS-023](resolver_oidf_sweden_test.md#res-os-023) | Expired Entity Configuration |
| [RES-OS-024](resolver_oidf_sweden_test.md#res-os-024) | Entity Configuration signed with a key that is not bound by the Superior |
| [RES-OS-025](resolver_oidf_sweden_test.md#res-os-025) | Metadata that does not comply with the policy |
| [RES-OS-026](resolver_oidf_sweden_test.md#res-os-026) | Unknown critical claim |
| [RES-OS-027](resolver_oidf_sweden_test.md#res-os-027) | Unknown critical policy operator |
| [RES-OS-028](resolver_oidf_sweden_test.md#res-os-028) | Constraint violation |
| [RES-OS-029](resolver_oidf_sweden_test.md#res-os-029) | Registration policy constraint violation *(Only if the Trust Anchor sets a `registration_policy` constraint)* |
| [RES-OS-030](resolver_oidf_sweden_test.md#res-os-030) | Expired Trust Mark *(Only if Trust Marks are used; Depends on BAS.Rules)* |
| [RES-OS-031](resolver_oidf_sweden_test.md#res-os-031) | Revoked Trust Mark *(Only if Trust Marks are used; Depends on BAS.Rules)* |
| [RES-OS-032](resolver_oidf_sweden_test.md#res-os-032) | Trust Mark from an issuer that is not accredited *(Only if Trust Marks are used; Depends on BAS.Rules)* |
| [RES-OS-033](resolver_oidf_sweden_test.md#res-os-033) | Verifying error responses |
| [RES-OS-034](resolver_oidf_sweden_test.md#res-os-034) | Propagation of changed metadata |
| [RES-OS-035](resolver_oidf_sweden_test.md#res-os-035) | Removed Entity |
| [RES-OS-036](resolver_oidf_sweden_test.md#res-os-036) | Newly registered Entity |
| [RES-OS-037](resolver_oidf_sweden_test.md#res-os-037) | Federation key rollover at the resolver |
| [RES-OS-038](resolver_oidf_sweden_test.md#res-os-038) | Large number of authority_hints and loops |
| [RES-OS-039](resolver_oidf_sweden_test.md#res-os-039) | Unauthenticated requests for Entities not previously resolved |
| [RES-OS-040](resolver_oidf_sweden_test.md#res-os-040) | Client authentication at the resolve endpoint *(Only if the resolver declares `federation_resolve_endpoint_auth_methods` with `private_key_jwt`)* |

<a name="bas-conformance"></a>
## 2. BAS Conformance

Tests of the requirements that BAS adds: BAS Metadata Requirements, BAS Security Requirements, the BAS federation rules and SIB Registration. Test specification: [resolver_bas_test.md](resolver_bas_test.md).

### 2.1. Standalone tests (1)

Can be carried out against the resolver alone, as soon as it is deployed.

| ID | Test case |
| :--- | :--- |
| [RES-BAS-001](resolver_bas_test.md#res-bas-001) | TLS configuration |

### 2.2. Tests requiring a chain of test data (7)

Need test data from other Entities in the federation, such as the Trust Anchor and the test Entities TE1 to TE17. Each test case states the data it needs in the test specification, and the test data is described in [test_data.md](test_data.md).

| ID | Test case |
| :--- | :--- |
| [RES-BAS-002](resolver_bas_test.md#res-bas-002) | Resolved Metadata of an Authorization Server |
| [RES-BAS-003](resolver_bas_test.md#res-bas-003) | Resolved Metadata of a Client |
| [RES-BAS-004](resolver_bas_test.md#res-bas-004) | Organization parameters in Resolved Metadata |
| [RES-BAS-005](resolver_bas_test.md#res-bas-005) | Entities that fail the BAS policy |
| [RES-BAS-006](resolver_bas_test.md#res-bas-006) | Entity registered without verification of organisational affiliation *(Only if the Trust Anchor sets a `registration_policy` constraint)* |
| [RES-BAS-007](resolver_bas_test.md#res-bas-007) | Entities that break requirements the policy cannot express |
| [RES-BAS-008](resolver_bas_test.md#res-bas-008) | Propagation of a new protocol key |
