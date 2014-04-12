program Test_Chebyshev;
{$N+,E-}
uses Crt;
type vector = array [1..20] of Extended;
     matrix = array [1..20, 1..20] of Extended;
var i, it, j, mit, n, s, st : Integer;
    alpha, beta, eps        : Extended;
    a                       : matrix;
    b, x                    : vector;
{$I A:\LINEQNS\CHEBYSHV.PAS}
begin
  ClrScr;
  Writeln ('* Chebyshev test *');
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
  Write ('s = ');
  Readln (s);
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
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
  Chebyshev (n, a, b, s, alpha, beta, mit, eps, x, it, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.