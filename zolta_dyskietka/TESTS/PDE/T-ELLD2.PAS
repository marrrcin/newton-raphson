program Test_ellipticdiff2;
{$N+,E-}
uses Crt, Dos;
type vector      = array [1..81] of Extended;
     matrix      = array [0..10, 0..10] of Extended;
     coefficient = function (x, y : Extended) : Extended;
     boundary    = function (x : Extended) : Extended;
var i, it, j, l, m, mit, n, st : Integer;
    alpha, beta, eps           : Extended;
    u                          : matrix;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2           : Word;
    sec                        : Single;
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
{$I A:\PDE\ELLDIFF2.PAS}
function f (x, y : Extended) : Extended; far;
begin
  f:=0
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

{function f (x, y : Extended) : Extended; far;
begin
  f:=19.7392088021787172*Sin(Pi*x)*Sin(Pi*y)
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

begin
  ClrScr;
  Writeln ('* ellipticdiff2 test *');
  Writeln;
  Write ('n (<=10 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  Write ('m (<=10 due to the definitions of types "vector" and "matrix") = ');
  Readln (m);
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  ellipticdiff2 (n, m, alpha, beta, f, phi1, phi2, phi3, phi4, mit, eps,
                 u, it, st);
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
  Writeln ('it = ', it, '   st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.