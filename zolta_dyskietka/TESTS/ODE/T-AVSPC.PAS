program Test_Adamsvarsteppredcorr;
{$N+,E-}
uses Crt;
type vector = array [0..500] of Extended;
     fxy    = function (x, y : Extended) : Extended;
var i, n, st                    : Integer;
    eps, hmin, hmax, x0, xn, y0 : Extended;
    x, y                        : vector;
{$I A:\ODE\VSTEPPC.PAS}
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
  Writeln ('* Adamsvarsteppredcorr test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('xn = ');
  Readln (xn);
  Write ('y0 = ');
  Readln (y0);
  Write ('n (<=500 due to the definition of type "vector") = ');
  Readln (n);
  Write ('eps = ');
  Readln (eps);
  Write ('hmin = ');
  Readln (hmin);
  Write ('hmax = ');
  Readln (hmax);
  Writeln;
  Adamsvarsteppredcorr (x0, xn, y0, n, f, eps, hmin, hmax, x, y, st);
  if (st=0) or (st=6)
    then begin
           Writeln ('n = ', n);
           for i:=0 to n do
             Writeln ('x[', i, '] = ', x[i], '   y[', i, '] = ', y[i]);
         end;
  Writeln ('st = ', st);
  Readln
end.