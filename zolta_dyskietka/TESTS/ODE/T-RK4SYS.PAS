program Test_RungeKutta4system;
{$N+,E-}
uses Crt, Dos;
type vector = array [1..6] of Extended;
     fxysys = procedure (x     : Extended;
                         n     : Integer;
                         y     : vector;
                         var f : vector);
var i, n, st                : Integer;
    eps, eta, h, mh, x0, x1 : Extended;
    fl                      : Boolean;
    y                       : vector;
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
{$I A:\ODE\RK4SYS.PAS}
procedure fun (x     : Extended;
               n     : Integer;
               y     : vector;
               var f : vector); far;
begin
  f[1]:=x+x*y[1]+y[1]+1
end;
{procedure fun (x     : Extended;
               n     : Integer;
               y     : vector;
               var f : vector); far;
begin
  f[1]:=1/y[2];
  f[2]:=-1/y[1]
end;}
{procedure fun (x     : Extended;
               n     : Integer;
               y     : vector;
               var f : vector); far;
const mu      : Extended = 1/82.45;
      muprime : Extended = 1-1/82.45;
var r, rho, y1 : Extended;
begin
  f[1]:=y[3];
  f[2]:=y[4];
  y1:=y[1];
  r:=Sqr(y[2]);
  rho:=Sqr(y1-muprime)+r;
  r:=Sqr(y1+mu)+r;
  r:=r*Sqrt(r);
  rho:=rho*Sqrt(rho);
  f[3]:=y1+2*y[4]-muprime*(y1+mu)/r-mu*(y1-muprime)/rho;
  f[4]:=y[2]-2*y[3]-y[2]*(muprime/r+mu/rho)
end;}
begin
  ClrScr;
  Writeln ('* RungeKutta4system test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('x1 = ');
  Readln (x1);
  Write ('n (<=6 due to the definition of type "vector") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  Write ('mh = ');
  Readln (mh);
  Write ('eps = ');
  Readln (eps);
  Write ('eta = ');
  Readln (eta);
  fl:=True;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  RungeKutta4system (x0, x1, n, y, fun, mh, eps, eta, h, fl, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  Writeln ('x0 = ', x0);
  for i:=1 to n do
    Writeln ('y[', i, '] = ', y[i]);
  Writeln ('h = ', h, '   fl = ', fl);
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.