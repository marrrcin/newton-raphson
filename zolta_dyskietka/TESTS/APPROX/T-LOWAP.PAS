program Test_lowdegapprox;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
var i, n, p, st : Integer;
    eps         : Extended;
    a           : vector;
{$I A:\APPROX\LOWAPPR.PAS}
begin
  ClrScr;
  Writeln ('* lowdegapprox test *');
  Writeln;
  Write ('n (<=20 due to the definiton of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('eps = ');
  Readln (eps);
  Writeln;
  lowdegapprox (n, a, eps, p, st);
  Writeln ('p = ', p);
  for i:=0 to n do
    Writeln ('a[', i, '] = ', a[i]);
  Writeln ('st = ', st);
  Readln
end.