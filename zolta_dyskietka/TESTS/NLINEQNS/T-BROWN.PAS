program Test_Brown;
{$N+,E-}
uses Crt;
type vector  = array [1..20] of Extended;
     vector1 = array [1..20] of Integer;
     matrix  = array [1..20, 1..21] of Extended;
     matrix1 = array [1..20, 1..20] of Integer;
     fx      = function (i, n : Integer;
                         x    : vector) : Extended;
var i, it, mit, n, st : Integer;
    eps, zero         : Extended;
    x                 : vector;
{$I A:\NLINEQNS\BROWN.PAS}
function f (i, n : Integer;
            x    : vector) : Extended; far;
begin
  case i of
    1 : f:=3*x[1]-Cos(x[2]*x[3])-0.5;
    2 : f:=Sqr(x[1])-81*Sqr(x[2]+0.1)+Sin(x[3])+1.06;
    3 : f:=Exp(-x[1]*x[2])+20*x[3]+(10*Pi-3)/3
  end
end;
procedure df (i, n      : Integer;
              x         : vector;
              var dfatx : vector); far;
begin
  case i of
    1 : begin
          dfatx[1]:=3;
          dfatx[2]:=x[3]*Sin(x[2]*x[3]);
          dfatx[3]:=x[2]*Sin(x[2]*x[3])
        end;
    2 : begin
          dfatx[1]:=2*x[1];
          dfatx[2]:=-162*(x[2]+0.1);
          dfatx[3]:=Cos(x[3])
        end;
    3 : begin
          dfatx[1]:=-x[2]*Exp(-x[1]*x[2]);
          dfatx[2]:=-x[1]*Exp(-x[1]*x[2]);
          dfatx[3]:=20
        end
  end
end;
{function f (i, n : Integer;
            x    : vector) : Extended; far;
begin
  case i of
    1 : f:=2*Sqr(x[1])+x[2]+x[3];
    2 : f:=x[1]*x[2]-x[3]+2;
    3 : f:=(x[1]-x[2])*x[3]
  end
end;}
{function f (i, n : Integer;
            x    : vector) : Extended; far;
begin
  case i of
    1 : f:=Sqr(x[1])+8*x[2]-16;
    2 : f:=x[1]-Exp(x[2])
  end
end;}
begin
  ClrScr;
  Writeln ('* Brown test *');
  Writeln;
  Writeln ('n (<=20 due to the definitions of types "vector", "vector1", '
         +'"matrix"');
  Write ('   and "matrix1") = ');
  Readln (n);
  for i:=1 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  Write ('mit = ');
  Readln (mit);
  Write ('eps = ');
  Readln (eps);
  Write ('zero = ');
  Readln (zero);
  Brown (n, x, f, mit, eps, zero, it, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('it = ', it, '   st = ', st);
  Readln
end.