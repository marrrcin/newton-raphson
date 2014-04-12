program Test_fixedpoint;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var it, mit, st     : Integer;
    x0, eps, fatx : Extended;
{$I A:\NLINEQNS\FIXPOINT.PAS}
function g (x : Extended) : Extended; far;
begin
  g:=Sqrt(10/(x+4))
end;
{function g (x : Extended) : Extended; far;
begin
  g:=(2-Exp(x)+x*x)/3
end;}
begin
  ClrScr;
  Writeln ('* fixedpoint test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('fixedpoint (x0, g, mit, eps, fatx, it, st) = ',
           fixedpoint (x0, g, mit, eps, fatx, it, st));
  Writeln ('fatx = ', fatx, '   it = ', it, '   st = ', st);
  Readln
end.