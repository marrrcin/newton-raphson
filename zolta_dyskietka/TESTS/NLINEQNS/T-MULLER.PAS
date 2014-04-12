program Test_Muller;
{$N+,E-}
uses Crt;
type complex = record
                 re, im : Extended
               end;
     fxcplx = procedure (x      : complex;
                         var fx : complex);
var it, mit, st         : Integer;
    tol                 : Extended;
    x, x0, x1, x2, fatx : complex;
{$I A:\NLINEQNS\MULLER.PAS}
procedure f (x      : complex;
             var fx : complex); far;
var ar,ai : Extended;
begin
  ar:=Sqr(x.re);
  ai:=Sqr(x.im);
  with fx do
    begin
      re:=16*(ar*ar-6*ar*ai+ai*ai);
      re:=re-40*x.re*(ar-3*ai);
      re:=re+5*(ar-ai)+20*x.re+6;
      im:=64*x.re*(ar-ai);
      im:=im-40*(3*ar-ai);
      im:=(im+10*x.re+20)*x.im
    end
end;
begin
  ClrScr;
  Writeln ('* Muller test *');
  Writeln;
  Write ('x0.re = ');
  Readln (x0.re);
  Write ('x0.im = ');
  Readln (x0.im);
  Write ('x1.re = ');
  Readln (x1.re);
  Write ('x1.im = ');
  Readln (x1.im);
  Write ('x2.re = ');
  Readln (x2.re);
  Write ('x2.im = ');
  Readln (x2.im);
  Write ('mit = ');
  Readln (mit);
  Write ('tol = ');
  Readln (tol);
  Muller (x0, x1, x2, f, mit, tol, x, fatx, it, st);
  Writeln ('x.re = ', x.re, '   x.im = ', x.im);
  Writeln ('fatx.re = ', fatx.re, '   fatx.im = ', fatx.im);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.