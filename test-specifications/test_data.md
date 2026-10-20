# Test Data

This page describes the test data that the tests requiring a chain of test data use: the federation Entities, the registered Entities and the test Entities. Each test case in the test specifications names the data it needs under "Test data", using the IDs on this page. The last column lists those test cases.

Version: 0.1.0 (draft)

Overviews: [start](overview.md) · [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md) · [test data](test_data.md)

## 1. The Test Chain

All test data is set up in the BAS Sandbox. The chain has three levels:

```
FED-TA (Trust Anchor)
├── FED-FRE1 (Federation Registration Entity)
│   ├── REG-C1, REG-AS1, REG-PR1   stable, valid Entities
│   ├── TR1 … TR8                   Entities for the registration tests
│   └── TE1 … TE17                  Entities for the resolver tests
├── FED-FRE2 (Federation Registration Entity of another operator)
│   └── REG-X
└── FED-IMT (temporary test Intermediate)
```

The test Entities TE1 to TE17 can be registered under FED-FRE1 or FED-FRE2. Several of them break a rule on purpose, and need help from the Federation Operator or a Federation Registration Operator to be set up, as stated in the "Set up by" column. A Federation Registration Entity is expected to reject some of these Entities at registration, so they are registered through a procedure agreed with the operator for testing.

## 2. Federation Entities

| ID | Description | Set up by | Used in |
| :--- | :--- | :--- | :--- |
| **FED-TA** | The BAS Trust Anchor in the Sandbox, with its Federation Entity Keys distributed out-of-band. | Federation Operator | TA OIDF Sweden: [TA-OS-027](ta_oidf_sweden_test.md#ta-os-027), [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028), [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044)<br/>FRE OIDF Sweden: [FRE-OS-018](fre_oidf_sweden_test.md#fre-os-018), [FRE-OS-019](fre_oidf_sweden_test.md#fre-os-019), [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028), [FRE-OS-030](fre_oidf_sweden_test.md#fre-os-030), [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040)<br/>FRE BAS: [FRE-BAS-007](fre_bas_test.md#fre-bas-007), [FRE-BAS-012](fre_bas_test.md#fre-bas-012)<br/>Resolver OIDF Sweden: [RES-OS-006](resolver_oidf_sweden_test.md#res-os-006), [RES-OS-008](resolver_oidf_sweden_test.md#res-os-008), [RES-OS-011](resolver_oidf_sweden_test.md#res-os-011), [RES-OS-021](resolver_oidf_sweden_test.md#res-os-021) |
| **FED-FRE1** | A Federation Registration Entity registered under FED-TA. It registers REG-C1, REG-AS1, REG-PR1 and the test Entities TR1 to TR8, and is the FRE under test in the FRE test specifications. | Federation Registration Operator 1 | TA OIDF Sweden: [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028), [TA-OS-029](ta_oidf_sweden_test.md#ta-os-029), [TA-OS-030](ta_oidf_sweden_test.md#ta-os-030), [TA-OS-031](ta_oidf_sweden_test.md#ta-os-031), [TA-OS-032](ta_oidf_sweden_test.md#ta-os-032), [TA-OS-033](ta_oidf_sweden_test.md#ta-os-033), [TA-OS-034](ta_oidf_sweden_test.md#ta-os-034), [TA-OS-035](ta_oidf_sweden_test.md#ta-os-035), [TA-OS-036](ta_oidf_sweden_test.md#ta-os-036), [TA-OS-037](ta_oidf_sweden_test.md#ta-os-037), [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), [TA-OS-039](ta_oidf_sweden_test.md#ta-os-039), [TA-OS-040](ta_oidf_sweden_test.md#ta-os-040), [TA-OS-041](ta_oidf_sweden_test.md#ta-os-041), [TA-OS-042](ta_oidf_sweden_test.md#ta-os-042)<br/>TA BAS: [TA-BAS-005](ta_bas_test.md#ta-bas-005), [TA-BAS-006](ta_bas_test.md#ta-bas-006), [TA-BAS-007](ta_bas_test.md#ta-bas-007), [TA-BAS-008](ta_bas_test.md#ta-bas-008), [TA-BAS-009](ta_bas_test.md#ta-bas-009)<br/>Resolver OIDF Sweden: [RES-OS-020](resolver_oidf_sweden_test.md#res-os-020) |
| **FED-FRE2** | A second Federation Registration Entity under FED-TA, provided by another Federation Registration Operator. It registers REG-X. | Federation Registration Operator 2 | TA OIDF Sweden: [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028), [TA-OS-029](ta_oidf_sweden_test.md#ta-os-029), [TA-OS-030](ta_oidf_sweden_test.md#ta-os-030), [TA-OS-031](ta_oidf_sweden_test.md#ta-os-031), [TA-OS-034](ta_oidf_sweden_test.md#ta-os-034), [TA-OS-035](ta_oidf_sweden_test.md#ta-os-035), [TA-OS-036](ta_oidf_sweden_test.md#ta-os-036), [TA-OS-037](ta_oidf_sweden_test.md#ta-os-037), [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), [TA-OS-039](ta_oidf_sweden_test.md#ta-os-039), [TA-OS-040](ta_oidf_sweden_test.md#ta-os-040), [TA-OS-041](ta_oidf_sweden_test.md#ta-os-041), [TA-OS-042](ta_oidf_sweden_test.md#ta-os-042)<br/>TA BAS: [TA-BAS-005](ta_bas_test.md#ta-bas-005), [TA-BAS-006](ta_bas_test.md#ta-bas-006), [TA-BAS-007](ta_bas_test.md#ta-bas-007), [TA-BAS-008](ta_bas_test.md#ta-bas-008), [TA-BAS-009](ta_bas_test.md#ta-bas-009)<br/>FRE OIDF Sweden: [FRE-OS-024](fre_oidf_sweden_test.md#fre-os-024) |
| **FED-IMT** | A temporary test Intermediate that the Federation Operator adds under FED-TA, rolls over the keys of, and removes. | Federation Operator, with the operator of FED-IMT | TA OIDF Sweden: [TA-OS-045](ta_oidf_sweden_test.md#ta-os-045), [TA-OS-046](ta_oidf_sweden_test.md#ta-os-046) |
| **FED-TMI** | A Trust Mark Issuer listed in the `trust_mark_issuers` claim of FED-TA. Only needed if Trust Marks are used in BAS. | Trust Mark Issuer | FRE OIDF Sweden: [FRE-OS-019](fre_oidf_sweden_test.md#fre-os-019)<br/>Resolver OIDF Sweden: [RES-OS-011](resolver_oidf_sweden_test.md#res-os-011), [RES-OS-012](resolver_oidf_sweden_test.md#res-os-012) |

## 3. Registered Entities

Stable, valid Entities that stay registered during all tests. They are used by the Trust Anchor and Federation Registration Entity tests.

| ID | Description | Set up by | Used in |
| :--- | :--- | :--- | :--- |
| **REG-C1** | A valid Client under FED-FRE1. Publishes its keys with `jwks`, declares `client_name#sv` and `client_name#en`, and holds Federation Entity Keys that the tester can sign with. | Tester, registered by FED-FRE1 | TA OIDF Sweden: [TA-OS-032](ta_oidf_sweden_test.md#ta-os-032), [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), [TA-OS-043](ta_oidf_sweden_test.md#ta-os-043), [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044)<br/>TA BAS: [TA-BAS-010](ta_bas_test.md#ta-bas-010)<br/>FRE OIDF Sweden: [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020), [FRE-OS-021](fre_oidf_sweden_test.md#fre-os-021), [FRE-OS-022](fre_oidf_sweden_test.md#fre-os-022), [FRE-OS-023](fre_oidf_sweden_test.md#fre-os-023), [FRE-OS-025](fre_oidf_sweden_test.md#fre-os-025), [FRE-OS-026](fre_oidf_sweden_test.md#fre-os-026), [FRE-OS-027](fre_oidf_sweden_test.md#fre-os-027), [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028), [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029), [FRE-OS-030](fre_oidf_sweden_test.md#fre-os-030), [FRE-OS-031](fre_oidf_sweden_test.md#fre-os-031), [FRE-OS-032](fre_oidf_sweden_test.md#fre-os-032), [FRE-OS-033](fre_oidf_sweden_test.md#fre-os-033), [FRE-OS-034](fre_oidf_sweden_test.md#fre-os-034), [FRE-OS-035](fre_oidf_sweden_test.md#fre-os-035), [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040)<br/>FRE BAS: [FRE-BAS-003](fre_bas_test.md#fre-bas-003), [FRE-BAS-004](fre_bas_test.md#fre-bas-004), [FRE-BAS-005](fre_bas_test.md#fre-bas-005), [FRE-BAS-006](fre_bas_test.md#fre-bas-006), [FRE-BAS-007](fre_bas_test.md#fre-bas-007)<br/>Resolver OIDF Sweden: [RES-OS-040](resolver_oidf_sweden_test.md#res-os-040) |
| **REG-AS1** | A valid Authorization Server under FED-FRE1. | Tester, registered by FED-FRE1 | TA OIDF Sweden: [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044)<br/>TA BAS: [TA-BAS-010](ta_bas_test.md#ta-bas-010)<br/>FRE OIDF Sweden: [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020), [FRE-OS-021](fre_oidf_sweden_test.md#fre-os-021), [FRE-OS-022](fre_oidf_sweden_test.md#fre-os-022), [FRE-OS-023](fre_oidf_sweden_test.md#fre-os-023), [FRE-OS-026](fre_oidf_sweden_test.md#fre-os-026), [FRE-OS-027](fre_oidf_sweden_test.md#fre-os-027), [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028), [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029), [FRE-OS-030](fre_oidf_sweden_test.md#fre-os-030), [FRE-OS-031](fre_oidf_sweden_test.md#fre-os-031), [FRE-OS-032](fre_oidf_sweden_test.md#fre-os-032), [FRE-OS-033](fre_oidf_sweden_test.md#fre-os-033), [FRE-OS-034](fre_oidf_sweden_test.md#fre-os-034), [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040)<br/>FRE BAS: [FRE-BAS-003](fre_bas_test.md#fre-bas-003), [FRE-BAS-005](fre_bas_test.md#fre-bas-005), [FRE-BAS-006](fre_bas_test.md#fre-bas-006), [FRE-BAS-007](fre_bas_test.md#fre-bas-007) |
| **REG-PR1** | A valid Protected Resource under FED-FRE1, declaring `resource_name#sv` and `resource_name#en`. If Entity Configuration hosting is used, its Entity Configuration is hosted by FED-FRE1. | Tester, registered by FED-FRE1 | TA OIDF Sweden: [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038), [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044)<br/>TA BAS: [TA-BAS-010](ta_bas_test.md#ta-bas-010)<br/>FRE OIDF Sweden: [FRE-OS-020](fre_oidf_sweden_test.md#fre-os-020), [FRE-OS-021](fre_oidf_sweden_test.md#fre-os-021), [FRE-OS-022](fre_oidf_sweden_test.md#fre-os-022), [FRE-OS-023](fre_oidf_sweden_test.md#fre-os-023), [FRE-OS-026](fre_oidf_sweden_test.md#fre-os-026), [FRE-OS-027](fre_oidf_sweden_test.md#fre-os-027), [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028), [FRE-OS-029](fre_oidf_sweden_test.md#fre-os-029), [FRE-OS-030](fre_oidf_sweden_test.md#fre-os-030), [FRE-OS-031](fre_oidf_sweden_test.md#fre-os-031), [FRE-OS-032](fre_oidf_sweden_test.md#fre-os-032), [FRE-OS-033](fre_oidf_sweden_test.md#fre-os-033), [FRE-OS-034](fre_oidf_sweden_test.md#fre-os-034), [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040)<br/>FRE BAS: [FRE-BAS-003](fre_bas_test.md#fre-bas-003), [FRE-BAS-004](fre_bas_test.md#fre-bas-004), [FRE-BAS-005](fre_bas_test.md#fre-bas-005), [FRE-BAS-006](fre_bas_test.md#fre-bas-006), [FRE-BAS-007](fre_bas_test.md#fre-bas-007) |
| **REG-X** | A valid Entity of any Entity Type under FED-FRE2. | Tester, registered by FED-FRE2 | TA OIDF Sweden: [TA-OS-038](ta_oidf_sweden_test.md#ta-os-038)<br/>FRE OIDF Sweden: [FRE-OS-024](fre_oidf_sweden_test.md#fre-os-024) |

## 4. Test Entities for the Registration Tests

Entities that the tester submits to FED-FRE1 using its registration procedure, to test how it registers, rejects, changes and removes Entities.

| ID | Description | Set up by | Used in |
| :--- | :--- | :--- | :--- |
| **TR1** | A new, valid Entity that the tester registers during the test, used to check that registration works and that the resolver finds new Entities. | Tester | FRE OIDF Sweden: [FRE-OS-036](fre_oidf_sweden_test.md#fre-os-036)<br/>FRE BAS: [FRE-BAS-008](fre_bas_test.md#fre-bas-008)<br/>Resolver OIDF Sweden: [RES-OS-036](resolver_oidf_sweden_test.md#res-os-036) |
| **TR2** | An Entity whose Entity Configuration declares both a protocol Entity Type and `federation_entity`. Expected to be rejected. | Tester | FRE OIDF Sweden: [FRE-OS-037](fre_oidf_sweden_test.md#fre-os-037) |
| **TR3** | A registered Entity that carries out a key rollover of its Federation Entity Keys. | Tester | FRE OIDF Sweden: [FRE-OS-038](fre_oidf_sweden_test.md#fre-os-038) |
| **TR4** | A registered Entity that is removed during the test. | Tester | FRE OIDF Sweden: [FRE-OS-039](fre_oidf_sweden_test.md#fre-os-039) |
| **TR5** | A set of Entities whose metadata fails the BAS policy, for example a Client without `contacts`, a Client whose `grant_types` lacks `client_credentials`, and a Client with `token_endpoint_auth_method` set to `client_secret_basic`. Expected to be rejected. | Tester | FRE BAS: [FRE-BAS-009](fre_bas_test.md#fre-bas-009) |
| **TR6** | A set of Entities that break BAS requirements the policy cannot express, such as a Client with both `jwks` and `jwks_uri`, or an Authorization Server whose `issuer` differs from its Entity Identifier. Expected to be rejected. | Tester | FRE BAS: [FRE-BAS-010](fre_bas_test.md#fre-bas-010) |
| **TR7** | A registration on behalf of an organization the submitter does not represent. Expected to be rejected. | Tester | FRE BAS: [FRE-BAS-011](fre_bas_test.md#fre-bas-011) |
| **TR8** | A registered Entity that changes a verified value, such as `organization_name`, in its own Entity Configuration. | Tester | FRE BAS: [FRE-BAS-012](fre_bas_test.md#fre-bas-012) |

## 5. Test Entities for the Resolver Tests

The detailed set-up of TE1 to TE17 is found in Section 1.3 of [resolver_oidf_sweden_test.md](resolver_oidf_sweden_test.md#test-entities), and the BAS set-up of TE1, TE2, TE8a to TE8c and TE17 in Section 1.3 of [resolver_bas_test.md](resolver_bas_test.md#test-entities).

| ID | Description | Set up by | Used in |
| :--- | :--- | :--- | :--- |
| **TE1** | A valid Authorization Server. For BAS, it also declares values outside what BAS permits, so that the policy filtering can be seen. Holds a Trust Mark if Trust Marks are used. | Tester | Resolver OIDF Sweden: [RES-OS-007](resolver_oidf_sweden_test.md#res-os-007), [RES-OS-008](resolver_oidf_sweden_test.md#res-os-008), [RES-OS-009](resolver_oidf_sweden_test.md#res-os-009), [RES-OS-010](resolver_oidf_sweden_test.md#res-os-010), [RES-OS-011](resolver_oidf_sweden_test.md#res-os-011), [RES-OS-012](resolver_oidf_sweden_test.md#res-os-012), [RES-OS-013](resolver_oidf_sweden_test.md#res-os-013), [RES-OS-016](resolver_oidf_sweden_test.md#res-os-016), [RES-OS-017](resolver_oidf_sweden_test.md#res-os-017), [RES-OS-018](resolver_oidf_sweden_test.md#res-os-018), [RES-OS-037](resolver_oidf_sweden_test.md#res-os-037)<br/>Resolver BAS: [RES-BAS-002](resolver_bas_test.md#res-bas-002), [RES-BAS-004](resolver_bas_test.md#res-bas-004) |
| **TE2** | A valid Client with `jwks`. Its Entity Configuration is changed and it is removed during the tests. | Tester | Resolver OIDF Sweden: [RES-OS-009](resolver_oidf_sweden_test.md#res-os-009), [RES-OS-012](resolver_oidf_sweden_test.md#res-os-012), [RES-OS-034](resolver_oidf_sweden_test.md#res-os-034), [RES-OS-035](resolver_oidf_sweden_test.md#res-os-035)<br/>Resolver BAS: [RES-BAS-003](resolver_bas_test.md#res-bas-003), [RES-BAS-004](resolver_bas_test.md#res-bas-004), [RES-BAS-008](resolver_bas_test.md#res-bas-008) |
| **TE3** | A valid Entity with both `oauth_client` and `oauth_resource`. | Tester | Resolver OIDF Sweden: [RES-OS-014](resolver_oidf_sweden_test.md#res-os-014), [RES-OS-015](resolver_oidf_sweden_test.md#res-os-015) |
| **TE4** | An Entity whose Entity Configuration is hosted by its Intermediate. Only if hosting is used. | Tester and the Federation Registration Operator | Resolver OIDF Sweden: [RES-OS-019](resolver_oidf_sweden_test.md#res-os-019) |
| **TE5** | An Entity that points at an Intermediate without being registered. | Tester | Resolver OIDF Sweden: [RES-OS-022](resolver_oidf_sweden_test.md#res-os-022) |
| **TE6** | A registered Entity whose Entity Configuration has expired. | Tester | Resolver OIDF Sweden: [RES-OS-023](resolver_oidf_sweden_test.md#res-os-023) |
| **TE7** | A registered Entity whose Entity Configuration is signed with a key not bound by its Superior. | Tester | Resolver OIDF Sweden: [RES-OS-024](resolver_oidf_sweden_test.md#res-os-024) |
| **TE8** | A registered Entity that fails the Trust Anchor metadata policy. | Federation Registration Operator | Resolver OIDF Sweden: [RES-OS-025](resolver_oidf_sweden_test.md#res-os-025) |
| **TE8a** | A registered Client without `contacts`. | Federation Registration Operator | Resolver BAS: [RES-BAS-005](resolver_bas_test.md#res-bas-005) |
| **TE8b** | A registered Client whose `grant_types` lacks `client_credentials`. | Federation Registration Operator | Resolver BAS: [RES-BAS-005](resolver_bas_test.md#res-bas-005) |
| **TE8c** | A registered Authorization Server whose `token_endpoint_auth_signing_alg_values_supported` lacks `ES256`. | Federation Registration Operator | Resolver BAS: [RES-BAS-005](resolver_bas_test.md#res-bas-005) |
| **TE9** | A registered Entity holding an expired Trust Mark. Only if Trust Marks are used. | Trust Mark Issuer | Resolver OIDF Sweden: [RES-OS-030](resolver_oidf_sweden_test.md#res-os-030) |
| **TE10** | A registered Entity holding a revoked Trust Mark. Only if Trust Marks are used. | Trust Mark Issuer | Resolver OIDF Sweden: [RES-OS-031](resolver_oidf_sweden_test.md#res-os-031) |
| **TE11** | A registered Entity holding a Trust Mark from an issuer that is not accredited. Only if Trust Marks are used. | Tester | Resolver OIDF Sweden: [RES-OS-032](resolver_oidf_sweden_test.md#res-os-032) |
| **TE12** | A registered Entity whose Entity Configuration lists an unknown claim in `crit`. | Tester | Resolver OIDF Sweden: [RES-OS-026](resolver_oidf_sweden_test.md#res-os-026) |
| **TE13** | A registered Entity whose Subordinate Statement uses an unknown operator listed in `metadata_policy_crit`. | Federation Registration Operator | Resolver OIDF Sweden: [RES-OS-027](resolver_oidf_sweden_test.md#res-os-027) |
| **TE14** | A registered Entity whose Trust Chain breaks a constraint. | Federation Operator or Federation Registration Operator | Resolver OIDF Sweden: [RES-OS-028](resolver_oidf_sweden_test.md#res-os-028) |
| **TE15** | A registered Entity whose Subordinate Statement lacks the policy URI for verification of organisational affiliation. Only if FED-TA sets a `registration_policy` constraint. | Federation Registration Operator | Resolver OIDF Sweden: [RES-OS-029](resolver_oidf_sweden_test.md#res-os-029)<br/>Resolver BAS: [RES-BAS-006](resolver_bas_test.md#res-bas-006) |
| **TE16** | Entities whose `authority_hints` hold many non-existent Intermediates, or form a loop. | Tester | Resolver OIDF Sweden: [RES-OS-038](resolver_oidf_sweden_test.md#res-os-038) |
| **TE17** | Registered Entities that break BAS requirements the policy cannot express. | Federation Registration Operator | Resolver BAS: [RES-BAS-007](resolver_bas_test.md#res-bas-007) |

## 6. Other Test Data

- **Out-of-band Trust Anchor keys**: the keys of FED-TA as distributed by the Federation Operator.
- **Federation rules**: \[BAS.Rules\], BAS Metadata Requirements and BAS Security Requirements, and \[SIB.Registration\] for the registration checks.
- **Registered organization details**: the legal name and organization number behind each registered Entity.
- **Reference implementation**: an independent OpenID Federation implementation used to build Trust Chains and compute Resolved Metadata.
- **TLS analysis tool**: used for the TLS test cases.

## 7. Order and Reuse

- REG-C1, REG-AS1, REG-PR1 and REG-X are not changed by any test case, and can be used throughout.
- TE2 is changed and removed by the resolver tests on freshness and protocol keys. Run those test cases last, or re-register TE2 afterwards.
- TR1 is registered once and is used both by the registration tests and by the resolver test for newly registered Entities.
- FED-IMT, TR3, TR4 and TR8 change the federation. Remove them, or restore them, when the tests are completed.
