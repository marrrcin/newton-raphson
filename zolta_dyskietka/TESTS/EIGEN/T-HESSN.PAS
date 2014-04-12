program Test_Hessenberg;
{$N+,E-}
uses Crt;
type matrix = array [1..20, 1..20] of Extended;
var i, j, n, st : Integer;
    a           : matrix;
{$I A:\EIGEN\HESSENBG.PAS}
begin
  ClrScr;
  Writeln ('* Hessenberg test *');
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
  Hessenberg (n, a, st);
  for i:=1 to n do
    for j:=1 to n do
      Writeln ('a[', i, ',', j, '] = ', a[i,j]);
  Writeln ('st = ', st);
  Readln
end.