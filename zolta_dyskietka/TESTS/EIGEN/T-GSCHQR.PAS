program Test_GramSchmidtQR;
{$N+,E-}
uses Crt;
type vector  = array [1..25] of Extended;
     matrix  = array [1..20, 1..20] of Extended;
     matrix1 = array [1..25, 1..20] of Extended;
var i, j, m, n, st : Integer;
    a, q           : matrix;
    r              : matrix1;
{$I A:\EIGEN\GRSCHQR.PAS}
begin
  ClrScr;
  Writeln ('* GramSchmidtQR test *');
  Writeln;
  Write ('m (<=25 due to the definitions of types "vector", "matrix" and '
         +'"matrix1") = ');
  Readln (m);
  Write ('n (<=20 due to the definition of type "matrix") = ');
  Readln (n);
  for i:=1 to m do
    for j:=1 to n do
      begin
        Write ('a[', i, ',', j, '] = ');
        Readln (a[i,j])
      end;
  Writeln;
  GramSchmidtQR (m, n, a, q, r, st);
  for i:=1 to m do
    for j:=1 to n do
      Writeln ('q[', i, ',', j, '] = ', q[i,j]);
  for i:=1 to n do
    for j:=1 to n do
      Writeln ('r[', i, ',', j, '] = ', r[i,j]);
  Writeln ('st = ', st);
  Readln
end.