program Test_complexvalues;
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
{$I A:\FFT\CPLXVLS.PAS}
begin
  ClrScr;
  Writeln ('* complexvalues test *');
  Writeln;
  Write ('p (<=7 due to the definitions of types "cplxvector" and '
         +'"cplxvector1") = ');
  Readln (p);
  n:=1 shl p;
  for i:=0 to n-1 do
    begin
      Write ('beta[', i, '].re = ');
      Readln (beta[i].re);
      Write ('beta[', i, '].im = ');
      Readln (beta[i].im)
    end;
  Writeln;
  complexvalues (p, beta, f, st);
  for i:=0 to n-1 do
    Writeln ('f[', i, '].re = ', f[i].re, '    f[', i, '].im = ', f[i].im);
  Writeln ('st = ', st);
  Readln
end.