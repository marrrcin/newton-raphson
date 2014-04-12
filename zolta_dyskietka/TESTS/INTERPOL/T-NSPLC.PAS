program Test_naturalsplinecoeffns;
{$N+,E-}
uses Crt;
type vector  = array [0..20] of Extended;
     vector1 = array [1..18] of Extended;
     vector2 = array [2..19] of Extended;
     matrix  = array [0..3, 0..19] of Extended;
var i, n, st       : Integer;
    x, f           : vector;
    ai, bi, ci, di : Extended;
    a              : matrix;
{$I A:\INTERPOL\NSPLCNS.PAS}
begin
  ClrScr;
  Writeln ('* naturalsplinecoeffns test *');
  Writeln;
  Writeln ('n (<=20 due to the definitions of types "vector", "vector1", '
           +'"vector2"');
  Write ('   and "matrix") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=0 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Writeln;
  naturalsplinecoeffns (n, x, f, a, st);
  Writeln ('Coefficients of the spline');
  Writeln ('before the succeeding powers of x:   before the succeeding powers'
           +' of x-x[i]:');
  for i:=0 to n-1 do
    begin
      Writeln ('i = ', i);
      di:=a[3,i];
      Writeln ('x^3: a[3,', i, ']=', di,
               '  (x-x[', i, '])^3: d[', i, ']=', di);
      ci:=a[2,i]+3*di*x[i];
      Writeln ('x^2: a[2,', i, ']=', a[2,i],
               '  (x-x[', i, '])^2: c[', i, ']=', ci);
      bi:=a[1,i]+(-3*di*x[i]+2*ci)*x[i];
      Writeln ('x  : a[1,', i, ']=', a[1,i],
               '   x-x[', i, ']   : b[', i, ']=', bi);
      ai:=a[0,i]+((di*x[i]-ci)*x[i]+bi)*x[i];
      Writeln ('     a[0,', i, ']=', a[0,i],
               '              a[', i, ']=', ai)
    end;
  Writeln ('st = ', st);
  Readln
end.