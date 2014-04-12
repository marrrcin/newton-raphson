program Test_Newtoncoeffns;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..20] of Extended;
var i, n, st : Integer;
    f        : vector;
    x        : vector1;
{$I A:\INTERPOL\NEWTCNS.PAS}
begin
  ClrScr;
  Writeln ('* Newtoncoeffns test *');
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
  Writeln;
  Newtoncoeffns (n, x, f, st);
  for i:=0 to n do
    Writeln ('f[', i, '] = ', f[i]);
  Writeln ('st = ', st);
  Readln
end.