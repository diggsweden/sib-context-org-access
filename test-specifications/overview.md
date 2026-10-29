# BAS Federation Infrastructure – Test Case Overview

Test cases for the Trust Anchor, the Federation Registration Entities (anslutningstjänster) and the Federation Resolver of Federationskontext BAS.

Version: 0.1.0 (draft)

| Entity | Specification | Standalone | Chain | Total |
| :--- | :--- | ---: | ---: | ---: |
| [Trust Anchor](ta_overview.md) | [OIDF Sweden](ta_oidf_sweden_test.md) | 23 | 20 | 43 |
| [Trust Anchor](ta_overview.md) | [BAS](ta_bas_test.md) | 2 | 6 | 8 |
| [Federation Registration Entity](fre_overview.md) | [OIDF Sweden](fre_oidf_sweden_test.md) | 17 | 22 | 39 |
| [Federation Registration Entity](fre_overview.md) | [BAS](fre_bas_test.md) | 2 | 7 | 9 |
| [Federation Resolver](resolver_overview.md) | [OIDF Sweden](resolver_oidf_sweden_test.md) | 5 | 35 | 40 |
| [Federation Resolver](resolver_overview.md) | [BAS](resolver_bas_test.md) | 1 | 7 | 8 |
| | **Total** | **50** | **97** | **147** |

## How the Test Cases Are Divided

- **OIDF Sweden**: OpenID Federation and the Swedish OpenID Federation profile. No BAS-specific requirements.
- **BAS**: the requirements BAS adds (BAS Metadata, BAS Security, BAS.Rules, SIB Registration).
- **Standalone**: can be run against the Entity alone, as soon as it is deployed.
- **Chain**: needs test data from other Entities, such as the Trust Anchor, registered Entities or test Entities.
- **Depends on BAS.Rules**: 19 test cases get expected values from BAS.Rules, which is in preparation.
- Test cases for Trust Marks apply only if BAS introduces Trust Marks.
- **Registration is a black box**: the test cases verify what the infrastructure publishes, not how Entities are registered. Where a test case needs a change in the federation, such as a newly added Entity, the change is a *Precondition* made by the Federation Registration Operator, and the test case verifies the published result.
- **Independent test cases**: every test case can be carried out on its own and in any order. It obtains the data it verifies itself, using the [common procedures](procedures.md), and depends only on the test data, never on another test case. A failed procedure makes a test case *Inconclusive*, not *Failed*.

## Test Case IDs

Each test case has a stable ID of the form `<Entity>-<Specification>-<number>`, for example `TA-OS-001` or `FRE-BAS-004`.

- Entity: `TA` (Trust Anchor), `FRE` (Federation Registration Entity), `RES` (Federation Resolver).
- Specification: `OS` (OIDF Sweden Conformance), `BAS` (BAS Conformance).
- An ID never changes, also when a test case is moved, renamed or reordered, and is never reused. A new test case gets the next free number in its series, and a removed test case leaves a gap.
- Use the ID when referring to a test case in test reports, issues and pull requests. Section numbers only show the structure, and may change.

## Suggested Order

The test cases do not depend on each other, so the order is a matter of planning only:

1. Standalone tests, which can be run as soon as an Entity is deployed.
2. Set up the chain and the test Entities described in [test_data.md](test_data.md).
3. Chain tests. Test cases that change test data, such as TE2, TR3, TR4 and TR8, are best run last (see [test_data.md](test_data.md#7-order-and-reuse)).

## Priority Test Cases

The 26 test cases below, out of 147, are the most central. If time is short, run these first. The OIDF Sweden conformance tests chosen are those that decide whether the Trust Chain can be relied on: signatures, keys, chain building, and that nothing invalid or stale gets through. The BAS conformance tests chosen test what makes BAS work for its participants: that it is known which organization stands behind each Entity, and that every Client can authenticate at every Authorization Server. For each Entity, the OIDF Sweden test cases come first, since the BAS test cases build on the mechanisms they test.

### Trust Anchor

**OIDF Sweden**

| Test case | Why it is a priority |
| :--- | :--- |
| [TA-OS-007](ta_oidf_sweden_test.md#ta-os-007) Comparing the keys with the keys distributed out-of-band | The root of trust. If the keys do not match those distributed out-of-band, no Trust Chain can be verified. |
| [TA-OS-002](ta_oidf_sweden_test.md#ta-os-002) Verifying the signature of the Entity Configuration | The basis for verifying anything the Trust Anchor publishes. |
| [TA-OS-028](ta_oidf_sweden_test.md#ta-os-028) Fetching a Subordinate Statement about an Immediate Subordinate | The link from the Trust Anchor to the Federation Registration Entities, correctly signed and with the right keys. |
| [TA-OS-034](ta_oidf_sweden_test.md#ta-os-034) Verifying that the metadata policy is well-formed | A policy that cannot be applied makes every Trust Chain invalid. Comes before TA-BAS-005, which checks the content of the policy. |
| [TA-OS-044](ta_oidf_sweden_test.md#ta-os-044) Federation key rollover | A fault in the Trust Anchor's key rollover breaks the whole federation at once. |

**BAS**

| Test case | Why it is a priority |
| :--- | :--- |
| [TA-BAS-005](ta_bas_test.md#ta-bas-005) Verifying that the metadata policy matches the published BAS policy | The policy is the foundation. If it is wrong, all Resolved Metadata in the federation is wrong, whatever the Federation Registration Entities do. |
| [TA-BAS-006](ta_bas_test.md#ta-bas-006) Verifying client authentication and algorithm constraints in the policy | Interoperability: `private_key_jwt`, `client_credentials` and the mandatory algorithms everywhere. A gap here means that some Clients cannot authenticate at some Authorization Servers. |

### Federation Registration Entity

**OIDF Sweden**

| Test case | Why it is a priority |
| :--- | :--- |
| [FRE-OS-018](fre_oidf_sweden_test.md#fre-os-018) Verifying the Trust Chain from the Intermediate to the Trust Anchor | Without a valid chain from the FRE to the Trust Anchor, nothing the FRE issues can be verified. |
| [FRE-OS-021](fre_oidf_sweden_test.md#fre-os-021) Verifying the binding between the Subordinate Statement and the registered Entity | The keys in the Subordinate Statement must be the Entity's own. This is what binds a verified organization identity to the right Entity. |
| [FRE-OS-028](fre_oidf_sweden_test.md#fre-os-028) Resolving registered Entities | Shows that the values set by the FRE work together with the Trust Anchor's policy. |
| [FRE-OS-039](fre_oidf_sweden_test.md#fre-os-039) Removing a registered Entity | An Entity that has been removed from BAS must not stay trusted. |
| [FRE-OS-040](fre_oidf_sweden_test.md#fre-os-040) Federation key rollover at the Intermediate | A fault in the FRE's key rollover breaks the Trust Chain of every Entity under it. |

**BAS**

| Test case | Why it is a priority |
| :--- | :--- |
| [FRE-BAS-003](fre_bas_test.md#fre-bas-003) Verifying organization parameters | The core value of BAS: the FRE sets the verified `organization_name` and `organization_identifier` of the organization behind each Entity. |
| [FRE-BAS-012](fre_bas_test.md#fre-bas-012) Changing a verified value in the Entity Configuration | Without it, an Entity could overwrite its own verified organization identity. |
| [FRE-BAS-007](fre_bas_test.md#fre-bas-007) Verifying the Resolved Metadata of registered Entities | The main black-box test: it checks every Entity the FRE publishes, and is the only test showing that the registration has not admitted an Entity that breaks the BAS requirements. |

### Federation Resolver

**OIDF Sweden**

| Test case | Why it is a priority |
| :--- | :--- |
| [RES-OS-006](resolver_oidf_sweden_test.md#res-os-006) Verifying that the resolver is trusted by the Trust Anchor | If the resolver is not trusted by the Trust Anchor, there is no reason to trust its responses. |
| [RES-OS-008](resolver_oidf_sweden_test.md#res-os-008) Verifying the Trust Chain in the response | Peers must be able to verify the response themselves, from the Trust Chain it carries. |
| [RES-OS-009](resolver_oidf_sweden_test.md#res-os-009) Verifying the Resolved Metadata | The Resolved Metadata must match an independent computation. This is what peers use in practice. |
| [RES-OS-023](resolver_oidf_sweden_test.md#res-os-023) Expired Entity Configuration<br/>[RES-OS-024](resolver_oidf_sweden_test.md#res-os-024) Entity Configuration signed with a key that is not bound by the Superior | Security critical. A resolver that accepts an expired Entity Configuration or a key not bound by the Superior makes Trust Chain validation meaningless. |
| [RES-OS-034](resolver_oidf_sweden_test.md#res-os-034) Propagation of changed metadata<br/>[RES-OS-035](resolver_oidf_sweden_test.md#res-os-035) Removed Entity | Caching must not give stale responses: changed and removed Entities must be reflected in time. |

**BAS**

| Test case | Why it is a priority |
| :--- | :--- |
| [RES-BAS-004](resolver_bas_test.md#res-bas-004) Organization parameters in Resolved Metadata | Checks that the verified organization identity actually reaches the peers that rely on the resolver. |
| [RES-BAS-002](resolver_bas_test.md#res-bas-002) Resolved Metadata of an Authorization Server | What peers actually use: the BAS policy must filter out what BAS does not permit. |
| [RES-BAS-003](resolver_bas_test.md#res-bas-003) Resolved Metadata of a Client | As above for Clients, including the values set by the FRE. |
| [RES-BAS-008](resolver_bas_test.md#res-bas-008) Propagation of a new protocol key | Key rollover under the BAS rules. If a new key does not reach peers in time, authentication stops working. |

## More Detail

All test cases per Entity: [Trust Anchor](ta_overview.md) · [Federation Registration Entity](fre_overview.md) · [Federation Resolver](resolver_overview.md). The purpose, instructions, expected results and test data of each test case are found in the test specifications, the test data is described in [test_data.md](test_data.md), and the common procedures in [procedures.md](procedures.md).
