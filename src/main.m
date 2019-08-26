AttachSpec("spec");

function diffie_hellman_key_exchange(finite_cyclic_group, do_print)
    dh := DiffieHellmanProtocol(finite_cyclic_group);

    secrets := SetPartialSecrets(dh);
    secret_alice := Random(secrets);
    secret_bob := Random(secrets);
    public_alice := PublicKey(secret_alice);
    public_bob := PublicKey(secret_bob);
    shared_alice := DiffieHellman(secret_alice, public_bob);
    shared_bob := DiffieHellman(secret_bob, public_alice);

    if do_print then
        print
            "Alice:",
            secret_alice;
        print
            "Bob:  ",
            secret_bob;
        print
            "Alice:",
            public_alice;
        print
            "Bob:  ",
            public_bob;
        print
            "Alice:",
            shared_alice;
        print
            "Bob:  ",
            shared_bob;
    end if;

    return (shared_alice`Point`Value eq shared_bob`Point`Value), shared_alice`Point`Value;
end function;

load 'test.m';
