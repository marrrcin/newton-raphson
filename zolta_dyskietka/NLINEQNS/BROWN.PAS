procedure Brown (n         : Integer;
                 var x     : vector;
                 f         : fx;
                 mit       : Integer;
                 eps,zero  : Extended;
                 var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Brown solves a system of n nonlinear equations of the form }
{  f[i](x[1],x[2],...,x[n])=0 (i=1,2,...,n) by Brown's variant of Newton's  }
{  method.                                                                  }
{  Data:                                                                    }
{    n   - number of equations,                                             }
{    x   - an array the elements x[i] (i=1,2,...,n ) of which contain       }
{          initial approximations to n components of the solution (changed  }
{          on exit),                                                        }
{    f   - a Turbo Pascal function which calculates the value of function   }
{          f[i],                                                            }
{    mit - maximum number of iterations in the method,                      }
{    eps - absolute accuracy of the solution.                               }
{  Results:                                                                 }
{    x  - an array containing the solution,                                 }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    zero - a positive value below which the determinant of a Jacobian-     }
{           -related matrix, arising during the calculations, will be set   }
{           as 0 (this protects the procedure against the division by       }
{           zero),                                                          }
{    st   - a variable which within the procedure Brown is assigned the     }
{           value of:                                                       }
{             1, if n<1 or mit<1,                                           }
{             2, if a Jacobian-related matrix, which arises during the      }
{                application of Brown's method, is singular or almost       }
{                singular,                                                  }
{             3, if the number of iterations is greater than mit,           }
{             0, otherwise.                                                 }
{           Note: If st=1, then x is not changed on exit and the value of   }
{                 it is not calculated. If st=2 or st=3, then the array x   }
{                 contains the last approximation to the solution.          }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of integer array [q1..qn], where q1<=1 and }
{              qn>=n,                                                       }
{    matrix  - a type identifier of extended array [q1..qn,q1..qn1], where  }
{              q1<=1, qn>=n and qn1>=n+1,                                   }
{    matrix1 - a type identifier of integer array [q1..qn,q1..qn], where    }
{              q1<=1 and qn>=n,                                             }
{    fx      - a procedural-type identifier defined as follows              }
{                type fx = function (i,n : Integer;                         }
{                                    x   : vector) : Extended;              }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var conv,i,ith,j,js,k,kmax,k1,n1,ty    : Integer;
    dermax,fact,fh,h,hold,pi,pk,s,test : Extended;
    cond,kgt1,z                        : Boolean;
    is                                 : vector1;
    p                                  : matrix1;
    part,t                             : vector;
    c                                  : matrix;
procedure backsubst (k : Integer);
var j,kh,kh1 : Integer;
begin
  for kh:=k downto 2 do
    begin
      kh1:=kh-1;
      s:=0;
      for j:=kh to n do
        begin
          js:=p[kh,j];
          s:=s+c[kh1,js]*x[js]
        end;
      x[is[kh1]]:=s+c[kh1,n1]
    end
end {backsubst};
begin
  if (n<1) or (mit<1) or (zero<=0)
    then st:=1
    else begin
           st:=3;
           n1:=n+1;
           conv:=1;
           it:=1;
           while (it<=mit) and (st=3) do
             begin
               for j:=1 to n do
                 p[1,j]:=j;
               kgt1:=false;
               for k:=1 to n do
                 begin
                   if kgt1
                     then backsubst(k);
                   fh:=f(k,n,x);
                   fact:=0.001;
                   repeat
                     ty:=0;
                     for i:=k to n do
                       begin
                         ith:=p[k,i];
                         hold:=x[ith];
                         h:=fact*hold;
                         if abs(h)<zero
                           then h:=0.001;
                         x[ith]:=hold+h;
                         if kgt1
                           then backsubst(k);
                         pi:=(f(k,n,x)-fh)/h;
                         part[ith]:=pi;
                         x[ith]:=hold;
                         z:=true;
                         if abs(pi)>zero
                           then z:=abs(fh/pi)>1/zero;
                         if z
                           then ty:=ty+1
                       end;
                     if ty<=n-k
                       then begin
                              cond:=true;
                              if k<n
                                then begin
                                       kmax:=p[k,k];
                                       dermax:=abs(part[kmax]);
                                       k1:=k+1;
                                       for i:=k1 to n do
                                         begin
                                           js:=p[k,i];
                                           test:=abs(part[js]);
                                           if test<dermax
                                             then p[k1,i]:=js
                                             else begin
                                                    dermax:=test;
                                                    p[k1,i]:=kmax;
                                                    kmax:=js
                                                  end
                                         end;
                                       pk:=part[kmax];
                                       if abs(pk)<zero
                                         then st:=2
                                         else begin
                                                pk:=1/pk;
                                                is[k]:=kmax;
                                                s:=0;
                                                for j:=k1 to n do
                                                  begin
                                                    js:=p[k1,j];
                                                    pi:=part[js];
                                                    c[k,js]:=-pi*pk;
                                                    s:=s+pi*x[js]
                                                  end;
                                                c[k,n1]:=s
                                              end
                                     end
                                else begin
                                       c[k,n1]:=0;
                                       kmax:=ith
                                     end;
                              if cond
                                then c[k,n1]:=x[kmax]+(c[k,n1]-fh)/part[kmax]
                            end
                       else begin
                              fact:=10*fact;
                              if fact>0.5
                                then st:=2
                            end
                   until (st=2) or cond;
                   kgt1:=true
                 end;
               if st=3
                 then begin
                        x[kmax]:=c[n,n1];
                        if n>1
                          then backsubst (n);
                        if it>1
                          then begin
                                 i:=0;
                                 cond:=true;
                                 repeat
                                   i:=i+1;
                                   if abs(t[i]-x[i])>=eps
                                     then cond:=false
                                 until (i=n) or not cond;
                                 if cond
                                   then begin
                                          conv:=conv+1;
                                          if conv>=3
                                            then st:=0
                                        end
                                   else begin
                                          conv:=1;
                                          for i:=1 to n do
                                            t[i]:=x[i]
                                        end
                               end
                      end;
               it:=it+1
             end;
           if st=3
             then it:=it-1
         end
end;