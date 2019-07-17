// Convert an integer to a sequence of numbers in a given base.
IntegerToBase := function(n, base)
  assert n ge 0;
  assert base ge 0;

  v := base;
  seq := [];
  while n gt 0 do
    Append(~seq, n mod base);
    n := n div base;
  end while;
  return seq;
end function;

// Convert an integer to a sequence of binary numbers.
IntegerToBinary := function(n)
  return IntegerToBase(n, 2);
end function;

IntegerToBinaryTest := procedure()
  for n := 0 to 32 do
    ourSeq := IntegerToBinary(n);
    builtinSeq := IntegerToSequence(n, 2);
    if not ourSeq eq builtinSeq then
      print(n);
      print(ourSeq);
      print(builtinSeq);
    end if;
  end for;
end procedure;

// Calculates a^m mod n.
FastExp := function(a, m, n)
  assert a ge 0;
  assert m ge 0;
  assert n ge 0;

  if m eq 0 then
    return 1 mod n;
  end if;

  exp := IntegerToBinary(m);

  inner := a;
  outer := 1;

  for b in Prune(exp) do
    if b eq 0 then
      // Even, so (x^2)^(n div 2)
      inner *:= inner mod n;
    else
      // Odd, so x*(x^2)^(n div 2)
      outer *:= inner mod n;
      inner *:= inner mod n;
    end if;
  end for;

  return outer * inner mod n;
end function;
