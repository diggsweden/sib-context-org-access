%%%
title = "BAS: OpenID Federation Structure 1.0 – draft 01"
abbrev = "bas-federation-structure"
ipr = "none"
workgroup = ""
keyword = ["openid federation", "oauth 2.0"]
date = 2026-10-26T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "bas-federation-structure"
status = "informational"

[[author]]
initials = "H."
surname = "Norlander"
fullname = "Henric Norlander"
organization = "The Swedish Agency for Digital Government (Digg)"
%%%

.# Abstract

BAS is a federation for API access based on OAuth 2.0. It is built on OpenID Federation [@!OpenID.Federation] and profiled by the "Swedish OpenID Federation Deployment and Interoperability Profile" [@!OIDC.Sweden.Federation]. BAS declares federation rules and policies in "BAS: Federation Rules and Policies 1.0" [@!BAS.Rules]. This document describes the BAS OpenID Federation structure, including the federation services provided by the Federation Operator and by the Federation Registration Operators, and provides connection information for participating parties.

.# Registration Number

TODO

{mainmatter}

# Introduction {#introduction}

BAS is a federation for API access based on OAuth 2.0, in which the Swedish Agency for Digital Government (Digg) is the Federation Operator. It connects organizations that offer APIs and other protected resources with organizations whose services need to call them, so that a Client can obtain an access token from an Authorization Server and use it at a Protected Resource, with BAS providing the metadata the parties need to establish contact with each other. Organizations join BAS through a Federation Registration Operator, which verifies the organization and registers its Entities in the federation.

The federation is built upon OpenID Federation 1.0 [@!OpenID.Federation], and profiled by the "Swedish OpenID Federation Deployment and Interoperability Profile" [@!OIDC.Sweden.Federation]. OAuth 2.0 within BAS follows the "Ena OAuth 2.0 Interoperability Profile" [@!Ena.OAuth2]. BAS declares federation rules and policies in "BAS: Federation Rules and Policies 1.0" [@!BAS.Rules].

OpenID Federation gives the federation a common root of trust, the Trust Anchor, whose federation key every participant configures. Starting from that root, trust in an individual Entity is established by collecting and validating a chain of signed Entity Statements, and the metadata that a participant needs in order to interact with that Entity is carried in the same chain.

Registering an Entity in the Production or QA environments requires that the organization has a contract or an agreement with Digg. The Sandbox environment carries no such requirement, and is open to any organization that wants to test or develop against the federation

(#federation_structure, use title) describes the roles in BAS and the federation services each role provides: the Federation Operator (Digg) provides the Trust Anchor and its resolver, and each Federation Registration Operator provides a Federation Registration Entity through which Federation Members register their Entities. How an organization joins BAS as a Federation Registration Operator or as a Federation Member is described in (#joining_the_federation, use title). Finally, (#bas_federation_environments, use title) gives the Entity Identifiers, endpoints, and Trust Anchor keys for each of the environments.

## Terminology {#terminology}

This document uses the terms "Client" and "Authorization Server" as defined by The OAuth 2.0 Authorization Framework [@!RFC6749], the term "Protected Resource" as defined by The OAuth 2.0 Authorization Framework: Bearer Token Usage [@!RFC6750], the terms "Entity", "Entity Configuration", "Entity Identifier", "Subordinate Statement", "Intermediate Entity", "Leaf Entity", "Trust Anchor", "Trust Chain" and "Resolved Metadata" defined in OpenID Federation 1.0 [@!OpenID.Federation], and the terms "Federation Registration Entity" and "Federation Protocol Entity" defined in the Swedish OpenID Federation Deployment and Interoperability Profile [@!OIDC.Sweden.Federation]. The terms "Federation Operator", "Federation Registration Operator" (anslutningsoperatör), "Federation Member" (federationsmedlem) and "Federation Registration Entity" (anslutningstjänst), as used within BAS, are defined in BAS: Federation Rules and Policies 1.0 [@!BAS.Rules].

# Federation Structure {#federation_structure}

<!-- TODO: Figure 1: OpenID Federation structure for BAS (temporary). The figure is to be added. -->

**System Access Trust Anchor**

The Trust Anchor is the root of the federation and is operated by Digg as the Federation Operator. Participants within the federation configure trust to the federation by trusting the Trust Anchor federation key, see (#bas_federation_environments, use title) below. In the Subordinate Statement it issues for each Federation Registration Entity.

**Resolver**

The Trust Anchor exposes a resolve endpoint for resolving the metadata of Entities in the federation, according to [@!OpenID.Federation, section 8.3].

**Federation Registration Entity**

An Intermediate Entity operated by a Federation Registration Operator, through which the operator registers the Entities of Federation Members. There is one Federation Registration Entity per Federation Registration Operator, so their number grows as operators join. It issues Subordinate Statements for the Entities it registers, pins the metadata values checked during registration, and applies the Registration Policies of [@!SIB.Registration].

**Trust Mark Issuers**

Trust Mark Issuers are not yet defined for BAS, see [@!BAS.Rules, section 5].

# Joining the Federation {#joining_the_federation}

## Joining as a Federation Registration Operator {#joining_as_a_federation_registration_operator}

A Federation Registration Operator contacts the Federation Operator (Digg) and registers its Federation Registration Entity with the Federation Operator.

## Joining as a Federation Member {#joining_as_a_federation_member}

The member chooses a Federation Registration Operator and registers its Entities through that operator's Federation Registration Entity.

## Updating a Registration {#updating_a_registration}

Changes to pinned metadata values and to Federation Entity Keys go through the Federation Registration Operator, see [@!BAS.Rules, section 7.3].

# Trust Marks {#trust_marks}

Trust Marks are not yet defined for BAS, see [@!BAS.Rules, section 5].

# BAS Federation Environments {#bas_federation_environments}

- Identifiers are formed under the BAS base URL `https://fed.ena-infrastructure.se`, see [@!BAS.Rules, section 2.1].

## Production {#production}

### Trust Anchor {#production_trust_anchor}

| Property | Value |
| --- | --- |
| Entity Identifier | `https://fed.ena-infrastructure.se/trustanchor` |
| Resolve endpoint | `https://fed.ena-infrastructure.se/trustanchor/resolve` |
| Trust Anchor Federation Key | To be added (PEM and JWK) |

### Federation Registration Entities {#production_federation_registration_entities}

| Federation Registration Operator | Entity Identifier | Federation List Endpoint | Registration interface |
| --- | --- | --- | --- |
|  |  |  |  |

## QA {#qa}

### Trust Anchor {#qa_trust_anchor}

| Property | Value |
| --- | --- |
| Entity Identifier | `https://qa.fed.ena-infrastructure.se/trustanchor` |
| Resolve endpoint | `https://qa.fed.ena-infrastructure.se/trustanchor/resolve` |
| Trust Anchor Federation Key | To be added (PEM and JWK) |

## Sandbox {#sandbox}

### Trust Anchor {#sandbox_trust_anchor}

| Property | Value |
| --- | --- |
| Entity Identifier | `https://fed.sandbox.ena-infrastructure.se/trustanchor` |
| Resolve endpoint | `https://fed.sandbox.ena-infrastructure.se/trustanchor/resolve` |
| Trust Anchor Federation Key | To be added (PEM and JWK) |

{backmatter}

<reference anchor="OpenID.Federation" target="https://openid.net/specs/openid-federation-1_0.html">
  <front>
    <title>OpenID Federation 1.0</title>
    <author fullname="Roland Hedberg" initials="R." surname="Hedberg"/>
    <author fullname="Michael B. Jones" initials="M.B." surname="Jones"/>
    <author fullname="Andreas Åkre Solberg" initials="A." surname="Solberg"/>
    <author fullname="John Bradley" initials="J." surname="Bradley"/>
    <author fullname="Giuseppe De Marco" initials="G." surname="De Marco"/>
    <author fullname="Vladimir Dzhuvinov" initials="V." surname="Dzhuvinov"/>
    <date day="17" month="February" year="2026"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.Federation" target="https://www.oidc.se/specifications/swedish-openid-federation-profile.html">
  <front>
    <title>Swedish OpenID Federation Deployment and Interoperability Profile 1.0</title>
    <author fullname="Martin Lindström" initials="M." surname="Lindström"/>
    <author fullname="Stefan Santesson" initials="S." surname="Santesson"/>
    <date day="16" month="October" year="2026"/>
  </front>
</reference>

<!-- TODO: target URL, author and date. -->

<reference anchor="Ena.OAuth2">
  <front>
    <title>Ena OAuth 2.0 Interoperability Profile 1.0 – draft 01</title>
    <author fullname="TODO"/>
  </front>
</reference>

<!-- TODO: target URL and date. -->

<reference anchor="BAS.Rules">
  <front>
    <title>BAS: Federation Rules and Policies 1.0 – draft 02</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
  </front>
</reference>

<!-- TODO: target URL, author and date. -->

<reference anchor="SIB.Registration">
  <front>
    <title>Registration: application requirements and guidance (Registrering – Tillämpningskrav och vägledning), version 13</title>
    <author fullname="TODO"/>
  </front>
</reference>

# Notices

Copyright (c) The Swedish Agency for Digital Government (Digg), 2026. All Rights Reserved.

# Document History

1.0 - draft 01: Initial version.
