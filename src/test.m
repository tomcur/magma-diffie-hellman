procedure assert_equal(msg, e1, e2)
    if e1 ne e2 then
        error msg, Sprintf("LHS: %o", e1), Sprintf("RHS: %o", e2);
    end if;
end procedure;

procedure test_my_elliptic_curve()
    F := FiniteField(5437);

    a := F!3333;
    b := F!260;
    my_crv := MyEllipticCurve(a, b);
    their_crv := EllipticCurve([a, b]);

    for epoch := 1 to 500 do
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
