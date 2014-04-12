program Test_AdamsMoultonsystem;
{$N+,E-}
uses Crt;
type vector  = array [0..7] of Extended;
     vector1 = array [1..6] of Extended;
     matrix  = array [1..6, 0..6] of Extended;
     fxysys  = procedure (x     : Extended;
                          n     : Integer;
                          ya    : vector1;
                          var f : vector1);
var i, it, j, k, mit, n, st : Integer;
    inyvalue                : Byte;
    eps, h, rho, x0         : Extended;
    iny                     : Boolean;
    beta                    : vector;
    yk                      : vector1;
    y                       : matrix;
{$I A:\ODE\AMLTNSYS.PAS}
procedure fun (x     : Extended;
               n     : Integer;
               ya    : vector1;
               var f : vector1); far;
begin
  f[1]:=x+x*ya[1]+ya[1]+1
end;
procedure dfun (x      : Extended;
                n      : Integer;
                ya     : vector1;
                var df : vector1); far;
begin
  df[1]:=x+1
end;
{procedure fun (x     : Extended;
               n     : Integer;
               ya    : vector1;
               var f : vector1); far;
begin
  f[1]:=1/ya[2];
  f[2]:=-1/ya[1]
end;
procedure dfun (x      : Extended;
                n      : Integer;
                ya     : vector1;
                var df : vector1); far;
begin
  df[1]:=0;
  df[2]:=0
end;}
begin
  ClrScr;
  Writeln ('* AdamsMoultonsystem test *');
  Writeln;
  Write ('x0 = ');
  Readln (x0);
  Write ('k (<=7 due to the definitions of types "vector" and "matrix") = ');
  Readln (k);
  Write ('h = ');
  Readln (h);
  Write ('n (<=6 due to the definitions of types "vector1" and "matrix") = ');
  Readln (n);
  for i:=1 to n do
    for j:=0 to k-1 do
      begin
        Write ('y[', i, ',', j, '] = ');
        Readln (y[i,j])
      end;
  for j:=0 to k do
    begin
      Write ('beta[', j, '] = ');
      Readln (beta[j])
    end;
  Write ('rho = ');
  Readln (rho);
  Write ('eps = ');
  Readln (eps);
  Write ('mit = ');
  Readln (mit);
  Writeln ('iny (1 - initial approximation at x0+k*h equal to the');
  Writeln ('         solution at x0+(k-1)h,');
  Write ('     0 - enter initial approximation at x0+k*h) = ');
  Readln (inyvalue);
  case inyvalue of
    1 : iny:=True;
    0 : iny:=False
  end;
  if not iny
    then for i:=1 to n do
           begin
             Write ('yk[', i, '] = ');
             Readln (yk[i])
           end;
  Writeln;
  AdamsMoultonsystem (x0, k, h, n, y, fun, dfun, beta, rho, eps, mit, iny,
                      yk, it, st);
  Writeln ('x0 = ', x0);
  for i:=1 to n do
    for j:=0 to k-1 do
      Writeln ('y[', i, ',', j, '] = ', y[i,j]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.