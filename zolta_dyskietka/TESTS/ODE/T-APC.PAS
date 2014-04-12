program Test_Adamspredcorr;
{$N+,E-}
uses Crt;
type vector = array [0..100] of Extended;
     fxy    = function (x, y : Extended) : Extended;
var i, n, st   : Integer;
    x0, xn, y0 : Extended;
    y          : vector;
{$I A:\ODE\PREDCORR.PAS}
{function f (x, y : Extended) : Extended; far;
begin
  f:=x+x*y+y+1
end;}
function f (x, y : Extended) : Extended; far;
begin
  f:=Cos(x)-Sin(x)-y
end;
begin
  ClrScr;
  Writeln ('* Adamspredcorr test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('xn = ');
  Readln (xn);
  Write ('y0 = ');
  Readln (y0);
  Write ('n (<=100 due to the definition of type "vector") = ');
  Readln (n);
  Writeln;
  Adamspredcorr (x0, xn, y0, n, f, y, st);
  for i:=0 to n do
    Writeln ('y[', i, '] = ', y[i]);
  Writeln ('st = ', st);
  Readln
end.