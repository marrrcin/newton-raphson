program Test_trimatrix;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..19] of Extended;
     vector2 = array [2..20] of Extended;
var i, n, st : Integer;
    a, d     : vector;
    b        : vector1;
    c        : vector2;
{$I A:\LINEQNS\TRIMTRX.PAS}
begin
  ClrScr;
  Writeln ('* trimatrix test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector", "vector1" ');
  Write ('and "vector2") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  for i:=1 to n-1 do
    begin
      Write ('b[', i, '] = ');
      Readln (b[i])
    end;
  for i:=2 to n do
    begin
      Write ('c[', i, '] = ');
      Readln (c[i])
    end;
  for i:=1 to n do
    begin
      Write ('d[', i, '] = ');
      Readln (d[i])
    end;
  Writeln;
  trimatrix (n, a, b, c, d, st);
  for i:=1 to n do
    Writeln ('d[', i, '] = ', d[i]);
  Writeln ('st = ', st);
  Readln
end.