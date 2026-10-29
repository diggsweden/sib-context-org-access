%%%
title = "BAS Federation Metadata Requirements 1.0 – draft 01"
abbrev = "bas_federation_metadata_requriements"
ipr = "none"
workgroup = ""
keyword = ["openid federation", "oauth 2.0"]
date = 2026-10-26T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "bas_federation_metadata_requriements"
status = "informational"

[[author]]
initials = "H."
surname = "Norlander"
fullname = "Henric Norlander"
organization = "The Swedish Agency for Digital Government (Digg)"
  [author.address]
  email = "extern.henric.norlander@digg.se"
%%%

.# Abstract

This specification defines the metadata requirements for OAuth 2.0 Clients, Authorization Servers and Protected Resources participating in the BAS federation [@!BAS.Rules]. The metadata is published in Entity Configurations according to OpenID Federation 1.1 [@!OpenID.Federation] and [@!OpenID.Federation.Connect], as profiled by [@!OIDC.Sweden.Federation]. The requirements apply to the Resolved Metadata, meaning the metadata that results once the Trust Chain of an Entity has been applied to the declarations the Entity makes about itself. The OAuth 2.0 protocol itself follows the Ena OAuth 2.0 Interoperability Profile [@!Ena.OAuth2].

.# Registration Number

PLATSHÅLLARE: diarienummer

{mainmatter}

# Introduction {#introduction}

This document specifies the requirements on the metadata an Entity in BAS publishes. It is written for the organizations that operate such Entities, and for the developers and operators who implement them.

The requirements stated here apply to OAuth 2.0 Clients, Authorization Servers and Protected Resources that adhere to [@!Ena.OAuth2], which is the profile in use within BAS. This is the current scope rather than a permanent limitation. BAS may later admit other Entity Types, or Entities adhering to other profiles, and the requirements in this document would then not apply to them unaltered.

The requirements build on a number of specifications. [@!OpenID.Federation] defines how metadata is published and resolved, and [@!OIDC.Sweden.Federation] profiles OpenID Federation for use in Swedish federations, a profile that BAS follows. [@!Ena.OAuth2] defines the OAuth 2.0 metadata and the requirement levels that apply, and [@!BAS.Security] states the algorithm and key requirements that apply within the federation. This document does not restate [@!Ena.OAuth2] and does not lower any of its requirement levels.

The requirement chapters state what has to appear in the Resolved Metadata of an Entity, in addition to what [@!Ena.OAuth2] requires.

The requirements on organization metadata ((#common_requirements)) and on identifier bindings ((#client_identifier), (#issuer_identifier) and (#resource_identifier)) are not specific to BAS, and are intended to move to [@?Ena.Federation] once it is published.

## Requirements Notation and Conventions {#requirements_notation_and_conventions}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [@!RFC2119] [@!RFC8174] when, and only when, they appear in all capitals, as shown here.

## Terminology {#terminology}

This specification uses the terms "Entity", "Entity Configuration", "Entity Identifier", "Entity Type Identifier", "Leaf Entity", "Subordinate Statement", "Trust Anchor", "Trust Chain" and "Resolved Metadata" as defined in [@!OpenID.Federation], the term "Federation Protocol Entity" as defined in [@!OIDC.Sweden.Federation], the terms "Client", "Authorization Server" and "Protected Resource" as defined in [@!Ena.OAuth2], and the terms "Federation Operator", "Federation Registration Operator", "Federation Registration Entity" and "Federation Member" as defined in [@!BAS.Rules, section 1.2]. The term "Collaboration Context" (Swedish: samverkanskontext) is used as in [@!BAS.Rules, section 8].

This specification also defines the following term:

- **Client Registration:** The incorporation of a Client into the service configuration of an Authorization Server, based on the Client's Resolved Metadata. It is distinct from the registration of an Entity in BAS, which a Federation Registration Entity performs by issuing a Subordinate Statement for the Entity.

## Scope {#scope}

A requirement is placed in this specification only if it is needed for one of the following:

1. to verify the identity of an Entity and the organization it is registered for, or
2. to make an Entity's metadata resolvable and reliable through its Trust Chain in BAS.

Everything else follows [@!Ena.OAuth2]. The information exchange between Entities, such as scopes and access decisions, is out of scope and is decided by the parties or by a Collaboration Context, see [@!BAS.Rules, section 8].

# General Requirements {#general_requirements}

Every Client, Authorization Server and Protected Resource in BAS publishes an Entity Configuration. Its metadata is carried in the `metadata` Claim under the Entity Type Identifier `oauth_client`, `oauth_authorization_server` or `oauth_resource`, as specified in Sections 5.1.3 to 5.1.5 of [@!OpenID.Federation.Connect]. These are the Entity Types that the `allowed_entity_types` constraint of the BAS Trust Anchor admits, see [@!BAS.Rules, section 4.2]. Hosted Entity Configurations are not yet defined for BAS, see [@!BAS.Rules, section 3.2].

The requirements apply to the Resolved Metadata, meaning the metadata that results from applying the Subordinate Statements of the Trust Chain to the Entity's own declarations, see [@!OpenID.Federation, section 10]. A parameter that is **REQUIRED** in the Resolved Metadata is therefore not always one the Entity declares itself: a Federation Registration Entity may assign it in the Subordinate Statement, and the Trust Anchor metadata policy may constrain it. Where that is the case, the tables below say so, and (#bas_metadata_policies) shows how.

The Resolved Metadata of an Entity **MUST** conform to [@!Ena.OAuth2] for its Entity Type. A parameter not listed in this specification **MAY** be used at the requirement level given by [@!Ena.OAuth2] or, where that profile does not address it, by the specification that defines it.

Where a value is checked at registration, the tables say so. A checked value is set by the Federation Registration Entity in the Subordinate Statement it issues for the Entity, so that the Resolved Metadata always carries the value that was checked, see (#federation_registration_entity_metadata_assignment).

This document does not specify the Entity Statement Claims themselves, such as `iss`, `sub`, `iat`, `exp`, `jwks`, `authority_hints` and `trust_marks`. Those are defined by [@!OpenID.Federation, section 3.1] and profiled by [@!OIDC.Sweden.Federation]. Clients, Authorization Servers and Protected Resources are Federation Protocol Entities, and therefore always Leaf Entities, so their Entity Configurations **MUST NOT** contain metadata of the Entity Type `federation_entity`, see [@!OIDC.Sweden.Federation, section 2.2].

## Language {#language}

Within BAS, Swedish is the default language. Metadata values intended for human consumption are provided in Swedish (`#sv`) and English (`#en`) as [@!Ena.OAuth2] recommends. For every such parameter that an Entity provides with a Swedish value, the Federation Registration Entity assigns the corresponding parameter without a language tag, holding the Swedish value, in the Subordinate Statement. The Resolved Metadata therefore always contains it, and implementations without support for language tags can use it. A value without a language tag that the Entity declares itself is replaced by the assigned value.

```json
"client_name#sv" : "Min tjänst",
"client_name#en" : "My service",
"client_name" : "Min tjänst"     <- assigned by the Federation Registration Entity
```

## Protocol Keys {#protocol_keys}

The keys an Entity uses in the OAuth 2.0 protocol, as opposed to the Federation Entity Keys that sign its Entity Statements, are published in its `oauth_client`, `oauth_authorization_server` or `oauth_resource` metadata. Three representations are available, see [@!OpenID.Federation, section 5.2.1]. The requirement levels below follow [@!Ena.OAuth2], which states them separately for each Entity Type, and they therefore differ between the Entity Types.

| Parameter | Requirement | Description | Defined in |
| --- | --- | --- | --- |
| `jwks` | **REQUIRED** for a Client, unless `jwks_uri` is used, see [@!Ena.OAuth2, section 2.2.2.4]. **OPTIONAL** for an Authorization Server and a Protected Resource. | The Entity's JSON Web Key Set, included by value in the metadata. | [@!RFC7591, section 2] and [@!OpenID.Federation, section 5.2.1] |
| `jwks_uri` | **REQUIRED** for an Authorization Server, see [@!Ena.OAuth2, section 3.1.1.3]. **REQUIRED** for a Client, unless `jwks` is used. **OPTIONAL** for a Protected Resource. | A URL from which the Entity's JSON Web Key Set can be retrieved. The URL **MUST** use the HTTPS scheme. | [@!RFC7591, section 2], [@!RFC8414, section 2], [@!RFC9728, section 2] and [@!OpenID.Federation, section 5.2.1] |
| `signed_jwks_uri` | **OPTIONAL** | A URL referencing a signed JWT that carries the Entity's JSON Web Key Set. The URL **MUST** use the HTTPS scheme, and the JWT **MUST** be signed with a Federation Entity Key. | [@!OpenID.Federation, section 5.2.1] |

It is **RECOMMENDED** that an Entity uses only one of the three representations, see [@!OpenID.Federation, section 5.2.1.1].

The keys an Entity publishes **MUST** meet the cryptographic requirements of [@!BAS.Security], which state the algorithms and minimum key lengths that apply within BAS, see [@!BAS.Security, section 3]. An Entity that replaces a key **MUST** follow the key rollover requirements of [@!BAS.Security, section 4], so that other parties in the federation are not disrupted. To facilitate a smooth key rollover, each JWK **MUST** include a `kid` parameter, also in the cases where the JWK Set holds a single key, see [@!BAS.Security, section 4].

# Common Requirements {#common_requirements}

The parameters below identify the Entity and the organization it is registered for, and describe them. They are defined in [@!OpenID.Federation, section 5.2.2] unless stated otherwise, and are published with the same meaning in `oauth_client`, `oauth_authorization_server` and `oauth_resource` metadata.

| Parameter | Requirement | Description | Defined in |
| --- | --- | --- | --- |
| `organization_name` | **REQUIRED**. Assigned by the Federation Registration Entity; **OPTIONAL** for the Entity to supply. | The name of the organization the Entity is registered for. The value without a language tag **MUST** be the legal name of the organization. Values for `#sv` and `#en` **MAY** also be given. | [@!OpenID.Federation, section 5.2.2] |
| `organization_identifier` | **REQUIRED**. Assigned by the Federation Registration Entity; **OPTIONAL** for the Entity to supply. | The organization identifier of the organization the Entity is registered for, in one of the formats of (#organization_identifier_formats). | [@!OIDC.Sweden.OrgId, section 2] |
| `contacts` | **REQUIRED** | Contact addresses for the people or groups responsible for operating the Entity. The value **MUST** hold at least one email address. | [@!OpenID.Federation, section 5.2.2] and [@!RFC7591, section 2] |
| `display_name` | **OPTIONAL** | A human-readable name of the Entity, given in the languages of (#language). | [@!OpenID.Federation, section 5.2.2] |
| `description` | **OPTIONAL** | A human-readable description of the Entity, given in the languages of (#language). | [@!OpenID.Federation, section 5.2.2] |
| `keywords` | **OPTIONAL** | Keywords describing the Entity. | [@!OpenID.Federation, section 5.2.2] |
| `logo_uri` | **OPTIONAL** | An HTTPS URL of a logo for the Entity. | [@!OpenID.Federation, section 5.2.2] |
| `policy_uri` | **OPTIONAL** | An HTTPS URL of documentation of the conditions and policies that apply to the Entity. | [@!OpenID.Federation, section 5.2.2] |
| `information_uri` | **OPTIONAL** | An HTTPS URL of further information about the Entity. | [@!OpenID.Federation, section 5.2.2] |
| `organization_uri` | **OPTIONAL** | An HTTPS URL of a web page of the organization the Entity is registered for. | [@!OpenID.Federation, section 5.2.2] |

## Organization Identifier Formats {#organization_identifier_formats}

The organization identifier formats are defined by the following:

- **GLobal Unique Enterprise (GLUE) Identifiers** [@?I-D.ietf-spice-glue-id] define the structure of the identifier. GLUE makes it possible to support several types of identifiers side by side.
- **ISO/IEC 6523** [@!ISO.6523] is the international standard that defines how organizations, and parts of organizations, are identified unambiguously in electronic data interchange. Each identification scheme is designated by an International Code Designator (ICD).

The `organization_identifier` **MUST** be expressed as a GLUE-URI using ISO/IEC 6523 representation, in the format `urn:glue:iso6523:<icd>:<identifier>`. The recommended formats are listed below, and the list may be extended as needed.

| Identifier | ICD | Format |
| --- | --- | --- |
| Swedish organization number | 0007 | `urn:glue:iso6523:0007:<organization-number>` |
| GLN (Global Location Number) | 0088 | `urn:glue:iso6523:0088:<gln>` |
| Domain-based eDelivery Participant Identifier | 0203 | `urn:glue:iso6523:0203:<domain>`, for example `urn:glue:iso6523:0203:foretaget.se` |

A Swedish organization number is a ten-digit string without a hyphen, according to [@?SKV709]. ICD 0007 is assigned to the Swedish Tax Agency (Skatteverket).

```json
"organization_identifier" : "urn:glue:iso6523:0007:2021006883"
```

*Example: the organization number of the Swedish Agency for Digital Government (Digg).*

# OAuth Client Requirements {#oauth_client_requirements}

A Client's `oauth_client` metadata conforms to [@!Ena.OAuth2, section 2.2]. The table below lists only the parameters for which BAS adds a requirement, in addition to those in (#common_requirements).

| Parameter | Requirement | Description | Defined in |
| --- | --- | --- | --- |
| `token_endpoint_auth_method` | **REQUIRED**. Constrained by the Trust Anchor metadata policy. | The value **MUST** be `private_key_jwt`, see (#client_authentication). | [@!RFC7591, section 2] and [@!Ena.OAuth2, section 2.2.2.2] |
| `grant_types` | **REQUIRED**. Constrained by the Trust Anchor metadata policy. | The grant types the Client uses. The value **MUST** be `["client_credentials"]`. BAS is a machine-to-machine federation, and `client_credentials` is the only grant type used in it. | [@!RFC7591, section 2] and [@!Ena.OAuth2, section 2.2.2.3] |
| `response_types` | Assigned by the Trust Anchor metadata policy. | An empty array. A Client that uses no redirect-based grant has no response types, and the default of `code` in [@!RFC7591] would otherwise be implied. | [@!RFC7591, section 2] |

## Client Identifier {#client_identifier}

The client identifier of a Client in BAS is its Entity Identifier. A Client **MUST** use its Entity Identifier as `client_id` at every Authorization Server it interacts with. This fulfils the requirement of [@!Ena.OAuth2, section 2.2.1] that a Client in a federative context uses the same client identifier for all registrations, and allows every Authorization Server to verify the Client's identity and organizational connection through its Trust Chain.

## Client Authentication {#client_authentication}

Within BAS, a Client authenticates using `private_key_jwt` as specified in [@!Ena.OAuth2, section 8.3.1], with keys published in its Resolved Metadata. This binds client authentication to the Client's Trust Chain: an Authorization Server verifies the authentication with a key it has obtained through the same chain that establishes the Client's identity. The other methods that [@!Ena.OAuth2] permits are not used in BAS, see [@!BAS.Security, section 2].

# Authorization Server Requirements {#authorization_server_requirements}

An Authorization Server's `oauth_authorization_server` metadata conforms to [@!Ena.OAuth2, section 3.1.1]. The table below lists only the parameters for which BAS adds a requirement, in addition to those in (#common_requirements).

| Parameter | Requirement | Description | Defined in |
| --- | --- | --- | --- |
| `issuer` | **REQUIRED** | **MUST** be equal to the Authorization Server's Entity Identifier, see (#issuer_identifier). | [@!RFC8414, section 2] and [@!Ena.OAuth2, section 3.1.1.1] |
| `grant_types_supported` | **REQUIRED**. Checked by the Trust Anchor metadata policy. | **MUST** contain `client_credentials`. The Authorization Server **MAY** also list grant types it supports outside BAS. | [@!RFC8414, section 2] and [@!Ena.OAuth2, section 3.1.1.5] |
| `token_endpoint_auth_methods_supported` | **REQUIRED**. Constrained by the Trust Anchor metadata policy. | `private_key_jwt` only, as [@!BAS.Security, section 2] requires. | [@!RFC8414, section 2] and [@!Ena.OAuth2, section 3.1.1.6] |
| `revocation_endpoint_auth_methods_supported` | **REQUIRED** if `revocation_endpoint` is present. Constrained by the Trust Anchor metadata policy. | `private_key_jwt` only, as [@!BAS.Security, section 2] requires. | [@!RFC8414, section 2] |
| `introspection_endpoint_auth_methods_supported` | **REQUIRED** if `introspection_endpoint` is present. Constrained by the Trust Anchor metadata policy. | `private_key_jwt` only, as [@!BAS.Security, section 2] requires. | [@!RFC8414, section 2] |
| `token_endpoint_auth_signing_alg_values_supported` | **REQUIRED**. Constrained by the Trust Anchor metadata policy. | **MUST** meet [@!BAS.Security, section 3.1]. | [@!RFC8414, section 2] and [@!Ena.OAuth2, section 3.1.1.7] |

## Issuer Identifier {#issuer_identifier}

The issuer identifier of an Authorization Server in BAS is its Entity Identifier, see [@!OpenID.Federation.Connect, section 5.1.3]. Access tokens and other objects the Authorization Server signs therefore carry an `iss` value that a peer can resolve to a Trust Chain, and from it to the organization the Authorization Server is registered for.

## Consistency with Published Metadata {#consistency_with_published_metadata}

An Authorization Server also publishes its metadata at the location stated in [@!Ena.OAuth2, section 3.1.2]. For every parameter that appears in both, the value published there **MUST** be consistent with the Authorization Server's Resolved Metadata. Where the Trust Anchor metadata policy removes values that the Authorization Server supports outside BAS, the value in the Resolved Metadata is a subset of the published value, and the two are consistent in this sense. Within BAS, the Resolved Metadata takes precedence.

# Protected Resource Requirements {#protected_resource_requirements}

A Protected Resource in BAS always publishes an Entity Configuration, see (#general_requirements). Its `oauth_resource` metadata uses the parameters defined in [@!RFC9728, section 2], which [@!OpenID.Federation.Connect, section 5.1.5] makes available, and conforms to [@!Ena.OAuth2, section 4.3]. The table below lists only the parameters for which BAS adds a requirement, in addition to those in (#common_requirements).

| Parameter | Requirement | Description | Defined in |
| --- | --- | --- | --- |
| `resource` | **REQUIRED** | **MUST** be equal to the Protected Resource's Entity Identifier, see (#resource_identifier). | [@!RFC9728, section 2] and [@!Ena.OAuth2, section 4.3] |
| `authorization_servers` | **OPTIONAL** | If present, **MUST** contain the Entity Identifier of at least one Authorization Server in BAS. | [@!RFC9728, section 2] |

## Resource Identifier {#resource_identifier}

The resource identifier of a Protected Resource in BAS is its Entity Identifier. An Authorization Server uses it as the `aud` value of access tokens for the Protected Resource, see [@!Ena.OAuth2, section 6.1.1]. A Client and an Authorization Server can thereby resolve the intended audience of a token to a Trust Chain, and from it to the organization the Protected Resource is registered for.

# BAS Metadata Policies {#bas_metadata_policies}

The requirements of this specification are enforced through two mechanisms that differ in scope and in who controls them. The Trust Anchor metadata policy is federation-wide, identical for every Entity of a given Entity Type, and controlled by the Federation Operator. The values a Federation Registration Entity sets when it registers an Entity differ from one Entity to the next, and are controlled by the Federation Registration Operator that registered it.

A Trust Anchor issues Subordinate Statements only for its Immediate Subordinates, which within BAS are the Federation Registration Entities. A rule that is to reach every Leaf Entity therefore travels down the Trust Chain as a metadata policy, while a per-Entity value is set by the Leaf Entity's Immediate Superior. When metadata is resolved, the `metadata` Claim of the Subordinate Statement about the Leaf Entity is applied first, and the resolved metadata policy after that, see [@!OpenID.Federation, section 6.1.4.2].

## Trust Anchor Metadata Policy {#trust_anchor_metadata_policy}

The Trust Anchor metadata policy enforces the requirements of this specification and the choices of [@!BAS.Rules] and [@!BAS.Security] that can be expressed as policy. Conformance to [@!Ena.OAuth2] is the responsibility of each Entity and is checked at registration, see (#requirements_not_expressed_as_policy). The policy below is carried in the Subordinate Statements that the BAS Trust Anchor issues and uses the operators of [@!OpenID.Federation, section 6.1.3.1].

```json
{
  "metadata_policy": {
    "oauth_client": {
      "organization_name": { "essential": true },
      "organization_identifier": { "essential": true },
      "contacts": { "essential": true },
      "token_endpoint_auth_method": {
        "essential": true,
        "one_of": ["private_key_jwt"]
      },
      "grant_types": {
        "essential": true,
        "subset_of": ["client_credentials"],
        "superset_of": ["client_credentials"]
      },
      "response_types": { "value": [] }
    },
    "oauth_authorization_server": {
      "organization_name": { "essential": true },
      "organization_identifier": { "essential": true },
      "contacts": { "essential": true },
      "grant_types_supported": {
        "essential": true,
        "superset_of": ["client_credentials"]
      },
      "token_endpoint_auth_methods_supported": {
        "essential": true,
        "subset_of": ["private_key_jwt"],
        "superset_of": ["private_key_jwt"]
      },
      "revocation_endpoint_auth_methods_supported": {
        "subset_of": ["private_key_jwt"],
        "superset_of": ["private_key_jwt"]
      },
      "introspection_endpoint_auth_methods_supported": {
        "subset_of": ["private_key_jwt"],
        "superset_of": ["private_key_jwt"]
      },
      "token_endpoint_auth_signing_alg_values_supported": {
        "essential": true,
        "superset_of": ["RS256", "ES256"],
        "subset_of": ["RS256", "RS384", "RS512", "ES256", "ES384", "ES512",
                      "PS256", "PS384", "PS512"]
      }
    },
    "oauth_resource": {
      "organization_name": { "essential": true },
      "organization_identifier": { "essential": true },
      "contacts": { "essential": true },
      "resource": { "essential": true }
    }
  }
}
```

The operators act as follows:

- `essential` makes the parameter mandatory in the Resolved Metadata. An Entity whose Resolved Metadata lacks it fails policy resolution, and its Trust Chain is not valid.
- `one_of` checks that a Client's `token_endpoint_auth_method` is `private_key_jwt`.
- `subset_of` and `superset_of` with identical values require the value to be exactly that set, see [@!OpenID.Federation, section 6.1.3.1.8]. For a Client's `grant_types`, this means the Client uses `client_credentials` and nothing else. For an Authorization Server's client authentication methods, a method it supports outside BAS is removed from its Resolved Metadata, since [@!BAS.Security, section 2] prohibits other methods for Clients in BAS.
- `superset_of` alone is a check that the value contains what BAS requires, and removes nothing. It is used for an Authorization Server's `grant_types_supported`, so that grant types it supports outside BAS remain visible to parties that agree to use them outside BAS. For `token_endpoint_auth_signing_alg_values_supported` it checks that RS256 and ES256 are declared, as [@!BAS.Security, section 3.1] requires, and `subset_of` removes algorithms that [@!BAS.Security] does not permit.
- `value` assigns an empty `response_types` array to every Client, whatever the Client declares.

If BAS later admits further grant types, the Federation Operator updates the grant type values of the policy accordingly.

## Federation Registration Entity Metadata Assignment {#federation_registration_entity_metadata_assignment}

A Federation Registration Entity sets the parameters below in the `metadata` Claim of the Subordinate Statement it issues for an Entity, under the Entity's Entity Type, having applied the Registration Policies of [@!BAS.Rules, section 6]. The values replace any the Entity declares itself. Verified values are pinned: a change **MUST** be requested via the Federation Registration Operator, which checks it as at registration before the Subordinate Statement is updated, see [@!BAS.Rules, section 7.3].

| Parameter | Set when | Value |
| --- | --- | --- |
| `organization_name` | Always. Verified under verification of organisational affiliation. | The legal name of the organization, without a language tag. The `#sv` and `#en` values are set if the Federation Member has supplied them. |
| `organization_identifier` | Always. Verified under verification of organisational affiliation. | The organization identifier of the Federation Member, in one of the formats of (#organization_identifier_formats). |
| Parameters without language tag | Whenever the Entity supplies a `#sv` value. | The Swedish value, see (#language). |

The Federation Registration Entity also includes the `registration_policy` Claim defined in [@!OIDC.Sweden.RegPolicy, section 2] in the Subordinate Statement, listing the Registration Policy URI of every policy it has applied to the Entity. The Registration Policies are defined in [@!BAS.Rules, section 6]. Through the `registration_policy` constraint of [@!BAS.Rules, section 4.2], the Trust Anchor requires that the policy for verification of organisational affiliation has been applied to every Entity. A peer can therefore rely on `organization_name` and `organization_identifier` without checking them itself.

| Check | Registration policy URI |
| --- | --- |
| Verification of organisational affiliation | `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection` |
| Verification of registration submitter | To be defined in a later version of [@!BAS.Rules], see its Section 6.2 |

The example below is non-normative. It shows the `metadata` and `registration_policy` Claims of a Subordinate Statement for a Client of the Swedish Agency for Digital Government (Digg), registered under the policy for verification of organisational affiliation. The issuer is illustrative.

```json
{
  "iss": "https://anslutning.example.se",
  "sub": "https://client.digg.se",
  "metadata": {
    "oauth_client": {
      "organization_name": "Myndigheten för digital förvaltning",
      "organization_name#sv": "Myndigheten för digital förvaltning",
      "organization_name#en": "The Swedish Agency for Digital Government",
      "organization_identifier": "urn:glue:iso6523:0007:2021006883",
      "client_name": "Ärendetjänst"
    }
  },
  "registration_policy": [
    "https://id.ena-infrastructure.se/regpolicy/v1/orgconnection"
  ]
}
```

## Requirements Not Expressed as Policy {#requirements_not_expressed_as_policy}

Some requirements cannot be expressed with the standard operators. They fall into two groups, with different consequences.

**Identifier bindings.** These carry the identity that BAS exists to make verifiable:

- an Authorization Server's `issuer` is equal to its Entity Identifier ((#issuer_identifier)),
- a Protected Resource's `resource` is equal to its Entity Identifier ((#resource_identifier)), and
- a Client's `client_id` is its Entity Identifier ((#client_identifier)).

A Federation Registration Entity **MUST** reject the registration of an Entity whose metadata does not meet the issuer binding or the resource binding above. A peer that finds either of them unmet **MUST NOT** use the Resolved Metadata. An Authorization Server **MUST** obtain a Client's metadata by resolving its `client_id` as an Entity Identifier through a Trust Chain to the BAS Trust Anchor.

**Other requirements.** These include conformance to [@!Ena.OAuth2], such as publishing either `jwks` or `jwks_uri` but not both, and using the HTTPS scheme for URLs. A Federation Registration Entity **SHOULD** reject the registration of an Entity whose metadata does not meet them. The requirements of [@!BAS.Security] are checked by the Federation Registration Operator at registration, see [@!BAS.Rules, section 9]. How a peer acts on a deviation is left to the peer.

{backmatter}

<reference anchor="BAS.Rules">
  <front>
    <title>BAS: Federation Rules and Policies 1.0, draft 01</title>
    <author fullname="Henric Norlander" initials="H." surname="Norlander">
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<reference anchor="BAS.Security">
  <front>
    <title>Federationskontext BAS: Security Requirements 1.0, draft 01</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<reference anchor="Ena.OAuth2" target="https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html">
  <front>
    <title>Ena OAuth 2.0 Interoperability Profile, Version 1.0, draft 01</title>
    <date day="16" month="October" year="2025"/>
  </front>
</reference>

<reference anchor="ISO.6523">
  <front>
    <title>ISO/IEC 6523-1:2023. Part 1: Identification of organization identification schemes</title>
    <date year="2023"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.Federation">
  <front>
    <title>Swedish OpenID Federation Deployment and Interoperability Profile 1.0, draft 03</title>
    <author initials="M." surname="Lindström"/>
    <author initials="S." surname="Santesson"/>
    <date day="2" month="October" year="2026"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.OrgId">
  <front>
    <title>OpenID Federation Organization Identifier Metadata Parameter 1.0</title>
    <author initials="M. B." surname="Jones"/>
    <author initials="M." surname="Lindström"/>
    <author initials="S." surname="Santesson"/>
    <date day="23" month="February" year="2026"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.RegPolicy">
  <front>
    <title>OpenID Federation Registration Policy 1.0, draft 01</title>
    <author initials="M." surname="Lindström"/>
    <author initials="S." surname="Santesson"/>
    <date day="30" month="March" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation">
  <front>
    <title>OpenID Federation 1.1</title>
    <author initials="R." surname="Hedberg"/>
    <author initials="M. B." surname="Jones" role="editor"/>
    <author initials="G." surname="De Marco"/>
    <author initials="A. Å." surname="Solberg"/>
    <author initials="J." surname="Bradley"/>
    <author initials="V." surname="Dzhuvinov"/>
    <date day="5" month="May" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation.Connect">
  <front>
    <title>OpenID Federation for OpenID Connect 1.1</title>
    <author initials="R." surname="Hedberg"/>
    <author initials="M. B." surname="Jones" role="editor"/>
    <author initials="G." surname="De Marco"/>
    <author initials="A. Å." surname="Solberg"/>
    <author initials="J." surname="Bradley"/>
    <author initials="V." surname="Dzhuvinov"/>
    <date day="5" month="May" year="2026"/>
  </front>
</reference>

<reference anchor="Ena.Federation">
  <front>
    <title>Ena OAuth 2.0 Federation Interoperability Profile</title>
    <date/>
  </front>
  <annotation>Referred to by Section 1.4 of [Ena.OAuth2], not yet published.</annotation>
</reference>

<reference anchor="I-D.ietf-spice-glue-id">
  <front>
    <title>GLobal Unique Enterprise (GLUE) Identifiers</title>
    <author initials="B." surname="Zundel"/>
    <author initials="P." surname="Dingle"/>
    <author initials="M. B." surname="Jones"/>
    <date day="23" month="July" year="2026"/>
  </front>
  <seriesInfo name="Internet-Draft" value="draft-ietf-spice-glue-id-10"/>
</reference>

<reference anchor="SKV709">
  <front>
    <title>SKV 709, Utgåva 8, Organisationsnummer</title>
    <author>
      <organization>Skatteverket</organization>
    </author>
    <date year="2006"/>
  </front>
</reference>

# Notices

Copyright (c) The Swedish Agency for Digital Government (Digg), 2026. All
Rights Reserved.

# Document History

1.0 – draft 01: Initial version.
