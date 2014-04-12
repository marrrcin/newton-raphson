program Test_Mullerroots;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     complex = record
                 re, im : Extended
               end;
var i, it, mit, n, st : Integer;
    tol               : Extended;
    a                 : vector;
    x, x0, watx       : complex;
{$I A:\NLINEQNS\MROOTS.PAS}
begin
  ClrScr;
  Writeln ('* Mullerroots test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('x0.re = ');
  Readln (x0.re);
  Write ('x0.im = ');
  Readln (x0.im);
  Write ('mit = ');
  Readln (mit);
  Write ('tol = ');
  Readln (tol);
  Mullerroots (n, a, x0, mit, tol, x, watx, it, st);
  Writeln ('x.re = ', x.re, '   x.im = ', x.im);
  Writeln ('watx.re = ', watx.re, '   watx.im = ', watx.im);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.