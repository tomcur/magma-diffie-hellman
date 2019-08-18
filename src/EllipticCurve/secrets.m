////////////////////////////////////////////////////////////////////////////////
// A specialized implementation of the Diffie-Hellman protocol over elliptic  //
// curves. See ../DiffieHellman for a generalized implementation.             //
////////////////////////////////////////////////////////////////////////////////

declare type SetParSecCryptoCrvEll[ParSecCryptoCrvEll];
declare attributes SetParSecCryptoCrvEll: Curve;
declare attributes ParSecCryptoCrvEll: Secret, Parent;

intrinsic Print(set_partial_secrets::SetParSecCryptoCrvEll)
{Print set_partial_secrets.}
    printf
        "Set of partial secrets on %o",
        set_partial_secrets`Curve;
end intrinsic;

intrinsic SetPartialSecrets(crv::CryptoCrvEll) -> SetParSecCryptoCrvEll
{Get the set of partial secrets corresponding to a crypto elliptic curve.}
    set := New(SetParSecCryptoCrvEll);
    set`Curve := crv;
    return set;
end intrinsic;

intrinsic Random(set_partial_secrets::SetParSecCryptoCrvEll)
    -> ParSecCryptoCrvEll
{Generate a random partial secret on the subgroup field of a curve.}
    curve := set_partial_secrets`Curve;
    partial_secret := New(ParSecCryptoCrvEll);
    partial_secret`Secret := Random(1, curve`Order - 1);
    partial_secret`Parent := set_partial_secrets;
    return partial_secret;
end intrinsic;

intrinsic Print(partial_secret::ParSecCryptoCrvEll)
{Print partial_secret}
    printf
        "Partial secret %o on a crypto-elliptic curve",
        partial_secret`Secret;
end intrinsic;

intrinsic Parent(partial_secret::ParSecCryptoCrvEll) -> SetParSecCryptoCrvEll
{Get the parent set of partial_secret.}
    return partial_secret`Parent;
end intrinsic;

declare type SetPubKeyCryptoCrvEll[PubKeyCryptoCrvEll];
declare attributes SetPubKeyCryptoCrvEll: SetPartialSecret;
declare attributes PubKeyCryptoCrvEll: Point, Parent;

intrinsic Print(set_public_key::SetPubKeyCryptoCrvEll)
{Print set_public_key}
    printf
        "Set of public keys corresponding to %o",
         set_public_key`SetParSecCryptoCrvEll;
end intrinsic;

intrinsic PublicKeySet(set_partial_secret::SetParSecCryptoCrvEll)
    -> SetPubKeyCryptoCrvEll
{Get the set of public keys corresponding to a set of partial secrets.}
    set := New(SetPubKeyCryptoCrvEll);
    set`SetPartialSecret := set_partial_secret;
    return set;
end intrinsic;

intrinsic Print(public_key::PubKeyCryptoCrvEll)
{Print public_key.}
    printf "Public key %o on crypto-elliptic curve", public_key`Point;
end intrinsic;

intrinsic Parent(public_key::PubKeyCryptoCrvEll) -> SetPubKeyCryptoCrvEll
{Get the parent set of public_key.}
    return public_key`Parent;
end intrinsic;

intrinsic PublicKey(partial_secret::ParSecCryptoCrvEll) -> PubKeyCryptoCrvEll
{Get the public key corresponding to the partial secret.}
    set_partial_secret := Parent(partial_secret);
    curve := set_partial_secret`Curve;

    point := partial_secret`Secret * curve`Generator;

    public_key := New(PubKeyCryptoCrvEll);
    public_key`Point := point;
    public_key`Parent := PublicKeySet(set_partial_secret);

    return public_key;
end intrinsic;

declare type SharedSecCryptoCrvEll;
declare attributes SharedSecCryptoCrvEll: Point;

intrinsic Print(shared_secret::SharedSecCryptoCrvEll)
{Print key}
    printf
        "Shared secret %o on crypto-elliptic curve",
        shared_secret`Point;
end intrinsic;

intrinsic DiffieHellman(
    partial_secret::ParSecCryptoCrvEll,
    public::PubKeyCryptoCrvEll
) -> SharedSecCryptoCrvEll
{Get the shared secret of A and B corresponding to
the partial secret of A and public key of B.}
    n := partial_secret`Secret;
    p := public`Point;

    shared_secret := New(SharedSecCryptoCrvEll);
    shared_secret`Point := n * p;

    return shared_secret;
end intrinsic;
