program Test_Newton;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var it, mit, st  : Integer;
    eps, fatx, x : Extended;
{$I A:\NLINEQNS\NEWTON.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x-2
end;
function df (x : Extended) : Extended; far;
begin
  df:=2*x
end;
{function f (x : Extended) : Extended; far;
var s : Extended;
begin
  s:=Sin(x);
  f:=s*(s+0.5)-0.5
end;
function df (x : Extended) : Extended; far;
begin
  df:=Sin(2*x)+0.5*Cos(x)
end;}
begin
  ClrScr;
  Writeln ('* Newton test *');
  Writeln;
  Write ('x = ');
  Readln (x);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('Newton (x, f, df, mit, eps, fatx, it, st) = ',
           Newton (x, f, df, mit, eps, fatx, it, st));
  Writeln ('fatx = ', fatx, '   it = ', it, '   st = ', st);
  Readln
end.