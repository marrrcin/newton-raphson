program Test_Rombergdiff;
{$N+,E-}
uses Crt;
type vector = array [0..6] of Extended;
     fx     = function (x : Extended) : Extended;
var m, st      : Integer;
    eps, h0, x : Extended;
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x)+Cos(x)
end;}
{function f (x : Extended) : Extended; far;
begin
  f:=3*x*x+1/x
end;}
{$I A:\DIFF\ROMBDIFF.PAS}
begin
  ClrScr;
  Writeln ('* Rombergdiff test *');
  Writeln;
  Write ('x = ');
  Readln (x);
  Write ('h0 = ');
  Readln (h0);
  Write ('m = ');
  Readln (m);
  Write ('eps = ');
  Readln (eps);
  Writeln ('Rombergdiff (x, f, h0, m, eps, st) = ',
           Rombergdiff(x, f, h0, m, eps, st));
  Writeln ('st = ', st);
  Readln
end.