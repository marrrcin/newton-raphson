procedure Broyden (n         : Integer;
                   var x     : vector;
                   f         : fx;
                   df        : dfx;
                   mit       : Integer;
                   tol       : Extended;
                   var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Broyden solves a system of n nonlinear equations of the    }
{  form f[i](x[1],x[2],...,x[n])=0 (i=1,2,...,n) by Broyden's algorithm.    }
{  Data:                                                                    }
{    n   - number of equations,                                             }
{    x   - an array the elements x[i] (i=1,2,...,n ) of which contain       }
{          initial approximations to n components of the solution (changed  }
{          on exit),                                                        }
{    f   - a Turbo Pascal function which calculates the value of function   }
{          f[i],                                                            }
{    df  - a Turbo Pascal procedure which calculates the values of          }
{          derivatives df[i]/dx[j] (j=1,2,...,n),                           }
{    mit - maximum number of iterations in the algorithm,                   }
{    tol - tolerance for solution.                                          }
{  Results:                                                                 }
{    x  - an array containing the solution,                                 }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Broyden is assigned the     }
{         value of:                                                         }
{           1, if n<1 or mit<1,                                             }
{           2, if the matrix with elements df[i]/dx[j] is singular,         }
{           3, if the number of iterations is greater than mit,             }
{           0, otherwise.                                                   }
{         Note: If st=1 or 2, then x is not changed on exit and the value   }
{               of it is not calculated. If st=3, then the array x contains }
{               the last approximation to the solution.                     }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of integer array [q1..qn], where q1<=1     }
{              and qn1>=n+1,                                                }
{    matrix  - a type identifier of extended array [q1..qn,q1..qn], where   }
{              q1<=1 and qn>=n,                                             }
{    fx      - a procedural-type identifier defined as follows              }
{                type fx = function (i,n : Integer;                         }
{                                    x   : vector) : Extended;              }
{    dfx     - a procedural-type identifier defined as follows              }
{                type dfx = procedure (i,n       : Integer;                 }
{                                      x         : vector;                  }
{                                      var dfatx : vector);                 }
{  Note: A function and a procedure passed as parameters should be declared }
{        with a far directive or compiled in the $F+ state.                 }
{                                                                           }
{---------------------------------------------------------------------------}
procedure mtrxvctr (n     : Integer;
                    a     : matrix;
                    b     : vector;
                    var c : vector);
var i,j : Integer;
    sum : Extended;
begin
  for i:=1 to n do
    begin
      sum:=0;
      for j:=1 to n do
        sum:=sum+a[i,j]*b[j];
      c[i]:=sum
    end
end {mtrxvctr};
var i,ih,j,k        : Integer;
    m,max,p,sz      : Extended;
    a,b,c           : matrix;
    dfatx,s,v,w,y,z : vector;
    wi              : vector1;
    cond            : Boolean;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           for i:=1 to n do
             begin
               df (i,n,x,dfatx);
               for j:=1 to n do
                 b[i,j]:=dfatx[j]
             end;
           for i:=1 to n do
             wi[i]:=i;
           cond:=true;
           k:=0;
           repeat
             k:=k+1;
             max:=abs(b[k,k]);
             ih:=k;
             for i:=k+1 to n do
               begin
                 m:=abs(b[i,k]);
                 if m>max
                   then begin
                          max:=m;
                          ih:=i
                        end
               end;
             if max=0
               then cond:=false
               else begin
                      if ih<>k
                        then begin
                               j:=wi[k];
                               wi[k]:=wi[ih];
                               wi[ih]:=j;
                               for j:=1 to n do
                                 begin
                                   m:=b[k,j];
                                   b[k,j]:=b[ih,j];
                                   b[ih,j]:=m
                                 end
                             end;
                      for i:=k+1 to n do
                        begin
                          m:=b[i,k]/b[k,k];
                          b[i,k]:=m;
                          for j:=k+1 to n do
                            b[i,j]:=b[i,j]-m*b[k,j]
                        end
                    end
           until (k=n-1) or not cond;
           if not cond or (b[n,n]=0)
             then st:=2
             else begin
                    st:=0;
                    for j:=1 to n-1 do
                      begin
                        a[j+1,j]:=-b[j+1,j];
                        for i:=j+2 to n do
                          begin
                            m:=-b[i,j];
                            for k:=j+1 to i-1 do
                              m:=m-b[i,k]*a[k,j];
                            a[i,j]:=m
                          end
                      end;
                    for j:=1 to n do
                      begin
                        a[j,j]:=1/b[j,j];
                        for i:=j-1 downto 1 do
                          begin
                            m:=0;
                            for k:=i+1 to j do
                              m:=m-b[i,k]*a[k,j];
                            a[i,j]:=m/b[i,i]
                          end
                      end;
                    for i:=1 to n do
                      for j:=1 to n do
                        if i>j
                          then begin
                                 m:=0;
                                 for k:=i to n do
                                   m:=m+a[i,k]*a[k,j];
                                 b[i,j]:=m
                               end
                          else begin
                                 m:=a[i,j];
                                 for k:=j+1 to n do
                                   m:=m+a[i,k]*a[k,j];
                                 b[i,j]:=m
                               end;
                    for k:=1 to n do
                      begin
                        j:=wi[k];
                        if k=j
                          then for i:=1 to n do
                                 a[i,k]:=b[i,k]
                          else for i:=1 to n do
                                 a[i,j]:=b[i,k]
                      end
                  end
         end;
  if st=0
    then begin
           for i:=1 to n do
             v[i]:=f(i,n,x);
           mtrxvctr (n,a,v,s);
           for i:=1 to n do
             begin
               s[i]:=-s[i];
               x[i]:=x[i]+s[i]
             end;
           it:=0;
           st:=3;
           repeat
             w:=v;
             for i:=1 to n do
               begin
                 v[i]:=f(i,n,x);
                 y[i]:=v[i]-w[i]
               end;
             mtrxvctr (n,a,y,z);
             for i:=1 to n do
               z[i]:=-z[i];
             p:=0;
             for i:=1 to n do
               p:=p-s[i]*z[i];
             for i:=1 to n do
               begin
                 sz:=s[i]+z[i];
                 for j:=1 to n do
                   c[i,j]:=sz*s[j];
                 c[i,i]:=c[i,i]+p
               end;
             b:=a;
             for i:=1 to n do
               for j:=1 to n do
                 begin
                   sz:=0;
                   for k:=1 to n do
                     sz:=sz+c[i,k]*b[k,j];
                   a[i,j]:=sz/p
                 end;
             mtrxvctr (n,a,v,s);
             for i:=1 to n do
               begin
                 s[i]:=-s[i];
                 x[i]:=x[i]+s[i]
               end;
             sz:=0;
             for i:=1 to n do
               sz:=sz+Sqr(s[i]);
             if Sqrt(sz)<tol
               then st:=0
               else it:=it+1
           until (it>mit) or (st=0)
         end
end;