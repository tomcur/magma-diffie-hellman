intrinsic Curve25519() -> CryptoCrvEll
{Create Curve25519.}
    // Prime field of Curve25519.
    K := FiniteField(2^255 - 19);

    return CryptoEllipticCurve(
        [K!0, 486662, 0, 1, 0],
        K!9,
        2^252 + 27742317777372353535851937790883648493,
        8
   );
end intrinsic;
