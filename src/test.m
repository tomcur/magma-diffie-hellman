// Test whether Magma believes curve Curve25519 has secure parameters.
procedure curve_25519_check()
    crv := Curve25519();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;

// Test whether Magma believes curve P-192 has secure parameters.
procedure curve_p192_check()
    crv := CurveP192();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;

// Assert whether e1 and e2 are 'eq', or print 'msg' otherwise.
procedure assert_equal(msg, e1, e2)
    if e1 ne e2 then
        error msg, Sprintf("LHS: %o", e1), Sprintf("RHS: %o", e2);
    end if;
end procedure;

// Test whether calculations on MyEllipticCurve agree with calculations on
// the Magma-provided EllipticCurve.
procedure test_my_elliptic_curve()
    F := FiniteField(343373);

    a := F!3333;
    b := F!260;
    my_crv := MyEllipticCurve(a, b);
    their_crv := EllipticCurve([a, b]);

    for epoch := 1 to 5000 do
        x := Random(F);
        my_has_p, my_p := Point(my_crv, x);
        their_ps := Points(their_crv, x);

        if my_has_p ne (#their_ps ne 0) then
            print "Got", my_has_p;
            print "Expected", their_ps;
        end if;

        if #their_ps eq 0 then
            continue;
        end if;

        their_p := their_ps[1];
        assert_equal("", my_p, their_p);
        assert_equal("-unary", -my_p, -their_p);
        assert_equal("+binary", my_p + my_p, their_p + their_p);
        assert_equal("+binary +binary", my_p + my_p + my_p, their_p + their_p + their_p);
        assert_equal("-binary", my_p - my_p, their_p - their_p);

        my_o := my_p - my_p;
        their_o := their_p - their_p;
        assert_equal("O", my_o, their_o);
        assert_equal("+O", my_p + my_o, their_p + their_o);
        assert_equal("-O", my_p - my_o, their_p - their_o);

        n := IntegerRing()!Random(F);
        assert_equal("*n", my_p * n, their_p * n);
    end for;
end procedure;

// Benchmark the elliptic curve implementations.
//
// With curve P-192, these are some sample results (in seconds):
// > Benchmarking Generator+Generator for 250000 rounds
// > Custom: 1.710
// > Magma:  0.560
// > Benchmarking Generator^5000 for 7500 rounds
// > Custom: 1.500
// > Magma:  0.320
// > Benchmarking Diffie-Hellman key exchange for 150 rounds
// > Custom: 2.000
// > Magma:  0.360
procedure benchmark_curves()
    my_crv := MyCurveP192();
    their_crv := CurveP192();

    my_g := GeneratingElement(my_crv);
    my_g_v := my_g`Value;
    their_g := GeneratingElement(their_crv);
    their_g_v := their_g`Value;

    rounds := 250000;
    print "Benchmarking Generator+Generator for", rounds, "rounds";

    t := Cputime();
    for epoch := 0 to rounds do
        r := my_g_v+my_g_v;
    end for;
    print "Custom:", Cputime(t);

    t := Cputime();
    for epoch := 0 to rounds do
        r := their_g_v+their_g_v;
    end for;
    print "Magma: ", Cputime(t);

    rounds := 7500;
    print "Benchmarking Generator^5000 for", rounds, "rounds";

    t := Cputime();
    for epoch := 0 to rounds do
        r := my_g^5000;
    end for;
    print "Custom:", Cputime(t);

    t := Cputime();
    for epoch := 0 to rounds do
        r := their_g^5000;
    end for;
    print "Magma: ", Cputime(t);

    rounds := 150;
    print "Benchmarking Diffie-Hellman key exchange for", rounds, "rounds";

    t := Cputime();
    SetSeed(42);
    for epoch := 0 to rounds do
        r := diffie_hellman_key_exchange(my_crv, false);
    end for;
    print "Custom:", Cputime(t);

    t := Cputime();
    SetSeed(42);
    for epoch := 0 to rounds do
        r := diffie_hellman_key_exchange(their_crv, false);
    end for;
    print "Magma: ", Cputime(t);
end procedure;

// Test whether the calculated shared secrets match in a round of 2048-bit
// modular exponential Diffie-Hellman key exchange.
procedure test_modp_dh()
    print "Testing  2048-bit modular exponential Diffie-Hellman key exchange";

    if diffie_hellman_key_exchange(ModpGroup2048Bit(), true) then
        print "Calculated shared secrets match.";
    else
        print "Calculated shared secret do not match!";
    end if;
end procedure;

// Test whether the calculated shared secrets match in a round of Curve25519
// elliptic curve Diffie-Hellman key exchange.
procedure test_curve_dh()
    print "Testing Curve25519 elliptic curve Diffie-Hellman key exchange";

    if diffie_hellman_key_exchange(Curve25519(), true) then
        print "Calculated shared secrets match.";
    else
        print "Calculated shared secret do not match!";
    end if;
end procedure;

// Test whether the calculated shared secrets match in a round of P-192
// elliptic curve Diffie-Hellman key exchange for both the custom elliptic
// curve implementation and the implementation provided by Magma.
//
// Also tests whether the two implementations calculate the same shared secret.
procedure test_p192_curve_dh()
    r := Random(0, 2^32-1);

    my_crv := MyCurveP192();
    their_crv := CurveP192();

    print "Testing P-192 custom elliptic curve Diffie-Hellman key exchange";

    SetSeed(r);
    my_match, my_res := diffie_hellman_key_exchange(my_crv, true);
    if my_match then
        print "Calculated shared secrets match.";
    else
        print "Calculated shared secret do not match!";
    end if;

    print "Testing P-192 Magma elliptic curve Diffie-Hellman key exchange";

    SetSeed(r);
    their_match, their_res := diffie_hellman_key_exchange(their_crv, true);
    if their_match then
        print "Calculated shared secrets match.";
    else
        print "Calculated shared secret do not match!";
    end if;

    if my_res eq their_res then
        print "The curve implementations come to the same shared secret.";
    else
        print "The curve implementations do not come to the same shared secret.";
    end if;
end procedure;
