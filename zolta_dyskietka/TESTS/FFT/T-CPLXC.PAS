program Test_complexcoeffns;
{$N+,E-}
uses Crt;
type complex     = record
                     re, im : Extended
                   end;
     cplxvector  = array [0..127] of complex;
     cplxvector1 = array [0..255] of complex;
var i, n, p, st : Integer;
    f           : cplxvector;
    beta        : cplxvector1;
{$I A:\FFT\CPLXCNS.PAS}
begin
  ClrScr;
  Writeln ('* complexcoeffns test *');
  Writeln;
  Write ('p (<=7 due to the definitions of types "cplxvector" and '
         +'"cplxvector1") = ');
  Readln (p);
  n:=1 shl p;
  for i:=0 to n-1 do
    begin
      Write ('f[', i, '].re = ');
      Readln (f[i].re);
      Write ('f[', i, '].im = ');
      Readln (f[i].im)
    end;
  Writeln;
  complexcoeffns (p, f, beta, st);
  for i:=0 to n-1 do
    Writeln ('beta[', i, '].re = ', beta[i].re,
             '    beta[', i, '].im = ', beta[i].im);
  Writeln ('st = ', st);
  Readln
end.