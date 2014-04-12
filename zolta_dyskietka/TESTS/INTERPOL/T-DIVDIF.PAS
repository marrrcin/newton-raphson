program Test_divdifferences;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    f, x     : vector;
{$I A:\INTERPOL\DIVDFFNS.PAS}
begin
  ClrScr;
  Writeln ('* divdifferences test *');
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
  Writeln;
  divdifferences (n, x, f, st);
  for i:=0 to n do
    Writeln ('f[', i, '] = ', f[i]);
  Writeln ('st = ', st);
  Readln
end.