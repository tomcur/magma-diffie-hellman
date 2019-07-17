load 'math.m';

// Given public primes P, G, and a partial secret `a` s.t. its shared secret is
// `xa = G^a mod P`, and a shared secret `xb = G^b mod P` (with `b` unknown),
// calculate the symmetric secret key `k = xb^a mod P`.
SecretKey := function(P, partial_secret, shared_secret)
    return FastExp(shared_secret, partial_secret, P);
end function;
