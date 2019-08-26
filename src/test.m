procedure curve_25519_check()
    crv := Curve25519();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;

procedure curve_p192_check()
    crv := CurveP192();
    assert ValidateParameters(crv);
    assert ValidateSecurity(crv);
    print("Curve validated.");
end procedure;

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

procedure benchmark_dh_curves()
    my_crv := MyCurveP192();
    their_crv := CurveP192();

    t := Cputime();
    SetSeed(42);
    for epoch := 1 to 150 do
        r := diffie_hellman_key_exchange(my_crv, false);
    end for;
    Cputime(t);

    t := Cputime();
    SetSeed(42);
    for epoch := 1 to 150 do
        r := diffie_hellman_key_exchange(their_crv, false);
    end for;
    Cputime(t);
end procedure;
