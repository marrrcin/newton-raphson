program Test_Gram;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..16] of Extended;
var i, n, m, st  : Integer;
    h, x1, xx, y : Extended;
    f            : vector;
    g            : vector1;
{$I A:\APPROX\GRAM.PAS}
begin
  ClrScr;
  Writeln ('* Gram test *');
  Writeln;
  Write ('n (<=20 due to the definiton of type "vector") = ');
  Readln (n);
  Write ('x1 = ');
  Readln (x1);
  Write ('h = ');
  Readln (h);
  for i:=1 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Write ('m (<=15 due to the definiton of type "vector1") = ');
  Readln (m);
  Write ('xx = ');
  Readln (xx);
  Writeln;
  Gram (n, x1, h, f, m, xx, g, y, st);
  for i:=1 to m+1 do
    Writeln ('g[', i, '] = ', g[i]);
  Writeln ('y = ', y);
  Writeln ('st = ', st);
  Readln
end.