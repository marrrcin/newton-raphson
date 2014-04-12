program Test_Legendre;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..50] of Extended;
     matrix  = array [1..20, 1..20] of Extended;
     fx      = function (x : Extended) : Extended;
var i, n1, m, st : Integer;
    eps, x1, x2  : Extended;
    a            : vector;
{$I A:\APPROX\LEGENDRE.PAS}
 function f (x : Extended) : Extended; far;
begin
  f:=x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=x*(x-3)+2
end;}
begin
  ClrScr;
  Writeln ('* Legendre test *');
  Writeln;
  Write ('n1 (<=20 due to the definitions of types "vector" and "matrix") = ');
  Readln (n1);
  Write ('x1 = ');
  Readln (x1);
  Write ('x2 = ');
  Readln (x2);
  Write ('eps = ');
  Readln (eps);
  Write ('m (<=50 due to the definiton of type "vector1") = ');
  Readln (m);
  Writeln;
  Legendre (n1, f, x1, x2, eps, m, a, st);
  for i:=1 to n1 do
    Writeln ('a[', i, '] = ', a[i]);
  Writeln ('st = ', st);
  Readln
end.