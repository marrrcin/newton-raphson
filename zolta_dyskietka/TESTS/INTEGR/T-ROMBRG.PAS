program Test_Romberg;
{$N+,E-}
uses Crt;
type vector = array [1..15] of Extended;
     fx     = function (x : Extended) : Extended;
var r, st     : Integer;
    a, b, eps : Extended;
{$I A:\INTEGR\ROMBERG.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x/2)*Sin(x)/(17-8*Cos(x))
end;}
{function f (x : Extended) : Extended; far;
begin
  f:=1/(1+x*x)
end;}
begin
  ClrScr;
  Writeln ('* Romberg test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('eps = ');
  Readln (eps);
  Write ('r (<=15 due to the definition of type "vector") = ');
  Readln (r);
  Writeln;
  Writeln ('Romberg (a, b, f, eps, r, st) = ', Romberg(a, b, f, eps, r, st));
  Writeln ('st = ', st);
  Readln
end.