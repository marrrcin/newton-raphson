program Test_realcoeffns;
{$N+,E-}
uses Crt;
type vector1 = array [0..127] of Extended;
     vector2 = array [0..64] of Extended;
var i, n, st, p : Integer;
    y           : vector1;
    a, b        : vector2;
{$I A:\FFT\REALCNS.PAS}
begin
  ClrScr;
  Writeln ('* realcoeffns test *');
  Writeln;
  Write ('p (<=6 due to the definitions of types "vector1" and "vector2") = ');
  Readln (p);
  n:=1 shl p;
  for i:=0 to 2*n-1 do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  Writeln;
  realcoeffns (p, y, a, b, st);
  for i:=0 to n do
    Writeln ('a[', i, '] = ', a[i], '    b[', i, '] = ', b[i]);
  Writeln ('st = ', st);
  Readln
end.