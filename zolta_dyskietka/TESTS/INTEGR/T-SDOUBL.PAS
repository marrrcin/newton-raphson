program Test_Simpsondouble;
{$N+,E-}
uses Crt;
type fx  = function (x : Extended) : Extended;
     fxy = function (x, y : Extended) : Extended;
var m, n, st : Integer;
    a, b     : Extended;
{$I A:\INTEGR\SDOUBLE.PAS}
function c (x : Extended) : Extended; far;
begin
  c:=1
end;
function d (x : Extended) : Extended; far;
begin
  d:=1.5
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=Ln(x+2*y)
end;
{function c (x : Extended) : Extended; far;
begin
  c:=Sqrt(x)
end;
function d (x : Extended) : Extended; far;
begin
  d:=x*x
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=Exp(-x-y)
end;}
begin
  ClrScr;
  Writeln ('* Simpsondouble test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('n = ');
  Readln (n);
  Write ('m = ');
  Readln (m);
  Writeln;
  Writeln ('Simpsondouble (a, b, c, d, f, n, m, st) = ',
           Simpsondouble(a, b, c, d, f, n, m, st));
  Writeln ('st = ', st);
  Readln
end.