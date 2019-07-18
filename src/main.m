Attach("elliptic_curve.m");

load 'math.m';
load 'diffie_hellman.m';

// Some checks:
procedure curve_25519_check()
    crv := Curve25519();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;
