program Test_GaussHermite;
{$N+,E-}
uses Crt;
type vector = array [0..4] of Extended;
     fx     = function (x : Extended) : Extended;
var i, n, st : Integer;
    x        : vector;
{$I A:\INTEGR\GHERMITE.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=1
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Cos(x)
end;}
begin
  ClrScr;
  Writeln ('* GaussHermite test *');
  Writeln;
  Write ('n (<=8 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to (n div 2) do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Writeln;
  Writeln ('GaussHermite (f, n, x, st) = ', GaussHermite(f, n, x, st));
  Writeln ('st = ', st);
  Readln
end.