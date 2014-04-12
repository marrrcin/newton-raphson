program Test_trigpolapprox;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector0 = array [0..10] of Extended;
var i, k, n, st : Integer;
    f           : vector;
    a, b        : vector0;
{$I A:\APPROX\TRIGAPPR.PAS}
begin
  ClrScr;
  Writeln ('* trigpolapprox test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Write ('k (<=10 due to the definition of type "vector0") = ');
  Readln (k);
  Writeln;
  trigpolapprox (n, f, k, a, b, st);
  for i:=0 to k do
    Writeln ('a[', i, '] = ', a[i]);
  for i:=1 to k do
    Writeln ('b[', i, '] = ', b[i]);
  Writeln ('st = ', st);
  Readln
end.