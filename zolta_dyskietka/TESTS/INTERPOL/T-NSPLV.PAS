program Test_naturalsplinevalue;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..18] of Extended;
     vector2 = array [2..19] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    x, f     : vector;
{$I A:\INTERPOL\NSPLVAL.PAS}
begin
  ClrScr;
  Writeln ('* naturalsplinevalue test *');
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
  Write ('xx = ');
  Readln (xx);
  Writeln;
  Writeln ('naturalsplinevalue (n, x, f, xx, st) = ',
           naturalsplinevalue (n, x, f, xx, st));
  Writeln ('st = ', st);
  Readln
end.