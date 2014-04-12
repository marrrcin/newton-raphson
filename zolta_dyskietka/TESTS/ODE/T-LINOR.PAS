program Test_linorthogon;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector     = array [1..6] of Extended;
     vector1    = array [1..42] of Extended;
     matrix     = array [1..6, 1..6] of Extended;
     matrix1    = array [1..6, 1..20] of Extended;
     matrix2    = array [1..42, 0..6] of Extended;
     matrix3    = array [0..7, 1..42] of Extended;
     atmatrix   = procedure (x     : Extended;
                             m     : Integer;
                             var a : matrix);
     ftfunction = procedure (x     : Extended;
                             m     : Integer;
                             var f : vector);
var i, j, m, n, st      : Integer;
    gamma, t            : vector;
    b                   : matrix;
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
{$I A:\ODE\LINORTH.PAS}
procedure at (x     : Extended;
              m     : Integer;
              var a : matrix); far;
begin
  a[1,1]:=0;
  a[1,2]:=1;
  a[2,1]:=1;
  a[2,2]:=0
end;
procedure ft (x     : Extended;
              m     : Integer;
              var f : vector); far;
begin
  f[1]:=0;
  f[2]:=2*Sin(x)
end;
begin
  ClrScr;
  Writeln ('* linorthogon test *');
  Writeln;
  Writeln ('m (<=6 due to the definitions of types "vector", "vector1",');
  Write ('   "matrix", "matrix1", "matrix2" and "matrix3") = ');
  Readln (m);
  for i:=1 to m do
    for j:=1 to m do
      begin
        Write ('b[', i, ',', j, '] = ');
        Readln (b[i,j])
      end;
  for i:=1 to m do
    begin
      Write ('gamma[', i, '] = ');
      Readln (gamma[i])
    end;
  for i:=1 to m do
    begin
      Write ('t[', i, '] = ');
      Readln (t[i])
    end;
  Write ('n (<=20 due to the definition of type "matrix1") = ');
  Readln (n);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  linorthogon (m, at, ft, b, gamma, t, n, u, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  for j:=1 to n do
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