program Test_Newtonvalue;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    f        : vector;
    x        : vector1;
{$I A:\INTERPOL\NEWTVAL.PAS}
begin
  ClrScr;
  Writeln ('* Newtonvalue test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "vector1") = ');
  Readln (n);
  for i:=1 to n do
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
  Writeln ('Newtonvalue (n, x, f, xx, st) = ', Newtonvalue (n, x, f, xx, st));
  Writeln ('st = ', st);
  Readln
end.