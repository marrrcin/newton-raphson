program Test_linearintpol;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var a, b, fatx : Extended;
{$I A:\NLINEQNS\LININTPL.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x-2
end;
{function f (x : Extended) : Extended; far;
begin
  f:=x*Exp(Sqrt(x+1))-1
end;}
begin
  ClrScr;
  Writeln ('* linearintpol test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Writeln ('linearintpol (a, b, f, fatx) = ', linearintpol (a, b, f, fatx));
  Writeln ('fatx = ', fatx);
  Readln
end.