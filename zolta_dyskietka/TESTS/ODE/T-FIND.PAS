program Test_finitediff;
{$N+,E-}
{$M 65520,0,655360}
uses Crt, Dos;
type vector     = array [1..6] of Extended;
     vector0    = array [0..10] of Extended;
     vector1    = array [1..10] of Extended;
     vector2    = array [1..67] of Extended;
     vector3    = array [1..67] of Integer;
     vector4    = array [1..1156] of Extended;
     matrix     = array [1..6, 0..10] of Extended;
     ithftu     = function (i : Integer;
                            x : Extended;
                            m : Integer;
                            y : vector) : Extended;
     ithgbound  = function (i, m : Integer;
                            y, z : vector) : Extended;
     ithdftu    = procedure (i      : Integer;
                             x      : Extended;
                             m      : Integer;
                             y      : vector;
                             var dy : vector);
     ithdgbound = procedure (i, m       : Integer;
                             y, z       : vector;
                             var dy, dz : vector);
var i, j, m, mit, n, st : Integer;
    eps                 : Extended;
    t                   : vector0;
    alpha               : vector1;
    u                   : matrix;
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
{$I A:\ODE\FINDIFF.PAS}
function f (i : Integer;
            x : Extended;
            m : Integer;
            y : vector) : Extended; far;
begin
  case i of
    1 : f:=y[2];
    2 : f:=1.5*Sqr(y[1])
  end
end;
function g (i, m : Integer;
            y, z : vector) : Extended; far;
begin
  case i of
    1 : g:=y[1]-4;
    2 : g:=z[2]+1
  end
end;
procedure df (i      : Integer;
              x      : Extended;
              m      : Integer;
              y      : vector;
              var dy : vector); far;
begin
  case i of
    1 : begin
          dy[1]:=0;
          dy[2]:=1
        end;
    2 : begin
          dy[1]:=3*y[1];
          dy[2]:=0
        end
  end
end;
procedure dg (i, m       : Integer;
              y, z       : vector;
              var dy, dz : vector); far;
begin
  case i of
    1 : begin
          dy[1]:=1;
          dy[2]:=0;
          dz[1]:=0;
          dz[2]:=0
        end;
    2 : begin
          dy[1]:=0;
          dy[2]:=0;
          dz[1]:=0;
          dz[2]:=1
        end
  end
end;
{function f (i : Integer;
            x : Extended;
            m : Integer;
            y : vector) : Extended; far;
begin
  case i of
    1 : f:=-x*x*Cos(y[1]+y[2]);
    2 : f:=-Sin(y[1])
  end
end;
function g (i, m : Integer;
            y, z : vector) : Extended; far;
begin
  case i of
    1 : g:=y[1];
    2 : g:=z[2]-1
  end
end;
procedure df (i      : Integer;
              x      : Extended;
              m      : Integer;
              y      : vector;
              var dy : vector); far;
begin
  case i of
    1 : begin
          dy[1]:=x*x*Sin(y[1]+y[2]);
          dy[2]:=dy[1]
        end;
    2 : begin
          dy[1]:=-Cos(y[1]);
          dy[2]:=0
        end
  end
end;
procedure dg(i, m       : Integer;
             y, z       : vector;
             var dy, dz : vector); far;
begin
  case i of
    1 : begin
          dy[1]:=1;
          dy[2]:=0;
          dz[1]:=0;
          dz[2]:=0
        end;
    2 : begin
          dy[1]:=0;
          dy[2]:=0;
          dz[1]:=0;
          dz[2]:=1
        end
  end
end;}
begin
  ClrScr;
  Writeln ('* finitediff test *');
  Writeln;
  Writeln ('m (<=6 due to the definitions of types "vector", "vector2",');
  Write ('   "vector3", "vector4" and "matrix") = ');
  Readln (m);
  Writeln ('n (<=10 due to the definitions of types "vector0", "vector1",');
  Write ('   "vector2", "vector3", "vector4" and "matrix") = ');
  Readln (n);
  for j:=0 to n do
    begin
      Write ('t[', j, '] = ');
      Readln (t[j])
    end;
  for j:=0 to n do
    for i:=1 to m do
      begin
        Write ('u[', i, ',', j, '] = ');
        Readln (u[i,j])
      end;
  for i:=1 to n do
    begin
      Write ('alpha[', i, '] = ');
      Readln (alpha[i])
    end;
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln;
  GetTime (h1, m1, s1, ms1);
  finitediff (m, n, f, g, df, dg, t, u, alpha, mit, eps, st);
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