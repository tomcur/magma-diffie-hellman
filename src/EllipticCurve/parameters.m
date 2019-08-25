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

intrinsic CurveP192() -> CryptoCrvEll
{Create Curve P-192 as a CryptoEllipticCurve.}
    // Prime field of Curve25519.
    K := FiniteField(6277101735386680763835789423207666416083908700390324961279);

    return CryptoEllipticCurve(
        [K!-3, K!0x64210519e59c80e70fa7e9ab72243049feb8deecc146b9b1],
        K!0x188da80eb03090f67cbf20eb43a18800f4ff0afd82ff1012,
        6277101735386680763835789423176059013767194773182842284081,
        1
   );
end intrinsic;
