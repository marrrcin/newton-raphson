program Test_shooting;
{$N+,E-}
uses Crt, Dos;
type vector      = array [1..6] of Extended;
     vector1     = array [1..5] of Extended;
     vector2     = array [1..5] of Integer;
     vector3     = array [1..16] of Extended;
     matrix      = array [1..6, 1..6] of Extended;
     matrix1     = array [1..6, 0..20] of Extended;
     ftufunction = procedure (t     : Extended;
                              m     : Integer;
                              ut    : vector;
                              var f : vector);
     gboundary   = procedure (m      : Integer;
                              ua, ub : vector;
                              var g  : vector);
var i, j, m, mit, n, st : Integer;
    a, b, eps, eta, mh  : Extended;
    ds, s               : vector;
    u                   : matrix1;
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
{$I A:\ODE\SHOOTING.PAS}
procedure fun (t     : Extended;
               m     : Integer;
               ut    : vector;
               var f : vector); far;
begin
  f[1]:=ut[2];
  f[2]:=1.5*Sqr(ut[1])
end;
procedure gfun (m      : Integer;
                ua, ub : vector;
                var g  : vector); far;
begin
  g[1]:=Sqrt(ua[1])*ua[2]/8+2;
  g[2]:=ub[2]+1
end;
{procedure fun (t     : Extended;
               m     : Integer;
               ut    : vector;
               var f : vector); far;
begin
  f[1]:=-t*t*Cos(ut[1]+ut[2]);
  f[2]:=-Sin(ut[1])
end;
procedure gfun (m      : Integer;
                ua, ub : vector;
                var g  : vector); far;
begin
  g[1]:=ua[1];
  g[2]:=ub[2]-1
end;}
begin
  ClrScr;
  Writeln ('* shooting test *');
  Writeln;
  Writeln ('m (<=6 due to the definitions of types "vector", "vector1",');
  Write ('   "vector2", "vector3", "matrix" and "matrix1") = ');
  Readln (m);
  for i:=1 to m do
    begin
      Write ('s[', i, '] = ');
      Readln (s[i])
    end;
  for i:=1 to m do
    begin
      Write ('ds[', i, '] = ');
      Readln (ds[i])
    end;
  Write ('n (<=20 due to the definition of type "matrix1") = ');
  Readln (n);
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('mh = ');
  Readln (mh);
  Write ('eps = ');
  Readln (eps);
  Write ('eta = ');
  Readln (eta);
  Write ('mit = ');
  Readln (mit);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  shooting (m, fun, gfun, s, ds, n, a, b, mh, eps, eta, mit, u, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  for j:=0 to n do
    for i:=1 to m do
      Writeln ('u[', i, ',', j, '] = ', u[i,j]);
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.