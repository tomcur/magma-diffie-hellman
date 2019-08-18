declare type CryptoModp[CryptoModpElt]: FinCycGrp;
declare type CryptoModpElt: FinCycGrpElt;
declare attributes CryptoModp: Prime, PrimitiveRoot;

intrinsic Print(modp::CryptoModp)
{Print modp}
    printf
        "Crypto-modp group with prime %o and primitive root %o",
        modp`Prime,
        modp`PrimitiveRoot;
end intrinsic;

intrinsic CryptoModularExponentialGroup(
    prime::RngIntElt,
    primitiveRoot::FldFinElt
) -> CryptoModp
{Create a modp-group for cryptographic purposes with given prime and primitive
root over the ring of integers.

The parameters of the modp-group can be checked using `ValidateParameters`.
}
    modp := New(CryptoModp);
    modp`Prime := prime;
    modp`PrimitiveRoot := primitiveRoot;
    return modp;
end intrinsic;

intrinsic ValidateParameters(modp::CryptoModp) -> BoolElt
{Validate the prime and primitive root of the modular-exponential group.}
    return IsPrime(modp`Prime) and IsPrimitive(modp`PrimitiveRoot, modp`Prime);
end intrinsic;

intrinsic GeneratingElement(modp::CryptoModp) -> CryptoModpElt
{Get the generating element of the crypto-modp group.}
    elt := New(CryptoModpElt);
    elt`Value := modp`PrimitiveRoot;
    elt`Parent := modp;
    return elt;
end intrinsic;

intrinsic Order(modp::CryptoModp) -> RngIntElt
{Get the order of the crypto-modp group.}
    return modp`Prime;
end intrinsic;

intrinsic '^'(e::CryptoModpElt, n::RngIntElt) -> CryptoModpElt
{Return e^n.}
    e`Value := e`Value ^ n;
    return e;
end intrinsic;
