program Test_GaussJacobi;
{$N+,E-}
uses Crt;
type vector = array [0..14] of Extended;
     fx     = function (x : Extended) : Extended;
var i, n, st    : Integer;
    alpha, beta : Extended;
    x           : vector;
{$I A:\INTEGR\GJACOBI.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Cos(x)
end;}
begin
  ClrScr;
  Writeln ('* GaussJacobi test *');
  Writeln;
  Write ('n (<=14 due to the definition of type "vector") = ');
  Readln (n);
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Writeln;
  Writeln ('GaussJacobi (f, n, alpha, beta, x, st) = ',
           GaussJacobi(f, n, alpha, beta, x, st));
  Writeln ('st = ', st);
  Readln
end.