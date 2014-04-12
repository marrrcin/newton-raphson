program Test_CrankNicolsonmixed;
{$N+,E-}
uses Crt, Dos;
type vector      = array [0..200] of Extended;
     vector1     = array [0..199] of Extended;
     vector2     = array [1..200] of Extended;
     coefficient = function (x, t : Extended) : Extended;
     boundary    = function (x : Extended) : Extended;
var i, j, l, maxj, n, st : Integer;
    a, alpha, b, beta, k : Extended;
    u                    : vector;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2     : Word;
    sec                  : Single;
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
{$I A:\PDE\CRANKNMX.PAS}
function c (x, t : Extended) : Extended; far;
begin
  c:=1
end;
function p (x, t : Extended) : Extended; far;
begin
  p:=1
end;
function q (x, t : Extended) : Extended; far;
begin
  q:=0
end;
function f (x, t : Extended) : Extended; far;
begin
  f:=0
end;
function phi (x : Extended) : Extended; far;
begin
  phi:=Cos(Pi*x/2)
end;
function psi1 (t : Extended) : Extended; far;
begin
  psi1:=1.57079632679489662*Exp(-Pi*Pi*t/4)
end;
function psi2 (t : Extended) : Extended; far;
begin
  psi2:=1.57079632679489662*Exp(-Pi*Pi*t/4)
end;
begin
  ClrScr;
  Writeln ('* CrankNicolsonmixed test *');
  Writeln;
  Writeln ('n (<=200 due to the definitions of types "vector", "vector1"');
  Write ('   and "vector2") = ');
  Readln (n);
  Write ('j = ');
  Readln (j);
  Writeln ('maxj (>j if the procedure should be called for a number of j or');
  Write ('      =j if the procedure should be called for the given j ) = ');
  Readln (maxj);
  Write ('k = ');
  Readln (k);
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  if j>1
    then for i:=0 to n do
           begin
             Write ('u[', i, '] = ');
             Readln (u[i])
           end;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  for i:=j to maxj do
    CrankNicolsonmixed (n, i, k, a, b, alpha, beta, c, p, q, f, phi,
                        psi1, psi2, u, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  Writeln ('u[0] = ', u[0]);
  l:=0;
  for i:=1 to n do
    begin
      l:=l+1;
      Writeln ('u[', i, '] = ', u[i]);
      if (l=20) and (i<n)
        then begin
               l:=0;
               Readln
             end
    end;
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.