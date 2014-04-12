program Test_realvalues;
{$N+,E-}
uses Crt;
type vector1 = array [0..127] of Extended;
     vector2 = array [0..64] of Extended;
var i, n, st, p : Integer;
    y           : vector1;
    a, b        : vector2;
{$I A:\FFT\REALVLS.PAS}
begin
  ClrScr;
  Writeln ('* realvalues test *');
  Writeln;
  Write ('p (<=6 due to the definitions of types "vector1" and "vector2") = ');
  Readln (p);
  n:=1 shl p;
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  for i:=0 to n do
    begin
      Write ('b[', i, '] = ');
      Readln (b[i])
    end;
  Writeln;
  realvalues (p, a, b, y, st);
  for i:=0 to 2*n-1 do
    Writeln ('y[', i, '] = ', y[i]);
  Writeln ('st = ', st);
  Readln
end.