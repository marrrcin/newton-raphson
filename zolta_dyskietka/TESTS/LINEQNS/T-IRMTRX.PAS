program Test_invrealmatrix;
{$N+,E-}
uses Crt;
type matrix = array [1..20, 1..20] of Extended;
     vector = array [1..20] of Integer;
var i, j, n, st : Integer;
    a, b        : matrix;
{$I A:\LINEQNS\INVRMTRX.PAS}
begin
  ClrScr;
  Writeln ('* invrealmatrix test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('a[', i, ',', j, '] = ');
        Readln (a[i,j])
      end;
  Writeln;
  invrealmatrix (n, a, b, st);
  for i:=1 to n do
    for j:=1 to n do
      Writeln ('b[', i, ',', j, '] = ', b[i,j]);
  Writeln ('st = ', st);
  Readln
end.