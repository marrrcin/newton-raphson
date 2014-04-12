program Test_detrealmatrix;
{$N+,E-}
uses Crt;
type matrix = array [1..20, 1..20] of Extended;
var i, j, n, st : Integer;
    a           : matrix;
{$I A:\LINEQNS\DETRMTRX.PAS}
begin
  ClrScr;
  Writeln ('* detrealmatrix test *');
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
  Writeln ('det = ', detrealmatrix (n, a, st));
  Writeln ('st = ', st);
  Readln
end.