program Test_linearRayleighRitz;
{$N+,E-}
uses Crt, Dos;
type vector  = array [1..50] of Extended;
     vector0 = array [0..51] of Extended;
     vector1 = array [1..49] of Extended;
     fx      = function (x : Extended) : Extended;
var i, n, st            : Integer;
    eps                 : Extended;
    x                   : vector0;
    c, phi              : vector;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2    : Word;
    sec                 : Single;
procedure comptime (h1,m1,s1,ms1,h2,m2,s2,ms2 : Word;
                    var min                   : Word;
                    var sec                   : Single);
var t1, t2 : Double;
begin
  if h2<h1
    then h2:=h2+24;
  t1:=h1*60+m1+(s1+ms1/100)/60;
  t2:=h2*60+m2+(s2+ms2/100)/60;
  t1:=t2-t1;
  min:=Trunc(t1);
  sec:=60*(t1-min)
end {comptime};
{$I A:\ODE\LINRR.PAS}
{function p (x : Extended) : Extended; far;
begin
  p:=1
end;
function q (x : Extended) : Extended; far;
begin
  q:=Sqr(Pi)
end;
function f (x : Extended) : Extended; far;
begin
  f:=2*Sqr(Pi)*Sin(Pi*x)
end;}
function p (x : Extended) : Extended; far;
begin
  p:=Exp(-x)
end;
function q (x : Extended) : Extended; far;
begin
  q:=Exp(-x)
end;
function f (x : Extended) : Extended; far;
begin
  f:=x-1-(x+1)*Exp(-x+1)
end;
begin
  ClrScr;
  Writeln ('* linearRayleighRitz test *');
  Writeln;
  Writeln ('n (<=50 due to the definitions of types "vector", "vector0"');
  Write ('   and "vector1") = ');
  Readln (n);
  for i:=0 to n+1 do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Write ('eps = ');
  Readln (eps);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  linearRayleighRitz (n, x, p, q, f, eps, c, phi, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  for i:=1 to n do
    Writeln ('c[', i, '] = ', c[i]);
  for i:=1 to n do
    Writeln ('phi[', i, '] = ', phi[i]);
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.