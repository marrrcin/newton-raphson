program Test_Newtonsimple;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     fx      = function (i, n : Integer;
                         x    : vector) : Extended;
var i, it, mit, n, st : Integer;
    eps, omega        : Extended;
    x                 : vector;
{$I A:\NLINEQNS\NWTSMPL.PAS}
function f (i, n : Integer;
            x    : vector) : Extended; far;
begin
  case i of
    1 : f:=2*Sqr(x[1])+x[2]+x[3];
    2 : f:=x[1]*x[2]-x[3]+2;
    3 : f:=(x[1]-x[2])*x[3]
  end
end;
function df (i, n : Integer;
             x    : vector) : Extended; far;
begin
  case i of
    1 : df:=4*x[1];
    2 : df:=x[1];
    3 : df:=x[1]-x[2]
  end
end;
begin
  ClrScr;
  Writeln ('* Newtonsimple test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Write ('omega = ');
  Readln (omega);
  Write ('eps = ');
  Readln (eps);
  Write ('mit = ');
  Readln (mit);
  Newtonsimple (n, x, f, df, omega, eps, mit, it, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.