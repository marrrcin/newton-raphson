program Test_Bairstow;
{$N+,E-}
uses Crt;
type vector     = array [0..20] of Extended;
     cplxvector = array [1..20] of record
                                     re, im : Extended
                                   end;
var i, it, mit, n, st   : Integer;
    mincorr, zerodet    : Extended;
    a                   : vector;
    w, z                : cplxvector;
{$I A:\NLINEQNS\BAIRSTOW.PAS}
begin
  ClrScr;
  Writeln ('* Bairstow test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('mit = ');
  Readln (mit);
  Write ('mincorr = ');
  Readln (mincorr);
  Write ('zerodet = ');
  Readln (zerodet);
  Bairstow (n, a, mit, mincorr, zerodet, z, w, it, st);
  for i:=1 to n do
    Writeln ('z[', i, '].re = ', z[i].re, '   z[', i, '].im = ', z[i].im);
  for i:=1 to n do
    Writeln ('w[', i, '].re = ', w[i].re, '   w[', i, '].im = ', w[i].im);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.