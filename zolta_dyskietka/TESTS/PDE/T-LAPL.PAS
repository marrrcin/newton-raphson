program Test_Laplace;
{$N+,E-}
uses Crt;
type vector      = array [1..36] of Extended;
     vector1     = array [1..50] of Integer;
     vector2     = array [1..11] of Extended;
     vector3     = array [1..361] of Extended;
     vector4     = array [1..3] of Extended;
     vector5     = array [1..37] of Integer;
     vector6     = array [1..37] of Extended;
     matrix      = array [1..50, 1..3] of Integer;
     matrix1     = array [1..36, 1..7] of Integer;
     matrix3dim  = array [1..50, 1..3, 1..3] of Extended;
var i, j, l, m, n, nu, st : Integer;
    x, y                  : vector;
    nuxy                  : vector1;
    uxy                   : vector2;
    u                     : vector3;
    eln                   : matrix;
{$I A:\PDE\LAPLACE.PAS}
begin
  ClrScr;
  Writeln ('* Laplace test *');
  Writeln;
  Writeln ('n (<=36 due to the definitions of types "vector", "vector1"');
  Write ('   "vector3", "vector5", "vector6" and "matrix1") = ');
  Readln (n);
  Write ('m (<=50 due to the definitions of types "matrix" and "matrix3dim"'
         +') = ');
  Readln (m);
  Write ('nu (<=11 due to the definition of type "vector2") = ');
  Readln (nu);
  for i:=1 to n do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i])
    end;
  for i:=1 to n do
    begin
      Write ('y[', i, '] = ');
      Readln (y[i])
    end;
  for i:=1 to m do
    for j:=1 to 3 do
      begin
        Write ('eln[', i, ',', j, '] = ');
        Readln (eln[i,j])
      end;
  for i:=1 to nu do
    begin
      Write ('nuxy[', i, '] = ');
      Readln (nuxy[i])
    end;
  for i:=1 to nu do
    begin
      Write ('uxy[', i, '] = ');
      Readln (uxy[i])
    end;
  Writeln;
  Laplace (n, m, nu, x, y, eln, nuxy, uxy, u, st);
  l:=0;
  for i:=1 to n do
    begin
      l:=l+1;
      Writeln ('u[', i, '] = ', u[i]);
      if (l=20) and (i<n)
        then begin
               l:=0;
               Readln
             end
    end;
  Writeln ('st = ', st);
  Readln
end.