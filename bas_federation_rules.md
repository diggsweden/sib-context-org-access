%%%
title = "BAS – Federation Rules and Policies 1.0 – draft 01"
abbrev = "bas_federation_rules"
ipr = "none"
workgroup = ""
keyword = ["openid federation", "oauth 2.0"]
date = 2026-10-27T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "bas_federation_rules"
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

This document states the rules and policies of the BAS federation, which is built upon OpenID Federation 1.1 and profiled by the Swedish OpenID Federation Deployment and Interoperability Profile.

.# Registration Number

\<YYYY-nnnn\>

{mainmatter}

# Introduction {#introduction}

BAS (Swedish: Federationskontext BAS) is a federation context for machine-to-machine access within, and towards, the Swedish public sector. It is built upon [@!OpenID.Federation] and [@!OpenID.Federation.Connect], profiled by [@!OIDC.Sweden.Federation]. Its Entities are OAuth 2.0 Clients, Authorization Servers and Protected Resources following [@!Ena.OAuth2].

This document is the Federation Rules of BAS required by [@!OIDC.Sweden.Federation, section 2.1]. It is the entry document for the federation. It states what a participant has to comply with, and refers to the other BAS documents for the details. A participant that follows these rules thereby follows the documents they refer to:

- [@!SIB.BAS.Structure] describes the structure of the federation and its environments, and gives the Entity Identifiers, endpoints, and Trust Anchor keys of each environment.
- [@!BAS.Metadata] states the metadata requirements and the Trust Anchor metadata policy.
- [@!BAS.Security] states the requirements on keys, algorithms and client authentication.
- [@!Ena.OAuth2] is the OAuth 2.0 profile that OAuth 2.0 Clients, Authorization Servers and Protected Resources follow.

(#federation_setup), (#federation_setup, use title), covers the Federation Operator, the Federation Registration Operators and the federation endpoints, and (#entity_statements), (#entity_statements, use title), covers the validity of Entity Statements. (#trust_chains), (#trust_chains, use title), covers how Trust Chains are resolved, the constraints set by the Trust Anchor, and how long a Client Registration may remain valid. The Registration Policies applied when an Entity is registered are given in (#registration_policies), (#registration_policies, use title), and how an Entity joins BAS is described in (#joining_the_federation), (#joining_the_federation, use title). (#protocol_compliance), (#protocol_compliance, use title), covers the requirements that OAuth 2.0 Clients, Authorization Servers and Protected Resources comply with, and (#security_requirements), (#security_requirements, use title), covers the security requirements.

## Requirements Notation and Conventions {#requirements_notation_and_conventions}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in BCP 14 [@!RFC2119] [@!RFC8174] when, and only when, they appear in all capitals, as shown here.

## Terminology {#terminology}

Terms are used as defined in [@!OpenID.Federation], [@!OIDC.Sweden.Federation] and [@!Ena.OAuth2]. In addition, this document defines the following terms:

- Federation Operator (Federationsoperatör) – Operates the BAS Trust Anchor; Digg.
- Federation Registration Operator (Anslutningsoperatör) – Registers the Entities of Federation Members in BAS.
- Federation Registration Entity (anslutningstjänst) – As defined in [@!OIDC.Sweden.Federation]; in BAS operated by a Federation Registration Operator.
- Federation Member (Federationsmedlem) – An organization connected to BAS, on whose behalf Entities are registered.
- Collaboration Context (samverkanskontext) – A context in which a set of parties agree on the information exchange between their Entities, such as scopes and access decisions. A Collaboration Context **MAY** restrict further what BAS permits, but **MUST NOT** relax the requirements of BAS.

# Federation Setup {#federation_setup}

## The Federation Operator {#the_federation_operator}

The Swedish Agency for Digital Government (Digg) is the Federation Operator of BAS. Digg operates the Trust Anchor and maintains its metadata policy, see [@!BAS.Metadata]. The Federation Registration Entities are operated by Federation Registration Operators, not by the Federation Operator, see (#federation_registration_operators), (#federation_registration_operators, use title).

The base URL of BAS is `https://fed.ena-infrastructure.se`. Identifiers that the Federation Operator defines are formed under this URL. This is the base URL that [@!OIDC.Sweden.Federation, section 2.1] requires the Federation Rules to define. The Registration Policy URIs defined by [@!SIB.Registration] are an exception: they are shared across Ena and are formed under `https://id.ena-infrastructure.se`, see (#registration_policies), (#registration_policies, use title).

The Entity Identifiers, endpoints and Federation Entity Keys of the Trust Anchor for each environment are published in [@!SIB.BAS.Structure].

## Federation Registration Operators {#federation_registration_operators}

Apart from the Trust Anchor, the Entities that provide federation services in BAS are operated by Federation Registration Operators. A Federation Registration Operator is connected to BAS under [@!SIB.Connection] and operates a Federation Registration Entity, through which it registers the Entities of Federation Members under [@!SIB.Registration]. The Federation Registration Entities of BAS are listed in [@!SIB.BAS.Structure].

## Federation Endpoints {#federation_endpoints}

The federation endpoints of the Trust Anchor and the Federation Registration Entities do not require client authentication, see [@!OpenID.Federation, section 8.8]. The endpoints of each environment are listed in [@!SIB.BAS.Structure].

# Entity Statements {#entity_statements}

## Validity {#validity}

It is **RECOMMENDED** that an Entity set the validity of its Entity Configuration, as given by the `exp` Claim, to 7 days. An Entity that knows that a change to its metadata is about to happen **MAY** set a shorter validity.

New Entity Configurations **SHOULD** be published according to the recommendation in [@!OIDC.Sweden.Federation, section 2.4.1], that is, when half the lifetime of the current one has elapsed.

The Entity Configuration of the Trust Anchor, and the Subordinate Statements issued by the Trust Anchor and the Federation Registration Entities, have a validity of 7 days.

## Hosted Entity Configurations {#hosted_entity_configurations}

Hosted Entity Configurations will be defined in a later version of this document.

# Trust Chains {#trust_chains}

## Resolving Trust Chains {#resolving_trust_chains}

The BAS Trust Anchor provides a resolve endpoint, see [@!OpenID.Federation, section 8.3]. The endpoint of each environment is listed in [@!SIB.BAS.Structure]. Since the resolver is the Trust Anchor itself, an Entity that uses it does not need to configure trust in any other Entity than the Trust Anchor.

It is **RECOMMENDED** that Entities use the Trust Anchor's resolver to obtain the Resolved Metadata and Trust Marks of peer Entities, in line with [@!OIDC.Sweden.Federation, section 2.3]. An Entity that does so does not build or validate Trust Chains itself.

## Constraints {#constraints}

Constraints are applied when Trust Chains are resolved and validated.

The BAS Trust Anchor sets two constraints in the Subordinate Statement it issues for each Federation Registration Entity: `allowed_entity_types`, see [@!OpenID.Federation, section 6.2.3], and `registration_policy`, see [@!OIDC.Sweden.RegPolicy, section 3].

The `allowed_entity_types` constraint holds `oauth_client`, `oauth_authorization_server` and `oauth_resource`. Entity Types not listed in the constraint are removed from the subject's metadata during Trust Chain resolution. The Entity Type `federation_entity` is always allowed and is not listed, see [@!OpenID.Federation, section 6.2.3].

The `registration_policy` constraint requires that the Registration Policies of (#registration_policies), (#registration_policies, use title) have been applied to every Entity registered by a Federation Registration Entity. A constraint rule is satisfied if at least one of the policies it lists appears in the `registration_policy` Claim of the Subordinate Statement, so the constraint holds one rule for each policy. A peer can therefore rely on what the policies check without checking it itself.

The example below is non-normative.

```json
{
  "iss": "https://ta.example.se",
  "sub": "https://fre.example.se",
  ...
  "constraints": {
    "allowed_entity_types": [
      "oauth_client",
      "oauth_authorization_server",
      "oauth_resource"
    ],
    "registration_policy": [
      {
        "entity_types": [
          "oauth_client",
          "oauth_authorization_server",
          "oauth_resource"
        ],
        "policy": [
          "https://id.ena-infrastructure.se/regpolicy/v1/orgconnection"
        ]
      }
    ]
  }
}
```
Figure: Example of the constraints Claim of the Subordinate Statement issued by the BAS Trust Anchor for a Federation Registration Entity.

## Validity of Client Registrations {#validity_of_client_registrations}

A Client Registration, meaning the incorporation of a Client into the service configuration of an Authorization Server based on the Client's Resolved Metadata, **MUST NOT** remain valid longer than the Trust Chain of the Client from which it was made. An Authorization Server that can no longer obtain a valid Trust Chain for a Client **MUST** stop issuing access tokens to it.

With the validity periods of (#validity), (#validity, use title), an Entity removed from BAS can remain accepted for at most the remaining validity of the Trust Chain last resolved for it.

# Trust Marks {#trust_marks}

Trust Marks will be defined in a later version of this document.

# Registration Policies {#registration_policies}

A Registration Policy describes a policy under which an Entity was registered in the federation. The Registration Policies that were applied are listed in the `registration_policy` Claim of the Subordinate Statement issued for the Entity, see [@!OIDC.Sweden.RegPolicy, section 2]. BAS applies the Registration Policies of [@!SIB.Registration] below.

## Verification of Organisational Affiliation {#verification_of_organisational_affiliation}

Identifier: `https://id.ena-infrastructure.se/regpolicy/v1/orgconnection`

When this policy has been applied, the Federation Registration Entity asserts that:

- the Entity belongs to a Federation Member connected under [@!SIB.Connection],
- `organization_name` is the name of that Federation Member, see [@!BAS.Metadata], and
- `organization_identifier` holds the organization identifier of that Federation Member, in one of the formats of [@!BAS.Metadata, section 3.1].

The verification is performed as defined in [@!SIB.Registration]. These values are set in the Subordinate Statement issued for the Entity, and cannot be changed without the involvement of the Federation Registration Operator.

With the `registration_policy` constraint the Trust Anchor requires that every Entity has been registered under this policy. A peer can then rely on the organization information of an Entity without checking it itself.

## Verification of Registration Submitter {#verification_of_registration_submitter}

Verification of Registration Submitter will be defined in a later version of this document.

# Joining the Federation {#joining_the_federation}

## Joining as a Federation Registration Operator {#joining_as_a_federation_registration_operator}

An organization joins BAS as a Federation Registration Operator by being connected in that role under [@!SIB.Connection]. The Federation Operator then registers its Federation Registration Entity by issuing a Subordinate Statement for it from the Trust Anchor, with the constraints of (#constraints), (#constraints, use title). The Federation Registration Entity is listed in [@!SIB.BAS.Structure].

A> A reference to the relevant SIB agreement is to be added.

## Joining as a Federation Member {#joining_as_a_federation_member}

Each organization in the federation has one or more administrators, who are appointed when the organization signs the relevant SIB agreement. How this is done is described in other documentation. The administrators register the organization's Entities via a Federation Registration Operator, see (#federation_registration_operators), (#federation_registration_operators, use title).

A> A reference to the relevant SIB agreement is to be added.

## Updating a Registration {#updating_a_registration}

Metadata values that are checked during registration are pinned in the Subordinate Statement that the Federation Registration Entity issues for the Entity. These values are listed in [@!BAS.Metadata]. Since a pinned value overrides the value in the Entity Configuration, a change to such a value **MUST** be requested via the Federation Registration Operator, where it is checked in the same way as during registration before the Subordinate Statement is updated.

A change of the Federation Entity Keys of the Entity **MUST** also be requested via the Federation Registration Operator. An Entity Configuration is signed with a key from the `jwks` Claim of the Subordinate Statement issued for the Entity, see [@!OpenID.Federation, section 4], so a new key can only be used after the Federation Registration Entity has issued a Subordinate Statement that contains it.

Other changes, such as changes to its protocol keys, are made by the Entity itself, by publishing an updated Entity Configuration.

# OAuth 2.0 Compliance {#protocol_compliance}

OAuth 2.0 Clients, Authorization Servers and Protected Resources **MUST** comply with the Ena OAuth 2.0 Interoperability Profile [@!Ena.OAuth2].

The metadata of OAuth 2.0 Clients, Authorization Servers and Protected Resources **MUST** meet the requirements of [@!BAS.Metadata].

[@!BAS.Metadata] profiles only the metadata that the federation needs. Protocol metadata follows [@!Ena.OAuth2]. The information exchange between Entities, such as scopes and access decisions, is out of scope, and is decided by the parties to the exchange or by a Collaboration Context.

# Security Requirements {#security_requirements}

Participants in BAS **MUST** comply with the security requirements of [@!BAS.Security]. They apply to the keys and signatures of the OAuth 2.0 protocol as profiled by [@!Ena.OAuth2]. For Federation Entity Keys and the signing of Entity Statements, [@!OIDC.Sweden.Federation, section 6] applies.

The Federation Registration Operator checks that the security requirements are met when an Entity is registered.

{backmatter}

<!-- [PLATSHÅLLARE] URL saknas. -->
<reference anchor="BAS.Metadata">
  <front>
    <title>BAS: Federation Metadata Requirements, draft 04</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] URL saknas. -->
<reference anchor="BAS.Security">
  <front>
    <title>BAS: Security Requirements 1.0, draft 02</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<reference anchor="Ena.OAuth2" target="https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html">
  <front>
    <title>Ena OAuth 2.0 Interoperability Profile, Version 1.0, draft 01</title>
    <author/>
    <date day="16" month="October" year="2025"/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] Utgivare, datum och URL saknas. -->
<reference anchor="SIB.BAS.Structure">
  <front>
    <title>BAS Federation Structure</title>
    <author/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] URL saknas. -->
<reference anchor="SIB.Connection">
  <front>
    <title>Anslutning – Tillämpningskrav och vägledning, version 12</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date day="29" month="September" year="2026"/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] URL saknas. -->
<reference anchor="SIB.Registration">
  <front>
    <title>Registrering – Tillämpningskrav och vägledning, version 13</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date day="29" month="September" year="2026"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.Federation" target="https://www.oidc.se/specifications/swedish-openid-federation-profile.html">
  <front>
    <title>Swedish OpenID Federation Deployment and Interoperability Profile 1.0</title>
    <author initials="M." surname="Lindström"/>
    <author initials="S." surname="Santesson"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.RegPolicy" target="https://www.oidc.se/openid-federation-registration-policy/main.html">
  <front>
    <title>OpenID Federation Registration Policy 1.0</title>
    <author initials="M." surname="Lindström"/>
    <author initials="S." surname="Santesson"/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] URL saknas. -->
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

<!-- [PLATSHÅLLARE] URL saknas. -->
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

# Notices

Copyright (c) The Swedish Agency for Digital Government (Digg), 2015-2026. All Rights Reserved.

# Document History

1.0 - draft 01: Initial version.
