program Test_HessenbergQR;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     matrix  = array [1..20, 1..20] of Extended;
var i, it, j, n, st : Integer;
    eps             : Extended;
    h               : matrix;
    lambda          : vector;
{$I A:\EIGEN\HESSBGQR.PAS}
begin
  ClrScr;
  Writeln ('* HessenbergQR test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=1 to n do
      begin
        Write ('h[', i, ',', j, '] = ');
        Readln (h[i,j])
      end;
  Write ('it = ');
  Readln (it);
  Write ('eps = ');
  Readln (eps);
  Writeln;
  HessenbergQR (n, h, it, eps, lambda, st);
  for i:=1 to n do
    Writeln ('lambda[', i, '] = ', lambda[i]);
  Writeln ('st = ', st);
  Readln
end.