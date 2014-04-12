program Test_GaussLegendre;
{$N+,E-}
uses Crt;
type vector = array [0..7] of Extended;
     fx     = function (x : Extended) : Extended;
var i, n, st : Integer;
    x        : vector;
{$I A:\INTEGR\GLEGENDR.PAS}
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
  Writeln ('* GaussLegendre test *');
  Writeln;
  Write ('n (<=14 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to (n div 2) do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Writeln;
  Writeln ('GaussLegendre (f, n, x, st) = ', GaussLegendre(f, n, x, st));
  Writeln ('st = ', st);
  Readln
end.