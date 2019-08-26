AttachSpec("spec");

load 'test.m';

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
            "Alice calculated shared secret:",
            shared_alice;
        print
            "Bob calculated shared secret:  ",
            shared_alice;
    end if;

    return (shared_alice`Point`Value eq shared_bob`Point`Value);
end function;
