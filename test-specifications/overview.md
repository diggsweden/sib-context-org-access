# BAS Federation Infrastructure – Test Case Overview

Test cases for the Trust Anchor, the Federation Registration Entities (anslutningstjänster) and the Federation Resolver of Federationskontext BAS.

Version: 0.1.0 (draft)

| Entity | Specification | Standalone | Chain | Total |
| :--- | :--- | ---: | ---: | ---: |
| [Trust Anchor](ta_overview.md) | [OIDF Sweden](ta_oidf_sweden_test.md) | 26 | 20 | 46 |
| [Trust Anchor](ta_overview.md) | [BAS](ta_bas_test.md) | 4 | 6 | 10 |
| [Federation Registration Entity](fre_overview.md) | [OIDF Sweden](fre_oidf_sweden_test.md) | 17 | 23 | 40 |
| [Federation Registration Entity](fre_overview.md) | [BAS](fre_bas_test.md) | 2 | 10 | 12 |
| [Federation Resolver](resolver_overview.md) | [OIDF Sweden](resolver_oidf_sweden_test.md) | 5 | 35 | 40 |
| [Federation Resolver](resolver_overview.md) | [BAS](resolver_bas_test.md) | 1 | 7 | 8 |
| | **Total** | **55** | **101** | **156** |

## How the Test Cases Are Divided

- **OIDF Sweden**: OpenID Federation and the Swedish OpenID Federation profile. No BAS-specific requirements.
- **BAS**: the requirements BAS adds (BAS Metadata, BAS Security, BAS.Rules, SIB Registration).
- **Standalone**: can be run against the Entity alone, as soon as it is deployed.
- **Chain**: needs test data from other Entities, such as the Trust Anchor, registered Entities or test Entities.
- **Depends on BAS.Rules**: 24 test cases get expected values from BAS.Rules, which is in preparation.
- Test cases for Trust Marks apply only if BAS introduces Trust Marks.

## Test Case IDs

Each test case has a stable ID of the form `<Entity>-<Specification>-<number>`, for example `TA-OS-001` or `FRE-BAS-004`.

- Entity: `TA` (Trust Anchor), `FRE` (Federation Registration Entity), `RES` (Federation Resolver).
- Specification: `OS` (OIDF Sweden Conformance), `BAS` (BAS Conformance).
- An ID never changes, also when a test case is moved, renamed or reordered, and is never reused. A new test case gets the next free number in its series, and a removed test case leaves a gap.
- Use the ID when referring to a test case in test reports, issues and pull requests. Section numbers only show the structure, and may change.

## Suggested Order

1. Standalone tests, OIDF Sweden, then BAS.
2. Set up the chain and the test Entities described in [test_data.md](test_data.md).
3. Chain tests, OIDF Sweden, then BAS.

## More Detail

All test cases per Entity: [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md). The purpose, instructions, expected results and test data of each test case are found in the test specifications, and the test data is described in [test_data.md](test_data.md).
