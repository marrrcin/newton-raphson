program Test_powermethod;
{$N+,E-}
uses Crt;
type vector = array [1..20] of Extended;
     matrix = array [1..20, 1..20] of Extended;
var i, it, j, n, st : Integer;
    eps, m          : Extended;
    a               : matrix;
    x, x1           : vector;
{$I A:\EIGEN\POWER.PAS}
begin
  ClrScr;
  Writeln ('* powermethod test *');
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
      Write ('x1[', i, '] = ');
      Readln (x1[i])
    end;
  Write ('it = ');
  Readln (it);
  Write ('eps = ');
  Readln (eps);
  Writeln;
  powermethod (n, a, x1, it, eps, x, m, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('m = ', m, '   st = ', st);
  Readln
end.