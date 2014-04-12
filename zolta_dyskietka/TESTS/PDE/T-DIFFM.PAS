program Test_diffmethod;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector      = array [1..82] of Extended;
     vector1     = array [1..1764] of Extended;
     vector2     = array [1..82] of Integer;
     matrix      = array [0..10, 0..10] of Extended;
     coefficient = function (x, y : Extended) : Extended;
     boundary    = function (x : Extended) : Extended;
var i, j, kind, l, m, n, st : Integer;
    alpha, beta             : Extended;
    u                       : matrix;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2        : Word;
    sec                     : Single;
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
{$I A:\PDE\DIFFMETH.PAS}
function a (x, y : Extended) : Extended; far;
begin
  a:=1
end;
function b (x, y : Extended) : Extended; far;
begin
  b:=0
end;
function c (x, y : Extended) : Extended; far;
begin
  c:=1
end;
function d (x, y : Extended) : Extended; far;
begin
  d:=0
end;
function e (x, y : Extended) : Extended; far;
begin
  e:=0
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=0
end;
function g (x, y : Extended) : Extended; far;
begin
  g:=0
end;
function phi1 (y : Extended) : Extended; far;
begin
  phi1:=Cos(3*y)
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=Exp(3*x)
end;
function phi3 (y : Extended) : Extended; far;
begin
  phi3:=20.0855369231876677*Cos(3*y)
end;
function phi4 (x : Extended) : Extended; far;
begin
  phi4:=-0.989992496600445457*Exp(3*x)
end;

{function a (x, y : Extended) : Extended; far;
begin
  a:=-1
end;
function b (x, y : Extended) : Extended; far;
begin
  b:=0
end;
function c (x, y : Extended) : Extended; far;
begin
  c:=-1
end;
function d (x, y : Extended) : Extended; far;
begin
  d:=0
end;
function e (x, y : Extended) : Extended; far;
begin
  e:=0
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=1
end;
function g (x, y : Extended) : Extended; far;
begin
  g:=0
end;
function phi1 (y : Extended) : Extended; far;
begin
  phi1:=0
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=0
end;
function phi3 (y : Extended) : Extended; far;
begin
  phi3:=0
end;
function phi4 (x : Extended) : Extended; far;
begin
  phi4:=0
end;}

{function a (x, y : Extended) : Extended; far;
begin
  a:=1
end;
function b (x, y : Extended) : Extended; far;
begin
  b:=0
end;
function c (x, y : Extended) : Extended; far;
begin
  c:=0
end;
function d (x, y : Extended) : Extended; far;
begin
  d:=0
end;
function e (x, y : Extended) : Extended; far;
begin
  e:=-0.5
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=0
end;
function g (x, y : Extended) : Extended; far;
begin
  g:=0
end;
function phi1 (y : Extended) : Extended; far;
begin
  phi1:=Exp(-Pi*Pi*y/4)
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=Cos(Pi*x/2)
end;
function phi3 (y : Extended) : Extended; far;
begin
  phi3:=0
end;
function phi4 (x : Extended) : Extended; far;
begin
  phi4:=0.084804972471113777*Cos(Pi*x/2)
end;}

{function a (x, y : Extended) : Extended; far;
begin
  a:=1
end;
function b (x, y : Extended) : Extended; far;
begin
  b:=0
end;
function c (x, y : Extended) : Extended; far;
begin
  c:=-1
end;
function d (x, y : Extended) : Extended; far;
begin
  d:=0
end;
function e (x, y : Extended) : Extended; far;
begin
  e:=0
end;
function f (x, y : Extended) : Extended; far;
begin
  f:=0
end;
function g (x, y : Extended) : Extended; far;
begin
  g:=7.40220330081701896
end;
function phi1 (y : Extended) : Extended; far;
begin
  phi1:=Sin(Pi*y/2)
end;
function phi2 (x : Extended) : Extended; far;
begin
  phi2:=0
end;
function phi3 (y : Extended) : Extended; far;
begin
  phi3:=-Sin(Pi*y/2)
end;
function phi4 (x : Extended) : Extended; far;
begin
  phi4:=Cos(Pi*x)
end;}

begin
  ClrScr;
  Writeln ('* diffmethod test *');
  Writeln;
  Writeln ('n (<=10 due to the definitions of types "vector", "vector1",');
  Write ('   "vector2" and "matrix") = ');
  Readln (n);
  Writeln ('m (<=10 due to the definitions of types "vector", "vector1",');
  Write ('   "vector2" and "matrix") = ');
  Readln (m);
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  diffmethod (n, m, alpha, beta, a, b, c, d, e, f, g, phi1, phi2, phi3, phi4,
              u, kind, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  l:=0;
  for i:=0 to n do
    for j:=0 to m do
      begin
        l:=l+1;
        Writeln ('u[', i, ',', j, '] = ', u[i,j]);
        if (l=20) and (i*j<n*m)
          then begin
                 l:=0;
                 Readln
               end
      end;
  Writeln ('kind = ', kind, '   st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.