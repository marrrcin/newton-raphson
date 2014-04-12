program Test_regulafalsi;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var st         : Integer;
    a, b, fatx : Extended;
{$I A:\NLINEQNS\REGFALSI.PAS}
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
  Writeln ('* regulafalsi test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Writeln ('regulafalsi (a, b, f, fatx, st) = ',
           regulafalsi (a, b, f, fatx, st));
  Writeln ('fatx = ', fatx, '   st = ', st);
  Readln
end.