program Test_Simpson;
{$N+,E-}
uses Crt;
type vector = array [1..100] of Extended;
     fx     = function (x : Extended) : Extended;
var n, st     : Integer;
    a, b, eps : Extended;
{$I A:\INTEGR\SIMPSON.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Exp(x)
end;}
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x/2)*Sin(x)/(17-8*Cos(x))
end;}
begin
  ClrScr;
  Writeln ('* Simpson test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('eps = ');
  Readln (eps);
  Write ('n (<=100 due to the definition of type "vector") = ');
  Readln (n);
  Writeln;
  Writeln ('Simpson (a, b, f, eps, n, st) = ', Simpson(a, b, f, eps, n, st));
  Writeln ('st = ', st);
  Readln
end.