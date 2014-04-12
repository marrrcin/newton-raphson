program Test_Hermitecoeffns;
{$N+,E-}
uses Crt;
type vector   = array [0..20] of Extended;
     vector2  = array [0..20] of Extended;
     vector3  = array [0..20] of Integer;
var i, j, k, l, n, p, st : Integer;
    f                    : vector;
    x                    : vector2;
    m                    : vector3;
    H                    : Extended;
    deriv                : Boolean;
{$I A:\INTERPOL\HRMTCNS.PAS}
begin
  ClrScr;
  Writeln ('* Hermitecoeffns test *');
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
  Writeln;
  Hermitecoeffns (n, k, x, m, f, st);
  for i:=0 to n do
    Writeln ('f[', i, '] = ', f[i]);
  Writeln ('st = ', st);
  Readln;
  Writeln ('The calculated values of the polynomial and its derivatives '
           +' at nodes :');
  for i:=0 to k do
    begin
      if i=0
        then l:=0
        else l:=l+m[i-1];
      for j:=l to l+m[i]-1 do
        begin
          Write ('H');
          for p:=0 to j-l-1 do
            Write ('''');
          deriv:=True;
          case j-l-1 of
            -1 : begin
                   H:=f[n];
                   for p:=n-1 downto 0 do
                     H:=H*x[i]+f[p]
                 end;
             0 : begin
                   H:=n*f[n];
                   for p:=n-1 downto 1 do
                     H:=H*x[i]+p*f[p]
                 end;
             1 : begin
                   H:=n*(n-1)*f[n];
                   for p:=n-1 downto 2 do
                     H:=H*x[i]+p*(p-1)*f[p]
                 end;
            else deriv:=False
          end;
          Write ('(', x[i], ') = ');
          if deriv
            then Writeln (H)
            else Writeln ('not calculated')
        end
    end;
  Readln
end.