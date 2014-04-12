program Test_clampedsplinevalue;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [0..19] of Extended;
     vector2 = array [1..20] of Extended;
var i, n, st       : Integer;
    f1x0, f1xn, xx : Extended;
    x, f           : vector;
{$I A:\INTERPOL\CSPLVAL.PAS}
begin
  ClrScr;
  Writeln ('* clampedsplinevalue test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector", "vector1" and '
         +'"vector2") = ');
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
  Write ('f''(x[0]) = ');
  Readln (f1x0);
  Write ('f''(x[', n, ']) = ');
  Readln (f1xn);
  Write ('xx = ');
  Readln (xx);
  Writeln;
  Writeln ('clampedsplinevalue (n, x, f, f1x0, f1xn, xx, st) = ',
           clampedsplinevalue (n, x, f, f1x0, f1xn, xx, st));
  Writeln ('st = ', st);
  Readln
end.