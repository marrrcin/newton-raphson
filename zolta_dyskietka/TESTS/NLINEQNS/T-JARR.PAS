program Test_Jarratt;
{$N+,E-}
uses Crt;
type fx = function (x : Extended) : Extended;
var st         : Integer;
    a, b, fatx : Extended;
{$I A:\NLINEQNS\JARRATT.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x-2
end;
function df (x : Extended) : Extended; far;
begin
  df:=2*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x)-x*Cos(x)
end;
function df (x : Extended) : Extended; far;
begin
  df:=x*Sin(x)
end;}
begin
  ClrScr;
  Writeln ('* Jarratt test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Writeln ('Jarratt (a, b, f, df, fatx, st) = ',
           Jarratt (a, b, f, df, fatx, st));
  Writeln ('fatx = ', fatx, '   st = ', st);
  Readln
end.