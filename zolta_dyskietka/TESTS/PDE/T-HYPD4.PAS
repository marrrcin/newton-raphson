program Test_hyperdiff4;
{$N+,E-}
uses Crt, Dos;
type vector      = array [0..200] of Extended;
     vector1     = array [1..199] of Extended;
     coefficient = function (x, t : Extended) : Extended;
     boundary    = function (x : Extended) : Extended;
var i, j, l, maxj, n, st : Integer;
    k                    : Extended;
    u, u1                : vector;
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
{$I A:\PDE\HYPDIFF4.PAS}
function a (x, t : Extended) : Extended; far;
begin
  a:=1
end;
function phi1 (x : Extended) : Extended; far;
begin
  phi1:=Sin(Pi*x)
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=0
end;
function psi1 (t : Extended) : Extended; far;
begin
  psi1:=0
end;
function psi2 (t : Extended) : Extended; far;
begin
  psi2:=0
end;
{function a (x, t : Extended) : Extended; far;
begin
  a:=8*Sqr(Sin((x+1)/4))/Cos((x+1)/2)
end;
function phi1 (x : Extended) : Extended; far;
begin
  phi1:=Sqr(Sin((x+1)/4))
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=-Sqr(Sin((x+1)/4))
end;
function psi1 (t : Extended) : Extended; far;
begin
  psi1:=0.061208719054813642*Exp(-t)
end;
function psi2 (t : Extended) : Extended; far;
begin
  psi2:=0.229848847065930141*Exp(-t)
end;}
begin
  ClrScr;
  Writeln ('* hyperdiff4 test *');
  Writeln;
  Write ('n (<=200 due to the definitions of types "vector" and '
         +'"vector1") = ');
  Readln (n);
  Write ('j = ');
  Readln (j);
  Writeln ('maxj (>j if the procedure should be called for a number of j or');
  Write ('      =j if the procedure should be called for the given j ) = ');
  Readln (maxj);
  Write ('k = ');
  Readln (k);
  if j>1
    then for i:=0 to n do
           begin
             Write ('u[', i, '] = ');
             Readln (u[i])
           end;
  if j>2
    then for i:=0 to n do
           begin
             Write ('u1[', i, '] = ');
             Readln (u1[i])
           end;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  for i:=j to maxj do
    hyperdiff4 (n, i, k, a, phi1, phi2, psi1, psi2, u, u1, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  l:=0;
  for i:=0 to n do
    begin
      l:=l+1;
      Writeln ('u[', i, '] = ', u[i]);
      if l=20
        then begin
               l:=0;
               Readln
             end
    end;
  for i:=0 to n do
    begin
      l:=l+1;
      Writeln ('u1[', i, '] = ', u1[i]);
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