program Test_Scraton;
{$N+,E-}
uses Crt, Dos;
type fxy = function (x, y : Extended) : Extended;
var st                    : Integer;
    eps, h, mh, x0, x1, y : Extended;
    fl                    : Boolean;
    h1, h2, m1, m2, min,
    ms1, ms2, s1, s2      : Word;
    sec                   : Single;
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
{$I A:\ODE\SCRATON.PAS}
function f (x, y : Extended) : Extended; far;
begin
  f:=x+x*y+y+1
end;
{function f (x, y : Extended) : Extended; far;
begin
  f:=Cos(x)-Sin(x)-y
end;}
begin
  ClrScr;
  Writeln ('* Scraton test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('x1 = ');
  Readln (x1);
  Write ('y = ');
  Readln (y);
  Write ('mh = ');
  Readln (mh);
  Write ('eps = ');
  Readln (eps);
  fl:=True;
  Writeln;
  GetTime (h1, m1, s1, ms1);
  Scraton (x0, x1, y, f, mh, eps, h, fl, st);
  GetTime (h2, m2, s2, ms2);
  comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
  Writeln ('x0 = ', x0, '   y = ', y);
  Writeln ('h = ', h, '   fl = ', fl);
  Writeln ('st = ', st);
  Write ('Time of computations: ', min, ' min ');
  if sec<10
    then Write (sec:3:1)
    else Write (sec:4:1);
  Writeln (' sec');
  Readln
end.