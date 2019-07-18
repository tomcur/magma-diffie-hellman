curve_25519_p := 2^255 - 19;

// Prime field of Curve25519.
curve_25519_K<x> := FiniteField(curve_25519_p);

// Montgomery coefficients of Curve25519.
curve_25519_a := 486662 * x;
curve_25519_b := 1 * x;

curve_25519 := EllipticCurve([0, curve_25519_a, 0, curve_25519_b, 0]);

curve_25519_G := 9;
curve_25519_generator := Points(curve_25519, curve_25519_G)[1];

// Some checks:
procedure curve_25519_check()
    subgroup_order := Order(curve_25519_generator);
    cofactor := Order(curve_25519) / subgroup_order;

    assert subgroup_order eq 2^252 + 27742317777372353535851937790883648493;
    assert cofactor eq 8;
    print("Curve validated.");
end procedure;
