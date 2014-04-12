program Test_Neville;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    f, x     : vector;
{$I A:\INTERPOL\NEVILLE.PAS}
begin
  ClrScr;
  Writeln ('* Neville test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Write ('xx = ');
  Readln (xx);
  for i:=0 to n do
    begin
      Write ('f[', i, '] = ');
      Readln (f[i])
    end;
  Writeln;
  Writeln ('Neville (n, x, xx, f, st) = ', Neville(n, x, xx, f, st));
  Writeln ('st = ', st);
  Readln
end.