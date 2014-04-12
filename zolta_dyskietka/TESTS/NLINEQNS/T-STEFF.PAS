program Test_Steffensen;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var it, mit, st     : Integer;
    x0, eps, fatx : Extended;
{$I A:\NLINEQNS\STEFFEN.PAS}
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
  Writeln ('* Steffensen test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('Steffensen (x0, g, mit, eps, fatx, it, st) = ',
           Steffensen (x0, g, mit, eps, fatx, it, st));
  Writeln ('fatx = ', fatx, '   it = ', it, '   st = ', st);
  Readln
end.