program Test_GaussChebyshev;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var n, st : Integer;
{$I A:\INTEGR\GCHEBYSH.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sqr(1-x*x)*Cos(x)
end;}
begin
  ClrScr;
  Writeln ('* GaussChebyshev test *');
  Writeln;
  Write ('n = ');
  Readln (n);
  Writeln;
  Writeln ('GaussChebyshev (f, n, st) = ', GaussChebyshev(f, n, st));
  Writeln ('st = ', st);
  Readln
end.