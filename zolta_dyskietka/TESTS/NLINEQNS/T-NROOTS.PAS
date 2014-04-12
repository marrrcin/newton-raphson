program Test_Newtonroots;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, it, mit, n, st  : Integer;
    eps, w, x          : Extended;
    a                  : vector;
{$I A:\NLINEQNS\NWTROOTS.PAS}
begin
  ClrScr;
  Writeln ('* Newtonroots test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('x = ');
  Readln (x);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('Newtonroots (n, a, x, mit, eps, w, it, st) = ',
           Newtonroots (n, a, x, mit, eps, w, it, st));
  Writeln ('w = ', w, '   it = ', it, '   st = ', st);
  Readln
end.