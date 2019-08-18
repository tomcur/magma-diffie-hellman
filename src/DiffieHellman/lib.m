////////////////////////////////////////////////////////////////////////////////
// A general implementation of the Diffie-Hellman protocol over a finite      //
// cyclic group of given order generated by a given element.                  //
////////////////////////////////////////////////////////////////////////////////

// The type of finite cyclic groups.
//
// Types implementing `CycGrp` must provide implementations for the
// intrinsic `GeneratingElement` that returns a `CycGrpElt` generating `CycGrp`
// and the intrinsic `Order` that returns the (`RngIntElt`) order of the finite
// cyclic group.
//
// Types implementing CycGrpElt must provide an implementation for the
// intrinsic '^', which is the binary operation on the finite cyclic group.
declare type FinCycGrp[FinCycGrpElt];
declare attributes FinCycGrpElt: Value, Parent;

intrinsic Print(finite_cyclic_group::CycGrp)
{Print the cyclic group.}
    printf
        "A finite cyclic group of order %o with generator %o",
        Order(finite_cyclic_group),
        GeneratingElement(finite_cyclic_group);
end intrinsic;

intrinsic Print(element::FinCycGrpElt)
{Print partial_secret}
    printf
        "%o",
        element`Value;
end intrinsic;

intrinsic Parent(element::FinCycGrpElt) -> FinCycGrp
{Get the parent finite cyclic group of the element.}
    return element`Parent;
end intrinsic;

declare type ParametersDH;
declare attributes ParametersDH: FiniteCyclicGroup;

intrinsic Print(parameters::ParametersDH)
{Print Diffie-Hellman parameters.}
    printf
        "Diffie-Hellman on cyclic group %o",
        parameters`FiniteCyclicGroup;
end intrinsic;

intrinsic DiffieHellman(finite_cyclic_group::FinCycGrp) -> ParametersDH
{Create a Diffie-Hellman protocol with the given parameters.
 `cyclic_group` must be the group the Diffie-Hellman protocol is performed on.
}
    parameters := New(ParametersDH);
    parameters`FiniteCyclicGroup := finite_cyclic_group;
    return parameters;
end intrinsic;

declare type SetParSecDH[ParSecDH];
declare attributes SetParSecDH: Parameters;
declare attributes ParSecDH: Secret, Parent;

intrinsic Print(set_partial_secrets::SetParSecDH)
{Print set_partial_secrets.}
    printf
        "Set of partial Diffie-Hellman secrets on protocol with parameters %o",
        set_partial_secrets`Parameters;
end intrinsic;

intrinsic SetPartialSecrets(parameters::ParametersDH) -> SetParSecDH
{Get the set of partial secrets corresponding to the Diffie-Hellman protocol
 parameters.
}
    set := New(SetParSecDH);
    set`Parameters := parameters;
    return set;
end intrinsic;

intrinsic Random(set_partial_secrets::SetParSecDH) -> ParSecDH
{Generate a random partial secret in the partial secret set of the
 Diffie-Hellman protocol.
}
    parameters := set_partial_secrets`Parameters;
    cyclic_group := parameters`FiniteCyclicGroup;
    g := GeneratingElement(cyclic_group);

    // Security note: this RNG determines, in very large part, the overall
    // security of the implementation of the protocol.
    partial_secret := New(ParSecDH);
    partial_secret`Secret := Random(1, Order(cyclic_group) - 1);
    partial_secret`Parent := set_partial_secrets;
    return partial_secret;
end intrinsic;

intrinsic Print(partial_secret::ParSecDH)
{Print partial_secret}
    printf
        "Partial secret %o on a Diffie-Hellman protocol",
        partial_secret`Secret;
end intrinsic;

intrinsic Parent(partial_secret::ParSecDH) -> SetParSecDH
{Get the parent set of partial_secret.}
    return partial_secret`Parent;
end intrinsic;

declare type SetPubKeyDH[PubKeyDH];
declare attributes SetPubKeyDH: SetPartialSecret;
declare attributes PubKeyDH: Point, Parent;

intrinsic Print(set_public_key::SetPubKeyDH)
{Print set_public_key}
    printf
        "Set of public keys corresponding to %o",
         set_public_key`SetPartialSecret;
end intrinsic;

intrinsic PublicKeySet(set_partial_secret::SetParSecDH)
    -> SetPubKeyDH
{Get the set of public keys corresponding to a set of partial secrets.}
    set := New(SetPubKeyDH);
    set`SetPartialSecret := set_partial_secret;
    return set;
end intrinsic;

intrinsic Print(public_key::PubKeyDH)
{Print public_key.}
    printf "Public key %o on a Diffie-Hellman protocol", public_key`Point;
end intrinsic;

intrinsic Parent(public_key::PubKeyDH) -> SetPubKeyDH
{Get the parent set of public_key.}
    return public_key`Parent;
end intrinsic;

intrinsic PublicKey(partial_secret::ParSecDH) -> PubKeyDH
{Get the public key corresponding to the partial secret.}
    set_partial_secret := Parent(partial_secret);
    parameters := set_partial_secret`Parameters;
    g := GeneratingElement(parameters`FiniteCyclicGroup);

    point := g ^ partial_secret`Secret;

    public_key := New(PubKeyDH);
    public_key`Point := point;
    public_key`Parent := PublicKeySet(set_partial_secret);

    return public_key;
end intrinsic;

declare type SharedSecDH;
declare attributes SharedSecDH: Point;

intrinsic Print(shared_secret::SharedSecDH)
{Print key}
    printf
        "Shared secret %o on a Diffie-Hellman protocol",
        shared_secret`Point;
end intrinsic;

intrinsic DiffieHellman(
    partial_secret::ParSecDH,
    public::PubKeyDH
) -> SharedSecDH
{Get the shared secret of A and B corresponding to
the partial secret of A and public key of B.}
    n := partial_secret`Secret;
    p := public`Point;

    shared_secret := New(SharedSecDH);
    shared_secret`Point := p^n;

    return shared_secret;
end intrinsic;