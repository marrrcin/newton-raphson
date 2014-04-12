program Test_AdamsBashforthsystem;
{$N+,E-}
uses Crt;
type vector  = array [0..7] of Extended;
     vector1 = array [1..6] of Extended;
     matrix  = array [1..6, 0..7] of Extended;
     fxysys  = procedure (x     : Extended;
                          n     : Integer;
                          ya    : vector1;
                          var f : vector1);
var i, j, k, n, st : Integer;
    h, rho, x0     : Extended;
    beta           : vector;
    y              : matrix;
{$I A:\ODE\ABASHSYS.PAS}
procedure fun (x     : Extended;
               n     : Integer;
               ya    : vector1;
               var f : vector1); far;
begin
  f[1]:=x+x*ya[1]+ya[1]+1
end;
{procedure fun (x     : Extended;
               n     : Integer;
               ya    : vector1;
               var f : vector1); far;
begin
  f[1]:=1/ya[2];
  f[2]:=-1/ya[1]
end;}
begin
  ClrScr;
  Writeln ('* AdamsBashforthsystem test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('k (<=7 due to the definitions of types "vector" and "matrix") = ');
  Readln (k);
  Write ('h = ');
  Readln (h);
  Write ('n (<=6 due to the definition of types "vector1" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=0 to k-1 do
      begin
        Write ('y[', i, ',', j, '] = ');
        Readln (y[i,j])
      end;
  for j:=0 to k-1 do
    begin
      Write ('beta[', j, '] = ');
      Readln (beta[j])
    end;
  Write ('rho = ');
  Readln (rho);
  Writeln;
  AdamsBashforthsystem (x0, k, h, n, y, fun, beta, rho, st);
  Writeln ('x0 = ', x0);
  for i:=1 to n do
    for j:=0 to k-1 do
      Writeln ('y[', i, ',', j, '] = ', y[i,j]);
  Writeln ('st = ', st);
  Readln
end.