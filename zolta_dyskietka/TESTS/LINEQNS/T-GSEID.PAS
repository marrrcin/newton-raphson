program Test_GaussSeidel;
{$N+,E-}
uses Crt;
type vector = array [1..20] of Extended;
     matrix = array [1..20, 1..20] of Extended;
var i, it, j, mit, n, st : Integer;
    eps                  : Extended;
    a                    : matrix;
    b, x                 : vector;
{$I A:\LINEQNS\GSEIDEL.PAS}
begin
  ClrScr;
  Writeln ('* GaussSeidel test *');
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
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  for i:=1 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Writeln;
  GaussSeidel (n, a, b, mit, eps, x, it, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.