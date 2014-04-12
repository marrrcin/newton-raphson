program Test_complexmatrix;
{$N+,E-}
uses Crt;
type complex    = record
                    re, im : Extended
                  end;
     cplxvector = array [1..20] of complex;
     cplxmatrix = array [1..20, 1..21] of complex;
var i, j, n, st : Integer;
    a           : cplxmatrix;
    x           : cplxvector;
{$I A:\LINEQNS\CPLXMTRX.PAS}
begin
  ClrScr;
  Writeln ('* complexmatrix test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "cplxvector" and ');
  Write ('"cplxmatrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n+1 do
      begin
        Write ('a[', i, ',', j, '].re = ');
        Readln (a[i,j].re);
        Write ('a[', i, ',', j, '].im = ');
        Readln (a[i,j].im)
      end;
  Writeln;
  complexmatrix (n, a, x, st);
  for i:=1 to n do
    Writeln ('x[', i, '].re = ', x[i].re, '   x[', i, '].im = ', x[i].im);
  Writeln ('st = ', st);
  Readln
end.