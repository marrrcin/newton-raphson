program Test_AdamsBashforth;
{$N+,E-}
uses Crt;
type vector = array [0..7] of Extended;
     fxy    = function (x, y : Extended) : Extended;
var i, k, st   : Integer;
    h, rho, x0 : Extended;
    beta, y    : vector;
{$I A:\ODE\ABASHF.PAS}
function f (x, y : Extended) : Extended; far;
begin
  f:=x+x*y+y+1
end;
{function f (x, y : Extended) : Extended; far;
begin
  f:=Cos(x)-Sin(x)-y
end;}
begin
  ClrScr;
  Writeln ('* AdamsBashforth test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('k (<=7 due to the definition of type "vector") = ');
  Readln (k);
  Write ('h = ');
  Readln (h);
  for i:=0 to k-1 do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  for i:=0 to k-1 do
    begin
      Write ('beta[', i, '] = ');
      Readln (beta[i])
    end;
  Write ('rho = ');
  Readln (rho);
  Writeln;
  AdamsBashforth (x0, k, h, y, f, beta, rho, st);
  Writeln ('x0 = ', x0);
  for i:=0 to k-1 do
    Writeln ('y[', i, '] = ', y[i]);
  Writeln ('st = ', st);
  Readln
end.