program Test_Wielandt;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..20] of Boolean;
     matrix  = array [1..20, 1..20] of Extended;
var i, j, m1, m2, n, st : Integer;
    norm                : Extended;
    d, e, x             : vector;
    y                   : matrix;
{$I A:\EIGEN\WIELANDT.PAS}
begin
  ClrScr;
  Writeln ('* Wielandt test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector", "vector1" and '
         +'"matrix") = ');
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
  for i:=m1 to m2 do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Write ('norm = ');
  Readln (norm);
  Writeln;
  Wielandt (n, d, e, m1, m2, x, norm, y, st);
  for i:=m1 to m2 do
    for j:=1 to n do
      Writeln ('y[', i, ',', j, '] = ', y[i,j]);
  Writeln ('st = ', st);
  Readln
end.