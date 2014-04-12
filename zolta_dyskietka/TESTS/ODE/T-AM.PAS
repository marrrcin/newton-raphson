program Test_AdamsMoulton;
{$N+,E-}
uses Crt, Dos;
type vector  = array [0..6] of Extended;
     vector1 = array [0..7] of Extended;
     fxy     = function (x, y : Extended) : Extended;
var i, it, k, mit, st   : Integer;
    inyvalue            : Byte;
    h, eps, rho, x0, yk : Extended;
    iny                 : Boolean;
    y                   : vector;
    beta                : vector1;
{$I A:\ODE\AMOULTON.PAS}
function f (x, y : Extended) : Extended; far;
begin
  f:=x+x*y+y+1
end;
function df (x, y : Extended) : Extended; far;
begin
  df:=x+1
end;
{function f (x, y : Extended) : Extended; far;
begin
  f:=Cos(x)-Sin(x)-y
end;
function df (x, y : Extended) : Extended; far;
begin
  df:=-1
end;}
begin
  ClrScr;
  Writeln ('* AdamsMoulton test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('k (<=7 due to the definition of types "vector" and "vector1") = ');
  Readln (k);
  Write ('h = ');
  Readln (h);
  for i:=0 to k-1 do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  for i:=0 to k do
    begin
      Write ('beta[', i, '] = ');
      Readln (beta[i])
    end;
  Write ('rho = ');
  Readln (rho);
  Write ('eps = ');
  Readln (eps);
  Write ('mit = ');
  Readln (mit);
  Writeln ('iny (1 - initial approximation at x0+k*h equal to y[k-1],');
  Write ('     0 - enter initial approximation at x0+k*h) = ');
  Readln (inyvalue);
  case inyvalue of
    1 : iny:=True;
    0 : iny:=False
  end;
  if not iny
    then begin
           Write ('yk = ');
           Readln (yk)
         end;
  Writeln;
  AdamsMoulton (x0, k, h, y, f, df, beta, rho, eps, mit, iny, yk, it, st);
  Writeln ('x0 = ', x0);
  for i:=0 to k-1 do
    Writeln ('y[', i, '] = ', y[i]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.