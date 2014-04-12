program Test_invsymmatrix;
{$N+,E-}
uses Crt;
type matrix = array [1..21, 1..20] of Extended;
var i, j, n, st : Integer;
    a           : matrix;
{$I A:\LINEQNS\INVSMTRX.PAS}
begin
  ClrScr;
  Writeln ('* invsymmatrix test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('a[', i, ',', j, '] = ');
        Readln (a[i,j])
      end;
  Writeln;
  invsymmatrix (n, a, st);
  for i:=2 to n+1 do
    for j:=1 to i-1 do
      Writeln ('a[', i, ',', j, '] = ', a[i,j]);
  Writeln ('st = ', st);
  Readln
end.