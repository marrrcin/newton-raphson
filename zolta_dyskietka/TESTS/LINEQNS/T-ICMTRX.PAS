program Test_invcomplexmatrix;
{$N+,E-}
uses Crt;
type complex    = record
                    re, im : Extended
                  end;
     cplxmatrix = array [1..20, 1..20] of complex;
     vector     = array [1..20] of Integer;
var i, j, n, st : Integer;
    a, b        : cplxmatrix;
{$I A:\LINEQNS\INVCMTRX.PAS}
begin
  ClrScr;
  Writeln ('* invcomplexmatrix test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and ');
  Write ('"cplxmatrix") = ');
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
  invcomplexmatrix (n, a, b, st);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('b[', i, ',', j, '].re = ', b[i,j].re);
        Writeln ('   b[', i, ',', j, '].im = ', b[i,j].im)
      end;
  Writeln ('st = ', st);
  Readln
end.