program Test_loc1dim;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector    = array [0..961] of Extended;
     matrix    = array [0..30, 0..30] of Extended;
     boundary2 = function (x, y : Extended) : Extended;
var i, it, j, l, maxj, mit, n, st : Integer;
    eps, k                        : Extended;
    u, u1                         : matrix;
    h1, h2, m1, m2, min, ms1, ms2,
    s1, s2                        : Word;
    sec                           : Single;
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
{$I A:\PDE\LOC1DIM.PAS}
function phi1 (x, y : Extended) : Extended; far;
begin
  phi1:=Sin(Pi*x)*Sin(pi*y)
end;
function phi2 (x, y : Extended) : Extended; far;
begin
  phi2:=0
end;
function psi1 (y, t : Extended) : Extended; far;
begin
  psi1:=0
end;
function psi2 (y, t : Extended) : Extended; far;
begin
  psi2:=0
end;
function xi1 (x, t : Extended) : Extended; far;
begin
  xi1:=0
end;
function xi2 (x, t : Extended) : Extended; far;
begin
  xi2:=0
end;
begin
  ClrScr;
  Writeln ('* loc1dim test *');
  Writeln;
  Write ('n (<=30 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  Write ('j = ');
  Readln (j);
  Writeln ('maxj (>j if the procedure should be called for a number of j or');
  Write ('      =j if the procedure should be called for the given j ) = ');
  Readln (maxj);
  Write ('k = ');
  Readln (k);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  if j>1
    then for l:=0 to n do
           for i:=0 to n do
             begin
               Write ('u[', l, ',', i, '] = ');
               Readln (u[l,i])
             end;
  if j>2
    then for l:=0 to n do
           for i:=1 to n do
             begin
               Write ('u1[', l, ',', i, '] = ');
               Readln (u1[l,i])
             end;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  for i:=j to maxj do
    loc1dim (n, i, k, phi1, phi2, psi1, psi2, xi1, xi2, mit, eps,
             u, u1, it, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  l:=0;
  for i:=0 to n do
    for j:=0 to n do
      begin
        l:=l+1;
        Writeln ('u[', i, ',', j, '] = ', u[i,j]);
        if l=20
          then begin
                 l:=0;
                 Readln
               end
      end;
  for i:=0 to n do
    for j:=0 to n do
      begin
        l:=l+1;
        Writeln ('u1[', i, ',', j, '] = ', u1[i,j]);
        if (l=20) and (i*j<n*n)
          then begin
                 l:=0;
                 Readln
               end
      end;
  Writeln ('it = ', it, '   st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.