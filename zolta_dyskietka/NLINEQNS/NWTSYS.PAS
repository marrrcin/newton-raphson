procedure Newtonsystem (n         : Integer;
                        var x     : vector;
                        f         : fx;
                        df        : dfx;
                        mit       : Integer;
                        eps       : Extended;
                        var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Newtonsystem solves a system of n nonlinear equations of   }
{  the form f[i](x[1],x[2],...,x[n])=0 (i=1,2,...,n) by Newton's method.    }
{  Data:                                                                    }
{    n   - number of equations,                                             }
{    x   - an array the elements x[i] (i=1,2,...,n ) of which contain       }
{          initial approximations to n components of the solution (changed  }
{          on exit),                                                        }
{    f   - a Turbo Pascal function which calculates the value of function   }
{          f[i],                                                            }
{    df  - a Turbo Pascal procedure which calculates the values of          }
{          derivatives df[i]/dx[j] (j=1,2,...,n),                           }
{    mit - maximum number of iterations in Newton's method,                 }
{    eps - relative accuracy of the solution.                               }
{  Results:                                                                 }
{    x  - an array containing the solution,                                 }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Newtonsystem is assigned    }
{         the value of:                                                     }
{           1, if n<1 or mit<1,                                             }
{           2, if the matrix of linear system, which arises during the      }
{              application of Newton's method, is singular,                 }
{           3, if the number of iterations is greater than mit,             }
{           0, otherwise.                                                   }
{         Note: If st=1, then x is not changed on exit and the value of it  }
{               is not calculated. If st=2 or st=3, then the array x        }
{               contains the last approximation to the solution.            }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n+1,                                                }
{    vector2 - a type identifier of integer array [q1..qn1], where q1<=1    }
{              and qn1>=n+1,                                                }
{    vector3 - a type identifier of extended array [q1..qn2], where q1<=1   }
{              and qn2>=(n+2)(n+2)/4,                                       }
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
var i,j,jh,k,kh,l,lh,n1,p,q,rh : Integer;
    max,s                      : Extended;
    cond                       : Boolean;
    dfatx                      : vector;
    a,b                        : vector1;
    r                          : vector2;
    x1                         : vector3;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           it:=0;
           n1:=n+1;
           repeat
             it:=it+1;
             if it>mit
               then begin
                      st:=3;
                      it:=it-1
                    end
               else begin
                      p:=n1;
                      for i:=1 to n1 do
                        r[i]:=0;
                      k:=0;
                      repeat
                        k:=k+1;
                        df (k,n,x,dfatx);
                        for i:=1 to n do
                          a[i]:=dfatx[i];
                        s:=-f(k,n,x);
                        for i:=1 to n do
                          s:=s+dfatx[i]*x[i];
                        a[n1]:=s;
                        for i:=1 to n do
                          begin
                            rh:=r[i];
                            if rh<>0
                              then b[rh]:=a[i]
                          end;
                        kh:=k-1;
                        l:=0;
                        max:=0;
                        for j:=1 to n1 do
                          if r[j]=0
                            then begin
                                   s:=a[j];
                                   l:=l+1;
                                   q:=l;
                                   for i:=1 to kh do
                                     begin
                                       s:=s-b[i]*x1[q];
                                       q:=q+p
                                     end;
                                   a[l]:=s;
                                   s:=abs(s);
                                   if (j<n1) and (s>max)
                                     then begin
                                            max:=s;
                                            jh:=j;
                                            lh:=l
                                          end
                                 end;
                        if max=0
                          then st:=2
                          else begin
                                 max:=1/a[lh];
                                 r[jh]:=k;
                                 for i:=1 to p do
                                   a[i]:=max*a[i];
                                 jh:=0;
                                 q:=0;
                                 for j:=1 to kh do
                                   begin
                                     s:=x1[q+lh];
                                     for i:=1 to p do
                                     if i<>lh
                                       then begin
                                              jh:=jh+1;
                                              x1[jh]:=x1[q+i]-s*a[i]
                                            end;
                                     q:=q+p
                                   end;
                                 for i:=1 to p do
                                   if i<>lh
                                     then begin
                                            jh:=jh+1;
                                            x1[jh]:=a[i]
                                          end;
                                 p:=p-1
                               end
                      until (k=n) or (st=2);
                      if st=0
                        then begin
                               for k:=1 to n do
                                 begin
                                   rh:=r[k];
                                   if rh<>k
                                     then begin
                                            s:=x1[k];
                                            x1[k]:=x1[rh];
                                            i:=r[rh];
                                            while i<>k do
                                              begin
                                                x1[rh]:=x1[i];
                                                r[rh]:=rh;
                                                rh:=i;
                                                i:=r[rh]
                                              end;
                                            x1[rh]:=s;
                                            r[rh]:=rh
                                          end
                                 end;
                               cond:=true;
                               i:=0;
                               repeat
                                 i:=i+1;
                                 max:=abs(x[i]);
                                 s:=abs(x1[i]);
                                 if max<s
                                   then max:=s;
                                 if max<>0
                                   then if abs(x[i]-x1[i])/max>=eps
                                          then cond:=false
                               until (i=n) or not cond;
                               for i:=1 to n do
                                 x[i]:=x1[i]
                             end
                    end
           until (st<>0) or cond
         end
end;