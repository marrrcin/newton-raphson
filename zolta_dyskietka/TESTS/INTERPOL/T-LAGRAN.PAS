program Test_Lagrange;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    f, x     : vector;
{$I A:\INTERPOL\LAGRANGE.PAS}
begin
  ClrScr;
  Writeln ('* Lagrange test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=0 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Write ('xx = ');
  Readln (xx);
  Writeln;
  Writeln ('Lagrange (n, x, f, xx, st) = ', Lagrange(n, x, f, xx, st));
  Writeln ('st = ', st);
  Readln
end.