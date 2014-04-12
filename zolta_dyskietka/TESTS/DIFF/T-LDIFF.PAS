program Test_Lagrangediff;
{$N+,E-}
uses Crt, Dos;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    x, y     : vector;
{$I A:\DIFF\LAGRDIFF.PAS}
begin
  ClrScr;
  Writeln ('* Lagrangediff test *');
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
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  Write ('xx = ');
  Readln (xx);
  Writeln ('Lagrangediff (n, x, y, xx, st) = ', Lagrangediff(n, x, y, xx, st));
  Writeln ('st = ', st);
  Readln
end.