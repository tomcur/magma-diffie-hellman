AttachSpec("spec");

load 'math.m';
load 'test.m';

// Some checks:
procedure curve_25519_check()
    crv := Curve25519();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;

function diffie_hellman_key_exchange(finite_cyclic_group)
    dh := DiffieHellmanProtocol(finite_cyclic_group);

    secrets := SetPartialSecrets(dh);
    secret_alice := Random(secrets);
    secret_bob := Random(secrets);
    public_alice := PublicKey(secret_alice);
    public_bob := PublicKey(secret_bob);
    shared_alice := DiffieHellman(secret_alice, public_bob);
    shared_bob := DiffieHellman(secret_bob, public_alice);

    print
        "Alice calculated shared secret:",
        shared_alice;
    print
        "Bob calculated shared secret:  ",
        shared_alice;

    return (shared_alice`Point`Value eq shared_bob`Point`Value);
end function;
