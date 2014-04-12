procedure polapprox (n       : Integer;
                     var x,f : vector;
                     m       : Integer;
                     var a   : vector0;
                     var h   : Extended;
                     var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure polapprox finds a polynomial a[0]+a[1]*x+...a[m]*x^m which }
{  approximates a function f(x) with given values f[j] at x[j]              }
{  (j=1,2,...,n).                                                           }
{  Data:                                                                    }
{    n - number of nodes,                                                   }
{    x - an array containing the values of nodes,                           }
{    f - an array containing the values of function at nodes,               }
{    m - the degree of approximation polynomial.                            }
{  Results:                                                                 }
{    a - an array of coefficients of the approximation polynomial,          }
{    h - accuracy of approximation.                                         }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure polapprox is assigned the }
{           value of:                                                       }
{             1, if m<0,                                                    }
{             2, if m>=n,                                                   }
{             3, if there exist x[k] and x[i] (k<>i; k,i=1,2,...,n) such    }
{                that x[k]=x[i],                                            }
{             4, if the matrix of a system of linear equations which is     }
{                solved within the procedure is singular,                   }
{             0, otherwise.                                                 }
{           Note: If st<>0, then h and the elements of array a are not      }
{                 calculated.                                               }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector0 - a type identifier of extended array [q0..qm], where q0<=0    }
{              and qm>=m,                                                   }
{    vector1 - a type identifier of integer array [q1..qm], where q1<=1 and }
{              qm>=m,                                                       }
{    matrix  - a type identifier of extended array [q0..qm,q0..qm], where   }
{              q0<=0 and qm>=m.                                             }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ip,j,jp,k,kp,l,count : Integer;
    p                      : array [1..2] of vector1;
    mx,s1,s2               : Extended;
    z                      : matrix;
    y                      : vector0;
begin
  st:=0;
  if m<0
    then st:=1
    else if m>=n
           then st:=2;
  if st=0
    then begin
           i:=1;
           while (i<=n-1) and (st=0) do
             begin
               j:=i+1;
               while (j<=n) and (st=0) do
                 begin
                   if x[i]=x[j]
                     then st:=3;
                   j:=j+1
                 end;
               i:=i+1
             end;
           if st=0
             then begin
                    for k:=0 to m do
                      begin
                        for i:=k to m do
                          begin
                            ip:=k+i;
                            s1:=0;
                            for j:=1 to n do
                              begin
                                mx:=1;
                                for l:=1 to ip do
                                  mx:=mx*x[j];
                                s1:=s1+mx
                              end;
                            z[k,i]:=s1;
                            z[i,k]:=s1
                          end;
                        s1:=0;
                        for j:=1 to n do
                          begin
                            mx:=1;
                            for l:=1 to k do
                              mx:=mx*x[j];
                            s1:=s1+f[j]*mx
                          end;
                        y[k]:=s1
                      end;
                    count:=0;
                    k:=0;
                    while (k<=m-1) and (st=0) do
                      begin
                        kp:=k+1;
                        mx:=abs(z[k,k]);
                        ip:=k;
                        jp:=k;
                        for i:=k to m do
                          for j:=k to m do
                            if abs(z[i,j])>mx
                              then begin
                                     mx:=abs(z[i,j]);
                                     ip:=i;
                                     jp:=j
                                   end;
                        if mx=0
                          then st:=4
                          else begin
                                 if k<>jp
                                   then begin
                                          count:=count+1;
                                          p[1,count]:=k;
                                          p[2,count]:=jp;
                                          for i:=0 to m do
                                            begin
                                              mx:=z[i,jp];
                                              z[i,jp]:=z[i,k];
                                              z[i,k]:=mx
                                            end
                                        end;
                                 if k<>ip
                                   then begin
                                          mx:=y[ip];
                                          y[ip]:=y[k];
                                          y[k]:=mx;
                                          for i:=0 to m do
                                            begin
                                              mx:=z[ip,i];
                                              z[ip,i]:=z[k,i];
                                              z[k,i]:=mx
                                            end
                                        end;
                                 for i:=kp to m do
                                   begin
                                     mx:=z[i,k]/z[k,k];
                                     y[i]:=y[i]-mx*y[k];
                                     for j:=kp to m do
                                       z[i,j]:=z[i,j]-mx*z[k,j]
                                   end
                               end;
                        k:=k+1
                      end;
                    if z[m,m]=0
                      then st:=4;
                    if st=0
                      then begin
                             a[m]:=y[m]/z[m,m];
                             for k:=m-1 downto 0 do
                               begin
                                 s1:=y[k];
                                 for j:=k+1 to m do
                                   s1:=s1-z[k,j]*a[j];
                                 a[k]:=s1/z[k,k]
                               end;
                             for j:=count downto 1 do
                               begin
                                 ip:=p[1,j];
                                 jp:=p[2,j];
                                 mx:=a[ip];
                                 a[ip]:=a[jp];
                                 a[jp]:=mx
                               end;
                             s1:=0;
                             for j:=1 to n do
                               begin
                                 s2:=a[m];
                                 for i:=m-1 downto 0 do
                                   s2:=s2*x[j]+a[i];
                                 s2:=f[j]-s2;
                                 s1:=s1+s2*s2
                               end;
                             h:=s1
                           end
                  end
         end
end;