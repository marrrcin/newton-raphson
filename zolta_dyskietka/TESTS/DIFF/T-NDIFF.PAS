program Test_Newtondiff;
{$N+,E-}
uses Crt, Dos;
type vector = array [0..20] of Extended;
var i, n, st : Integer;
    xx       : Extended;
    x, y     : vector;
{$I A:\DIFF\NWTDIFF.PAS}
begin
  ClrScr;
  Writeln ('* Newtondiff test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=0 to n do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  Write ('xx = ');
  Readln (xx);
  Writeln ('Newtondiff (n, x, y, xx, st) = ', Newtondiff(n, x, y, xx, st));
  Writeln ('st = ', st);
  Readln
end.