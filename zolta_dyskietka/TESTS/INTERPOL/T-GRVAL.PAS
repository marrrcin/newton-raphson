program Test_GReinschvalue;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    x        : Extended;
    f        : vector;
{$I A:\INTERPOL\GRVAL.PAS}
begin
  ClrScr;
  Writeln ('* GReinschvalue test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Write ('x = ');
  Readln (x);
  Writeln;
  Writeln;
  Writeln ('GReinschvalue (n, f, x, st) = ', GReinschvalue (n, f, x, st));
  Writeln ('st = ', st);
  Readln
end.