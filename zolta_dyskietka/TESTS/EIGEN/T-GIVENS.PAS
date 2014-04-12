program Test_Givens;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
var i, m1, m2, n, st : Integer;
    eps1, eps2       : Extended;
    d, e, x          : vector;
{$I A:\EIGEN\GIVENS.PAS}
begin
  ClrScr;
  Writeln ('* Givens test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('d[', i, '] = ');
      Readln (d[i])
    end;
  for i:=1 to n do
    begin
      Write ('e[', i, '] = ');
      Readln (e[i])
    end;
  Write ('m1 = ');
  Readln (m1);
  Write ('m2 = ');
  Readln (m2);
  Write ('eps1 = ');
  Readln (eps1);
  Writeln;
  Givens (n, d, e, m1, m2, eps1, x, eps2, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('eps2 = ', eps2, '   st = ', st);
  Readln
end.