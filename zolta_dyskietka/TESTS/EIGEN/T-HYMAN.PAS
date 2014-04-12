program Test_Hyman;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     matrix  = array [1..20, 1..20] of Extended;
var i, it, j, n, st : Integer;
    eps, lambda0    : Extended;
    b               : matrix;
{$I A:\EIGEN\HYMAN.PAS}
begin
  ClrScr;
  Writeln ('* Hyman test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('b[', i, ',', j, '] = ');
        Readln (b[i,j])
      end;
  Write ('lambda0 = ');
  Readln (lambda0);
  Write ('it = ');
  Readln (it);
  Write ('eps = ');
  Readln (eps);
  Writeln;
  Writeln ('Hyman (n, b, lambda0, it, eps, st) = ', Hyman (n, b, lambda0, it,
           eps, st));
  Writeln ('st = ', st);
  Readln
end.