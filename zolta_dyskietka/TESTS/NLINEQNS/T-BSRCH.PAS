program Test_binarysearch;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var it, mit, st     : Integer;
    a, b, tol, fatx : Extended;
{$I A:\NLINEQNS\BISEARCH.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x-2
end;
{function f (x : Extended) : Extended; far;
begin
  f:=x*Exp(Sqrt(x+1))-1
end;}
{function f (x : Extended) : Extended; far;
var s : Extended;
begin
  s:=Sin(x);
  f:=s*(s+0.5)-0.5
end;}
begin
  ClrScr;
  Writeln ('* binarysearch test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('mit = ');
  Readln (mit);
  Write ('tol = ');
  Readln (tol);
  Writeln ('binarysearch (a, b, f, mit, tol, fatx, it, st) = ',
           binarysearch (a, b, f, mit, tol, fatx, it, st));
  Writeln ('fatx = ', fatx, '   it = ', it, '   st = ', st);
  Readln
end.