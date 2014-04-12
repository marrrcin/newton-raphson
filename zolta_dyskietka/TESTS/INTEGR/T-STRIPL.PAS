program Test_Simpsontriple;
{$N+,E-}
uses Crt, Dos;
type fx   = function (x : Extended) : Extended;
     fxy  = function (x, y : Extended) : Extended;
     fxyz = function (x, y, z : Extended) : Extended;
var m, n, p, st           : Integer;
    alpha, beta, integral : Extended;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2      : Word;
    sec                   : Single;
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
{$I A:\INTEGR\STRIPLE.PAS}
function gamma (x : Extended) : Extended; far;
begin
  gamma:=1
end;
function delta (x : Extended) : Extended; far;
begin
  delta:=2
end;
function eta (x, y : Extended) : Extended; far;
begin
  eta:=0
end;
function kappa (x, y : Extended) : Extended; far;
begin
  kappa:=0.5
end;
function f (x, y, z : Extended) : Extended; far;
begin
  f:=Exp(x*y*z)
end;
{function gamma (x : Extended) : Extended; far;
begin
  gamma:=0
end;
function delta (x : Extended) : Extended; far;
begin
  delta:=1-x
end;
function eta (x, y : Extended) : Extended; far;
begin
  eta:=0
end;
function kappa (x, y : Extended) : Extended; far;
begin
  kappa:=1-x-y
end;
function f (x, y, z : Extended) : Extended; far;
begin
  f:=y*y+z*z
end;}
begin
  ClrScr;
  Writeln ('* Simpsontriple test *');
  Writeln;
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  Write ('n = ');
  Readln (n);
  Write ('m = ');
  Readln (m);
  Write ('p = ');
  Readln (p);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  integral:=Simpsontriple(alpha, beta, gamma, delta, eta, kappa, f, n,
                          m, p, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  Writeln ('Simpsontriple (alpha, beta, gamma, delta,');
  Writeln ('               eta, kappa, f, n, m, p, st) = ', integral);
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.