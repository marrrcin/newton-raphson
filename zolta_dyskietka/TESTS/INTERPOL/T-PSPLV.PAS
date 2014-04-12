program Test_periodsplinevalue;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..20] of Extended;
     vector2 = array [1..19] of Extended;
     vector3 = array [2..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    x, f     : vector;
{$I A:\INTERPOL\PSPLVAL.PAS}
begin
  ClrScr;
  Writeln ('* periodsplinevalue test *');
  Writeln;
  Writeln ('n (<=20 due to the definitions of types "vector", "vector1", '
           +'"vector2"');
  Write ('   and "vector3") = ');
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
  Writeln ('periodsplinevalue (n, x, f, xx, st) = ',
           periodsplinevalue (n, x, f, xx, st));
  Writeln ('st = ', st);
  Readln
end.