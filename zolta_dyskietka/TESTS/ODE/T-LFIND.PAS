program Test_linfinitediff;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector      = array [1..6] of Extended;
     vector0     = array [0..10] of Extended;
     vector1     = array [1..10] of Extended;
     vector2     = array [1..66] of Extended;
     vector3     = array [1..66] of Integer;
     vector4     = array [1..1156] of Extended;
     matrix      = array [1..6, 1..6] of Extended;
     matrix0     = array [1..6, 0..10] of Extended;
     atithrow    = procedure (i     : Integer;
                              t     : Extended;
                              m     : Integer;
                              var a : vector);
     ftcomponent = function (i : Integer;
                             t : Extended) : Extended;
var i, j, m, n, st      : Integer;
    g                   : vector;
    t                   : vector0;
    alpha               : vector1;
    b, c                : matrix;
    u                   : matrix0;
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
{$I A:\ODE\LFINDIFF.PAS}
procedure at (i     : Integer;
              t     : Extended;
              m     : Integer;
              var a : vector); far;
begin
  case i of
    1 : begin
          a[1]:=0;
          a[2]:=1
        end;
    2 : begin
          a[1]:=1;
          a[2]:=0
        end
  end
end;
function ft (i : Integer;
             t : Extended) : Extended; far;
begin
  case i of
    1 : ft:=0;
    2 : ft:=2*Sin(t)
  end
end;
{procedure at (i     : Integer;
              t     : Extended;
              m     : Integer;
              var a : vector); far;
begin
  case i of
    1 : begin
          a[1]:=0;
          a[2]:=0;
          a[3]:=3;
          a[4]:=1
        end;
    2 : begin
          a[1]:=0;
          a[2]:=0;
          a[3]:=1;
          a[4]:=3
        end;
    3 : begin
          a[1]:=-1;
          a[2]:=-3;
          a[3]:=0;
          a[4]:=0
        end;
    4 : begin
          a[1]:=-3;
          a[2]:=-1;
          a[3]:=0;
          a[4]:=0
        end
  end
end;
function ft (i : Integer;
             t : Extended) : Extended; far;
begin
  ft:=0;
end;}
begin
  ClrScr;
  Writeln ('* linfinitediff test *');
  Writeln;
  Writeln ('m (<=6 due to the definitions of types "vector", "vector2",');
  Write ('   "vector3", "vector4", "matrix" and "matrix0") = ');
  Readln (m);
  for i:=1 to m do
    for j:=1 to m do
      begin
        Write ('b[', i, ',', j, '] = ');
        Readln (b[i,j])
      end;
  for i:=1 to m do
    for j:=1 to m do
      begin
        Write ('c[', i, ',', j, '] = ');
        Readln (c[i,j])
      end;
  for i:=1 to m do
    begin
      Write ('g[', i, '] = ');
      Readln (g[i])
    end;
  Writeln ('n (<=10 due to the definitions of types "vector0", "vector1",');
  Write ('   "vector2", "vector3", "vector4" and "matrix0") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('t[', i, '] = ');
      Readln (t[i])
    end;
  for i:=1 to n do
    begin
      Write ('alpha[', i, '] = ');
      Readln (alpha[i])
    end;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  linfinitediff (m, at, ft, b, c, g, n, t, alpha, u, st);
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