program Test_Hermitevalue;
{$N+,E-}
uses Crt;
type vector   = array [0..20] of Extended;
     vector2  = array [0..20] of Extended;
     vector3  = array [0..20] of Integer;
var i, j, n, k, l, p, st : Integer;
    xx                   : Extended;
    f                    : vector;
    x                    : vector2;
    m                    : vector3;
{$I A:\INTERPOL\HRMTVAL.PAS}
begin
  ClrScr;
  Writeln ('* Hermitevalue test *');
  Writeln;
  Write ('n (<=20 due to the definition of type "vector") = ');
  Readln (n);
  Write ('k (<=20 due to the definitions of types "vector2" and "vector3")'
         +' = ');
  Readln (k);
  for i:=0 to k do
    begin
      Write ('x[', i, '] = ');
      Readln (x[i]);
      Write ('m[', i, '] = ');
      Readln (m[i])
    end;
  for i:=0 to k do
    begin
      if i=0
        then l:=0
        else l:=l+m[i-1];
      for j:=l to l+m[i]-1 do
        begin
          Write ('f');
          for p:=0 to j-l-1 do
            Write ('''');
          Write ('(x[', i, ']) = ');
          Readln (f[j])
        end
    end;
  Write ('xx = ');
  Readln (xx);
  Writeln;
  Writeln ('Hermitevalue (n, k, x, m, f, xx, st) = ',
           Hermitevalue (n, k, x, m, f, xx, st));
  Writeln ('st = ', st);
  Readln
end.