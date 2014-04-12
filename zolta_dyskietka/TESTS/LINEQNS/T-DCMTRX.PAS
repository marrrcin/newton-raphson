program Test_detcomplexmatrix;
{$N+,E-}
uses Crt;
type complex    = record
                    re, im : Extended
                  end;
     cplxmatrix = array [1..20, 1..20] of complex;
var i, j, n, st : Integer;
    det         : complex;
    a           : cplxmatrix;
{$I A:\LINEQNS\DETCMTRX.PAS}
begin
  ClrScr;
  Writeln ('* detcomplexmatrix test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "cplxmatrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('a[', i, ',', j, '].re = ');
        Readln (a[i,j].re);
        Write ('a[', i, ',', j, '].im = ');
        Readln (a[i,j].im)
      end;
  Writeln;
  detcomplexmatrix (n, a, det, st);
  Writeln ('det.re = ', det.re, '   det.im = ', det.im);
  Writeln ('st = ', st);
  Readln
end.