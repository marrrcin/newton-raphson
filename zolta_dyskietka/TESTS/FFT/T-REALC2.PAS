program Test_realcoeffns2;
{$N+,E-}
uses Crt;
type vector1 = array [0..127] of Extended;
     vector2 = array [0..64] of Extended;
     vectorm = array [0..128] of Extended;
var i, m, st, p : Integer;
    y           : vector1;
    a, b        : vector2;
{$I A:\FFT\REALCNS2.PAS}
begin
  ClrScr;
  Writeln ('* realcoeffns2 test *');
  Writeln;
  Write ('p (<=6 due to the definitions of types "vector1", "vector2" '
         +'and "vectorm") = ');
  Readln (p);
  m:=1 shl p;
  for i:=0 to 2*m-1 do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  Writeln;
  realcoeffns2 (p, y, a, b, st);
  for i:=0 to m do
    Writeln ('a[', i, '] = ', a[i], '    b[', i, '] = ', b[i]);
  Writeln ('st = ', st);
  Readln
end.