////////////////////////////////////////////////////////////////////////////////
// An implementation of elliptic curves of the form y^2 = x^3 + ax + b.       //
////////////////////////////////////////////////////////////////////////////////

declare type MyCrvEll[MyPtEll];
declare attributes MyCrvEll: A, B;
declare attributes MyPtEll: X, Y, Z, Parent;

intrinsic Print(crv::MyCrvEll)
{Print crv.}
    printf
        "Elliptic curve y^2 = x^3 + %o*x + %o over %o",
        crv`A,
        crv`B,
        Parent(crv`A);
end intrinsic;

intrinsic Parent(p::MyPtEll) -> MyCrvEll
{Get the parent curve of p.}
    return p`Parent;
end intrinsic;

intrinsic Print(p::MyPtEll)
{Print p.}
    printf "(%o : %o : %o)", p`X, p`Y, p`Z;
end intrinsic;

intrinsic MyEllipticCurve(a::FldFinElt, b::FldFinElt) -> MyCrvEll
{Create a new elliptic curve of the for y^2 = x^3 + ax + b.}
    crv := New(MyCrvEll);
    crv`A := a;
    crv`B := b;
    return crv;
end intrinsic;

intrinsic Point(crv::MyCrvEll, x::FldFinElt) -> BoolElt, MyPtEll
{Return a point on the curve at the given x-coordinate.}
    isSquare, root := IsSquare(x^3 + crv`A * x + crv`B);
    if isSquare then
        if -root lt root then
            root := -root;
        end if;
        res := New(MyPtEll);
        res`X := x;
        res`Y := root;
        res`Z := 1;
        res`Parent := crv;

        return true, res;
    else
        return false, O(crv);
    end if;
end intrinsic;

intrinsic O(crv::MyCrvEll) -> MyPtEll
{Return the point at infinity on the curve.}
    res := New(MyPtEll);
    res`X := 0;
    res`Y := 1;
    res`Z := 0;
    res`Parent := crv;
    return res;
end intrinsic;

intrinsic Zero(crv::MyCrvEll) -> MyPtEll
{Return the neutral point for the curve (zero/infinity).}
    return O(crv);
end intrinsic;

intrinsic '+'(p::MyPtEll, q::MyPtEll) -> MyPtEll
{Calculate p+q.}
    if p`Z eq 0 then
        return q;
    elif q`Z eq 0 then
         return p;
    end if;

    if p`X eq q`X then
        if p`Y eq -q`Y then
            return O(Parent(p));
        else
            s := (3 * p`X^2 + Parent(p)`A) / (2 * p`Y);
            x := s^2 - 2 * p`X;
            y := p`Y + s * (x - p`X);

            res := New(MyPtEll);
            res`X := x;
            res`Y := -y;
            res`Z := 1;
            res`Parent := Parent(p);
            return res;
        end if;
    else
        s := (p`Y - q`Y) / (p`X - q`X);
        x := s^2 - p`X - q`X;
        y := p`Y + s * (x - p`X);

        res := New(MyPtEll);
        res`X := x;
        res`Y := -y;
        res`Z := 1;
        res`Parent := Parent(p);
        return res;
    end if;

end intrinsic;

intrinsic '*'(p::MyPtEll, n::RngIntElt) -> MyPtEll
{Calculate n*p.}
    return FastMultiply(p, n);
end intrinsic;

intrinsic '-'(p::MyPtEll) -> MyPtEll
{Calculate -p.}
    res := New(MyPtEll);
    res`X := p`X;
    res`Y := -p`Y;
    res`Z := p`Z;
    res`Parent := p`Parent;
    return res;
end intrinsic;

intrinsic '-'(p::MyPtEll, q::MyPtEll) -> MyPtEll
{Calculate p-q.}
    return p + (-q);
end intrinsic;

intrinsic 'eq'(p1::MyPtEll, p2::PtEll) -> BoolElt
{Check for equality between p1 and p2.}
    return p1`X eq p2[1] and p1`Y eq p2[2] and p1`Z eq p2[3];
end intrinsic;

intrinsic 'eq'(p1::MyPtEll, p2::MyPtEll) -> BoolElt
{Check for equality between p1 and p2.}
    return p1`X eq p2`X and p1`Y eq p2`Y and p1`Z eq p2`Z;
end intrinsic;
