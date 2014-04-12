program Test_NewtonCotes;
{$N+,E-}
uses Crt;
type vector = array [0..3] of Integer;
     fx     = function (x : Extended) : Extended;
var i, n, st : Integer;
    nrho     : LongInt;
    a, b     : Extended;
    alpha    : vector;
{$I A:\INTEGR\NWTCOTES.PAS}
function f (x : Extended) : Extended; far;
begin
  f:=x*x
end;
{function f (x : Extended) : Extended; far;
begin
  f:=Sin(x/2)*Sin(x)/(17-8*Cos(x))
end;}
begin
  ClrScr;
  Writeln ('* NewtonCotes test *');
  Writeln;
  Write ('a = ');
  Readln (a);
  Write ('b = ');
  Readln (b);
  Write ('n (<=7 due to the definition of type "vector") = ');
  Readln (n);
  Write ('nrho = ');
  Readln (nrho);
  for i:=0 to (n div 2) do
    begin
      Write ('alpha[', i, '] = ');
      Readln (alpha[i])
    end;
  Writeln;
  Writeln ('NewtonCotes (a, b, f, n, nrho, alpha, st) = ',
           NewtonCotes(a, b, f, n, nrho, alpha, st));
  Writeln ('st = ', st);
  Readln
end.