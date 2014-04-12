program Test_eigensymmatrix;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..110] of Extended;
     vector2 = array [1..20] of Boolean;
     matrix  = array [1..20, 1..20] of Extended;
var i, j, k1, k2, n, st : Integer;
    vec                 : Boolean;
    c                   : Char;
    x                   : vector;
    a                   : vector1;
    y                   : matrix;
{$I A:\EIGEN\EIGENSYM.PAS}
begin
  ClrScr;
  Writeln ('* eigensymmatrix test *');
  Writeln;
  Writeln ('n (<=20 due to the definitions of types "vector", "vector1", '
           +'"vector2"');
  Write ('   and "matrix") = ');
  Readln (n);
  for i:=1 to n*(n+1) div 2 do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('k1 = ');
  Readln (k1);
  Write ('k2 = ');
  Readln (k2);
  Writeln ('The procedure can calculate eigenvalues and corresponding '
           +'eigenvectors');
  Writeln ('or only eigenvalues.');
  Write ('Calculate only eigenvalues? [Y/N]');
  repeat
    c:=ReadKey;
    c:=UpCase(c)
  until (c='Y') or (c='N');
  if c='Y'
    then vec:=False
    else vec:=True;
  Writeln;
  eigensymmatrix (n, a, k1, k2, vec, x, y, st);
  for i:=k1 to k2 do
    Writeln ('x[', i, '] = ', x[i]);
  for i:=k1 to k2 do
    for j:=1 to n do
      Writeln ('y[', i, ',', j, '] = ', y[i,j]);
  Writeln ('st = ', st);
  Readln
end.