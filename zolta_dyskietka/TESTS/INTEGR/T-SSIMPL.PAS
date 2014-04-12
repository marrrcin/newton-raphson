program Test_Simpsonsimple;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var n, st     : Integer;
    a, b, eps : Extended;
{$I A:\INTEGR\SIMPSMPL.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=1/(1+x*x)
end;}
begin
  ClrScr;
  Writeln ('* Simpsonsimple test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('eps = ');
  Readln (eps);
  Write ('n = ');
  Readln (n);
  Writeln;
  Writeln ('Simpsonsimple (a, b, f, eps, n, st) = ',
           Simpsonsimple(a, b, f, eps, n, st));
  Writeln ('st = ', st);
  Readln
end.