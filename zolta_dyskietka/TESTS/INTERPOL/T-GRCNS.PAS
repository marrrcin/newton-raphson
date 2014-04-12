program Test_GReinschcoeffns;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..10] of Extended;
var i, n, m, st : Integer;
    a0, am1     : Extended;
    f           : vector;
    a, b        : vector1;
{$I A:\INTERPOL\GRCNS.PAS}
begin
  ClrScr;
  Writeln ('* GReinschcoeffns test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "vector1") '
         +'= ');
  Readln (n);
  if Odd(n)
    then m:=Round((n-1)/2)
    else m:=Round(n/2);
  Writeln ('m = ', m);
  for i:=0 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Writeln;
  GReinschcoeffns (n, m, f, a0, am1, a, b, st);
  Writeln ('a0   = ', a0);
  Writeln ('am1  = ', am1);
  for i:=1 to m do
    Writeln ('a[', i, '] = ', a[i]);
  for i:=1 to m do
    Writeln ('b[', i, '] = ', b[i]);
  Writeln ('st = ', st);
  Readln
end.