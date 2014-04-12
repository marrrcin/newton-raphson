program Test_GaussJordan;
{$N+,E-}
uses Crt;
type vector       = array [1..121] of Extended;
     vector1      = array [1..21] of Extended;
     vector2      = array [1..21] of Integer;
     coefficients = procedure (i, n  : Integer;
                               var a : vector1);
var i, n, st : Integer;
    x        : vector;
    a        : vector1;
{$I A:\LINEQNS\GJORDAN.PAS}
procedure oneeqn (i, n  : Integer;
                  var a : vector1); far;
begin
  case i of
    1 : begin
          a[1]:=3;  a[2]:=1;  a[3]:=6;  a[4]:=2
        end;
    2 : begin
          a[1]:=2;  a[2]:=1;  a[3]:=3;  a[4]:=7
        end;
    3 : begin
          a[1]:=1;  a[2]:=1;  a[3]:=1;  a[4]:=4
        end
  end
end;
{procedure oneeqn (i, n  : Integer;
                  var a : vector1); far;
begin
  case i of
    1 : begin
          a[1]:=3.9859265;  a[2]:=-374.8678824;  a[3]:=-8.5662110918;
          a[4]:=4.8650891;  a[5]:=0.99864123;  a[6]:=1
        end;
    2 : begin
          a[1]:=42.7856242;  a[2]:=-4.5346826;  a[3]:=3.86425767;
          a[4]:=-0.7643424;  a[5]:=6.754368;  a[6]:=2
        end;
    3 : begin
          a[1]:=0.54576547138;  a[2]:=46.586424689;  a[3]:=-0.632539975;
          a[4]:=4.234342458;  a[5]:=75.535008858;  a[6]:=0
        end;
    4 : begin
          a[1]:=0.583563489427;  a[2]:=0.9583924;  a[3]:=-9.9543726;
          a[4]:=0.83546556;  a[5]:=-857.834678;  a[6]:=-1
        end;
    5 : begin
          a[1]:=0.34809870124;  a[2]:=-7.7769750323;  a[3]:=97.64870949;
          a[4]:=8.56801507;  a[5]:=80;  a[6]:=-1
        end
  end
end;}
{procedure oneeqn (i, n  : Integer;
                  var a : vector1); far;
begin
  case i of
    1 : begin
          a[1]:=1;  a[2]:=1;  a[3]:=1
        end;
    2 : begin
          a[1]:=1;  a[2]:=1;  a[3]:=2
        end
  end
end;}
begin
  ClrScr;
  Writeln ('* GaussJordan test *');
  Writeln;
  Write ('n (<=20 due to the definitions of types "vector", "vector1" ');
  Write ('and "vector2") = ');
  Readln (n);
  Writeln;
  GaussJordan (n, oneeqn, x, st);
  for i:=1 to n do
    Writeln ('x[', i, '] = ', x[i]);
  Writeln ('st = ', st);
  Readln
end.