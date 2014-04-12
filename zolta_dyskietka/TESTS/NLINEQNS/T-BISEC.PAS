program Test_bisection;
{$N+,E-}
uses Crt;
type vector = array [0..20] of Extended;
var i, it, mit, n, st   : Integer;
    alpha, beta, eps, w : Extended;
    a                   : vector;
{$I A:\NLINEQNS\BISECTN.PAS}
begin
  ClrScr;
  Writeln ('* bisection test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  for i:=0 to n do
    begin
      Write ('a[', i, '] = ');
      Readln (a[i])
    end;
  Write ('alpha = ');
  Readln (alpha);
  Write ('beta = ');
  Readln (beta);
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Writeln ('bisection (n, a, alpha, beta, mit, eps, w, it, st) = ',
           bisection (n, a, alpha, beta, mit, eps, w, it, st));
  Writeln ('alpha = ', alpha, '   beta = ', beta);
  Writeln ('w = ', w, '   it = ', it, '   st = ', st);
  Readln
end.