program Test_altdirection;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector    = array [1..841] of Extended;
     vector1   = array [1..840] of Extended;
     matrix    = array [0..30, 0..30] of Extended;
     boundary2 = function (x, y : Extended) : Extended;
var i, j, l, maxj, n, st : Integer;
    k                    : Extended;
    u                    : matrix;
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
{$I A:\PDE\ALTDIR.PAS}
function phi (x, y : Extended) : Extended; far;
begin
  phi:=Sin(Pi*(x+y))
end;
function psi1 (y, t : Extended) : Extended; far;
begin
  psi1:=Exp(-19.7392088021787172*t)*Sin(Pi*y)
end;
function psi2 (y, t : Extended) : Extended; far;
begin
  psi2:=-Exp(-19.7392088021787172*t)*Sin(Pi*y)
end;
function xi1 (x, t : Extended) : Extended; far;
begin
  xi1:=Exp(-19.7392088021787172*t)*Sin(Pi*x)
end;
function xi2 (x, t : Extended) : Extended; far;
begin
  xi2:=-Exp(-19.7392088021787172*t)*Sin(Pi*x)
end;
begin
  ClrScr;
  Writeln ('* altdirection test *');
  Writeln;
  Writeln ('n (<=30 due to the definitions of types "vector", "vector1"');
  Write ('   and "matrix") = ');
  Readln (n);
  Write ('j = ');
  Readln (j);
  Writeln ('maxj (>j if the procedure should be called for a number of j or');
  Write ('      =j if the procedure should be called for the given j ) = ');
  Readln (maxj);
  Write ('k = ');
  Readln (k);
  if j>1
    then for l:=0 to n do
           for i:=0 to n do
             begin
               Write ('u[', l, ',', i, '] = ');
               Readln (u[l,i])
             end;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  for i:=j to maxj do
    altdirection (n, i, k, phi, psi1, psi2, xi1, xi2, u, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  l:=0;
  for i:=0 to n do
    for j:=0 to n do
      begin
        l:=l+1;
        Writeln ('u[', i, ',', j, '] = ', u[i,j]);
        if (l=20) and (i*j<n*n)
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