program Test_polapprox;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector0 = array [0..15] of Extended;
     vector1 = array [1..15] of Integer;
     matrix  = array [0..15, 0..15] of Extended;
var i, n, m, st : Integer;
    h           : Extended;
    f, x        : vector;
    a           : vector0;
{$I A:\APPROX\POLAPPR.PAS}
begin
  ClrScr;
  Writeln ('* polapprox test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=1 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Write ('m (<=15 due to the definitions of types "vector0", "vector1" and '
         +'"matrix") = ');
  Readln (m);
  Writeln;
  polapprox (n, x, f, m, a, h, st);
  for i:=0 to m do
    Writeln ('a[', i, '] = ', a[i]);
  Writeln ('h = ', h);
  Writeln ('st = ', st);
  Readln
end.