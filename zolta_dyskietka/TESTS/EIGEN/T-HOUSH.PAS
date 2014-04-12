program Test_Householder;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     matrix  = array [1..20, 1..20] of Extended;
var i, j, n, st : Integer;
    d, e        : vector;
    a           : matrix;
{$I A:\EIGEN\HOUSHLDR.PAS}
begin
  ClrScr;
  Writeln ('* Householder test *');
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
  Householder (n, a, d, e, st);
  for i:=1 to n do
    Writeln ('d[', i, '] = ', d[i]);
  for i:=1 to n do
    Writeln ('e[', i, '] = ', e[i]);
  for i:=3 to n do
    for j:=1 to i-1 do
      Writeln ('a[', i, ',', j, '] = ', a[i,j]);
  Writeln ('st = ', st);
  Readln
end.