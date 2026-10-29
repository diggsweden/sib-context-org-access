%%%
title = "BAS: Federation Security Requirements 1.0 – draft 01"
abbrev = "BAS Federation Security Requirements"
ipr = "none"
workgroup = ""
keyword = ["oauth 2.0", "openid federation"]
date = 2026-10-23T00:00:00Z

[seriesInfo]
name = "Internet-Draft"
value = "BAS Security Requirements"
status = "informational"

[[author]]
initials = "H."
surname = "Norlander"
fullname = "Henric Norlander"
organization = "The Swedish Agency for Digital Government (Digg)"
  [author.address]
  email = "extern.henric.norlander@digg.se"
  emails = ["henric@nodnio.se"]
%%%

.# Abstract

This specification defines security requirements for OAuth 2.0 Clients,
Authorization Servers and Protected Resources participating in BAS. It
establishes requirements for transport protection, client authentication,
keys, signature algorithms and key rollover. The requirements extend, and are
intended to be read together with, BAS: Federation Metadata Requirements
[@!BAS.Metadata] and the Ena OAuth 2.0 Interoperability Profile
[@!Ena.OAuth2].

.# Registration Number

<YYYY-nnnn>

{mainmatter}

# Introduction {#introduction}

BAS (Swedish: Federationskontext BAS) is a federation context for
machine-to-machine access within, and towards, the Swedish public sector,
governed by [@!BAS.Rules]. Its Entities are OAuth 2.0 Clients, Authorization
Servers and Protected Resources, whose metadata requirements are stated in
[@!BAS.Metadata]. These Entities rely on signatures to authenticate each other
and to protect access tokens. A common set of requirements is therefore needed
for how transport security is applied, how Entities authenticate, which keys
and signature algorithms are acceptable, and how keys are replaced without
disrupting other parties.

This specification collects those requirements in one place. The requirements
of [@!Ena.OAuth2, section 8], the profile that BAS applies, apply to every
Entity in BAS. This specification restates those that concern keys and
algorithms, states how they are interpreted within BAS, and adds the
requirements that follow from operating in a federation, where the metadata of
one Entity is consumed by many peers.

The requirements apply to protocol keys, published in the `oauth_client`,
`oauth_authorization_server` or `oauth_resource` metadata of an Entity, see
[@!OpenID.Federation.Connect, section 5.1] and [@!BAS.Metadata, section 2.2].
They do not apply to Federation Entity Keys or to the signing of Entity
Statements, for which [@!OIDC.Sweden.Federation, section 6] applies, see
[@!BAS.Rules, section 9].

## Requirements Notation and Conventions {#requirements_notation_and_conventions}

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in
this document are to be interpreted as described in BCP 14 [@!RFC2119]
[@!RFC8174] when, and only when, they appear in all capitals, as shown here.

## Terminology {#terminology}

This specification uses the terms "Entity", "Entity Configuration",
"Federation Entity Key", "Trust Anchor" and "Resolved Metadata" as defined in
[@!OpenID.Federation], the terms "Client", "Authorization Server" and
"Protected Resource" as defined in [@!Ena.OAuth2], and the terms "Federation
Operator" and "Collaboration Context" (Swedish: samverkanskontext) as defined
in [@!BAS.Rules, section 1.2].

# General Security Requirements {#general_security_requirements}

All communication between Entities **MUST** be protected by TLS as stated in
[@!Ena.OAuth2, section 8.1]. Entities **SHOULD** also conform to the
applicable recommendations of [@!RFC9700].

`private_key_jwt` is the only client authentication method used within BAS. A
Client **MUST** use it at the token endpoint, with keys published in its
Resolved Metadata.

Revocation [@!RFC7009] and introspection [@!RFC7662] are outside the scope of
[@!Ena.OAuth2], and whether an Authorization Server offers them is decided by
the parties to an exchange. Where they are used within BAS, the calling Entity
**MUST** authenticate using `private_key_jwt`, with keys published in its
Resolved Metadata. At a revocation endpoint the caller is a Client. At an
introspection endpoint the caller is normally a Protected Resource, which
**MUST** then publish its keys in its `oauth_resource` metadata, see
[@!BAS.Metadata, section 2.2].

An Authorization Server **MUST NOT** accept any other client authentication
method from an Entity in BAS.

Symmetric signature algorithms, and any mechanism based on a secret shared
between two Entities, **MUST NOT** be used. Every signature in BAS can
therefore be verified with a public key obtained through the signer's Resolved
Metadata.

The Federation Operator enforces the client authentication method, and the
algorithm values required by (#signature_algorithms),
(#signature_algorithms, use title), through the Trust Anchor metadata policy
stated in
[@!BAS.Metadata, section 7.1]. Other requirements in this document are
verified by the parties to an exchange.

# Cryptographic Requirements {#cryptographic_requirements}

BAS does not require support for OpenID Connect Relying Party Metadata Choices
1.0. As [@!OIDC.Sweden.Federation, section 7] permits, the interoperability
issues that specification addresses are instead handled by a single client
authentication method, see (#general_security_requirements),
(#general_security_requirements, use title), and a common set of signature
algorithms that all Entities support for validation, see
(#signature_algorithms), (#signature_algorithms, use title).

Protocol messages in BAS are protected by TLS and are not encrypted. No
encryption algorithms are therefore mandatory, and no Entity is required to
support encryption. This fulfils the requirement of
[@!OIDC.Sweden.Federation, section 7] that federation rules cover encryption
algorithms.

## Signature Algorithms {#signature_algorithms}

Entities **MUST** meet the requirements on algorithms and key lengths of
[@!Ena.OAuth2, section 8.2]. All Entities **MUST** support validation of
signatures using RS256 and ES256 [@!RFC7518], as
[@!Ena.OAuth2, section 8.2] requires. All Entities **SHOULD** also support
validation of signatures using RS384, RS512, ES384 and ES512, so that the full
set recommended by [@!OIDC.Sweden.Federation, section 7] is supported. That
set is the one [@!OIDC.Sweden.Federation, section 6] requires for validation
of Entity Statements. The requirements apply to validation only: an Entity
that produces signatures **MAY** use a single algorithm and a single key type.

An Authorization Server's `token_endpoint_auth_signing_alg_values_supported`
**MUST** contain RS256 and ES256, and **SHOULD** contain RS384, RS512, ES384
and ES512.

The algorithm `none`, the HS256, HS384 and HS512 algorithms, and any algorithm
that relies on SHA-1, **MUST NOT** be used.

## Collaboration Contexts {#collaboration_contexts}

A Collaboration Context **MAY** restrict which of the algorithms permitted by
(#signature_algorithms), (#signature_algorithms, use title), are used within
it, as [@!BAS.Rules, section 1.2] allows. It **MUST NOT** permit an algorithm
that (#signature_algorithms), (#signature_algorithms, use title), prohibits,
and **MUST NOT** remove the requirement to support validation of RS256 and
ES256.

# Key Rollover {#key_rollover}

An Entity **MUST** replace a key without disrupting its peers. To allow every
peer to select the correct key during a rollover, each JWK in the JWK Set of
an Entity **MUST** include a `kid` parameter [@!RFC7517], also when the JWK
Set holds a single key, and the value **MUST** be unique within the JWK Set.
Every signed object **MUST** include the `kid` of the signing key in its JOSE
header. How often an Entity replaces its keys is stated in [@!BAS.Rules], as
[@!OIDC.Sweden.Federation, section 2.1] recommends.

The following requirements apply to a planned key rollover.

- An Entity **MUST** publish a new key before using it. The time between
  publication and first use **MUST** be at least as long as a peer may hold a
  cached copy of a JWK Set that does not contain the new key. For keys in
  `jwks`, this is the time until the `exp` of the last Entity Configuration
  published without the new key, see [@!OpenID.Federation, section 3.1] and
  [@!BAS.Rules, section 3.1]. For keys at `jwks_uri`, it is the cache
  lifetime of the JWK Set document.
- An Entity that publishes its keys at `jwks_uri` **SHOULD** state the cache
  lifetime of the JWK Set document using HTTP caching headers, such as
  `Cache-Control`.
- An Entity **MUST** keep the previous key in its JWK Set until every object
  signed with it has expired, and **SHOULD** remove it after that. For an
  Authorization Server, this is the longest remaining lifetime of the access
  tokens it has signed with that key.
- An Entity that verifies signatures **MUST** be able to handle a JWK Set
  holding several keys, and **MUST** select the key by the `kid` in the signed
  object.
- An Entity that receives a signed object with a `kid` it does not recognise
  **SHOULD** obtain the signer's JWK Set again before rejecting the object, by
  fetching the `jwks_uri` document or by resolving the signer's metadata anew.
  It **SHOULD** limit how often it does so for a given signer.

If a key is compromised, the Entity **MUST** remove it from its JWK Set
immediately, without observing the time limits above. Peers may continue to
accept the key until their cached copy of the JWK Set expires, which bounds
the exposure.

{backmatter}

<reference anchor="BAS.Metadata">
  <front>
    <title>BAS: Federation Metadata Requirements, draft 04</title>
    <author>
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<reference anchor="BAS.Rules">
  <front>
    <title>BAS: Federation Rules and Policies 1.0, draft 02</title>
    <author fullname="Henric Norlander" initials="H." surname="Norlander">
      <organization>The Swedish Agency for Digital Government (Digg)</organization>
    </author>
    <date month="October" year="2026"/>
  </front>
</reference>

<!-- [PLATSHÅLLARE] Author and date of Ena.OAuth2 are not known. -->

<reference anchor="Ena.OAuth2" target="https://ena-infrastructure.github.io/specifications/ena-oauth2-profile.html">
  <front>
    <title>Ena OAuth 2.0 Interoperability Profile 1.0, draft 01</title>
    <author fullname="<Full Name>" initials="<X.>" surname="<Surname>"/>
    <date day="<dd>" month="<Month>" year="<YYYY>"/>
  </front>
</reference>

<reference anchor="OIDC.Sweden.Federation" target="https://www.oidc.se/specifications/swedish-openid-federation-profile.html">
  <front>
    <title>Swedish OpenID Federation Deployment and Interoperability Profile 1.0, draft 03</title>
    <author fullname="M. Lindström" initials="M." surname="Lindström"/>
    <author fullname="S. Santesson" initials="S." surname="Santesson"/>
    <date day="2" month="October" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation" target="https://openid.net/specs/openid-federation-1_1.html">
  <front>
    <title>OpenID Federation 1.1</title>
    <author fullname="R. Hedberg" initials="R." surname="Hedberg"/>
    <author fullname="M. B. Jones" initials="M. B." surname="Jones" role="editor"/>
    <author fullname="G. De Marco" initials="G." surname="De Marco"/>
    <author fullname="A. Å. Solberg" initials="A. Å." surname="Solberg"/>
    <author fullname="J. Bradley" initials="J." surname="Bradley"/>
    <author fullname="V. Dzhuvinov" initials="V." surname="Dzhuvinov"/>
    <date day="5" month="May" year="2026"/>
  </front>
</reference>

<reference anchor="OpenID.Federation.Connect" target="https://openid.net/specs/openid-federation-connect-1_1.html">
  <front>
    <title>OpenID Federation for OpenID Connect 1.1</title>
    <author fullname="R. Hedberg" initials="R." surname="Hedberg"/>
    <author fullname="M. B. Jones" initials="M. B." surname="Jones" role="editor"/>
    <author fullname="G. De Marco" initials="G." surname="De Marco"/>
    <author fullname="A. Å. Solberg" initials="A. Å." surname="Solberg"/>
    <author fullname="J. Bradley" initials="J." surname="Bradley"/>
    <author fullname="V. Dzhuvinov" initials="V." surname="Dzhuvinov"/>
    <date day="5" month="May" year="2026"/>
  </front>
</reference>

# Notices

Copyright (c) The Swedish Agency for Digital Government (Digg), 2026. All
Rights Reserved.

# Document History

1.0 - draft 01: Initial version.

