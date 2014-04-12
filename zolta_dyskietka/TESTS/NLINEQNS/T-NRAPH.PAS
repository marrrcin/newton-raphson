program Test_NewtonRaphson;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var it, mit, st  : Integer;
    eps, fatx, x : Extended;
{$I A:\NLINEQNS\NWTRAPH.PAS}
function f (x : Extended) : Extended; far;
var z : Extended;
begin
  z:=x*x;
  f:=z*(z-5)+4
end;
function df (x : Extended) : Extended; far;
begin
  df:=4*x*(x*x-2.5)
end;
function d2f (x : Extended) : Extended; far;
begin
  d2f:=12*x*x-10
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
end;
function d2f (x : Extended) : Extended; far;
begin
  d2f:=2*Cos(2*x)-0.5*Sin(x)
end;}
begin
  ClrScr;
  Writeln ('* NewtonRaphson test *');
  Writeln;
  Write ('x = ');
  Readln (x);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('NewtonRaphson (x, f, df, d2f, mit, eps, fatx, it, st) = ',
           NewtonRaphson (x, f, df, d2f, mit, eps, fatx, it, st));
  Writeln ('fatx = ', fatx, '   it = ', it, '   st = ', st);
  Readln
end.