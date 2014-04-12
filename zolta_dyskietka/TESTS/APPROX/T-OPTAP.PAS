program Test_optapprox;
{$N+,E-}
uses Crt;
type vector  = array [0..15] of Extended;
     vector0 = array [0..30] of Extended;
     vector1 = array [0..19] of Integer;
     vector2 = array [-1..19] of Extended;
var i, n, p, st : Integer;
    error       : Extended;
    a           : vector;
    x, f        : vector0;
{$I A:\APPROX\OPTAPPR.PAS}
begin
  ClrScr;
  Writeln ('* optapprox test *');
  Writeln;
  Write ('n (<=15 due to the definitions of types "vector", "vector1" and '
         +'"vector2") = ');
  Readln (n);
  Write ('p (<=30 due to the definiton of type "vector0") = ');
  Readln (p);
  for i:=0 to p do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=0 to p do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Writeln;
  optapprox (n, p, x, f, a, error, st);
  for i:=0 to n do
    Writeln ('a[', i, '] = ', a[i]);
  Writeln ('error = ', error);
  Writeln ('st = ', st);
  Readln
end.