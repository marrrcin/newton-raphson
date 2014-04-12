program Test_Gauss;
{$N+,E-}
uses Crt;
type vector = array [1..20] of Extended;
     matrix = array [1..20, 1..20] of Extended;
var i, j, n, st : Integer;
    a           : matrix;
    b, x        : vector;
{$I A:\LINEQNS\GAUSS.PAS}
begin
  ClrScr;
  Writeln ('* Gauss test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
    begin
      Write ('a[', i, ',', j, '] = ');
      Readln (a[i,j])
    end;
  for i:=1 to n do
    begin
      Write ('b[', i, '] = ');
      Readln (b[i])
    end;
  Writeln;
  Gauss (n, a, b, x, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('st = ', st);
  Readln
end.