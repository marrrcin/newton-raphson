program Test_GaussLaguerre;
{$N+,E-}
uses Crt;
type vector = array [0..8] of Extended;
     fx     = function (x : Extended) : Extended;
var i, n, st : Integer;
    x        : vector;
{$I A:\INTEGR\GLAGUER.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=1
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x)/(Exp(x)*x)
end;}
begin
  ClrScr;
  Writeln ('* GaussLaguerre test *');
  Writeln;
  Write ('n (<=8 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Writeln;
  Writeln ('GaussLaguerre (f, n, x, st) = ', GaussLaguerre(f, n, x, st));
  Writeln ('st = ', st);
  Readln
end.