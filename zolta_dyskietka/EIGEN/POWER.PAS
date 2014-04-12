procedure powermethod (n        : Integer;
                       var a    : matrix;
                       var x1   : vector;
                       it       : Integer;
                       eps      : Extended;
                       var x    : vector;
                       var m    : Extended;
                       var st   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure power calculates a single eigenvalue and a corresponding   }
{  eigenvector for a given matrix and an initial approximation to the       }
{  eigenvector.                                                             }
{  Data:                                                                    }
{    n   - number of rows (columns) of the given matrix,                    }
{    a   - an array containing the values of elements of the given matrix,  }
{    x1  - an array containing initial approximations to the components of  }
{          eigenvector (it should be fulfilled the condition                }
{          max(abs(x1[i]))=1, where i=1,2,...,n),                           }
{    it  - maximum number of iterations for finding the eigenvector,        }
{    eps - absolute accuracy for calculating the eigenvector.               }
{  Results:                                                                 }
{    x - an array containing components of eigenvector,                     }
{    m - the eigenvalue corresponding to the eigenvector.                   }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure expmethod is assigned the }
{           value of:                                                       }
{             1, if n<1,                                                    }
{             2, if for the given initial approximation the condition       }
{                max(abs(x1[i]))=1 (i=1,2,...,n) is not fulfilled,          }
{             3, if in any step the norm of a vector v (calculated within   }
{                the procedure) is equal to zero,                           }
{             4, if the maximum number of iterations is achieved,           }
{             0, otherwise.                                                 }
{           Note: If st=1, 2 or 3, then m and the elements of array x are   }
{                 not calculated. If st=4, then x contains the last         }
{                 approximation to the eigenvector and m contains the last  }
{                 approximation to the corresponding eigenvalue.            }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k : Integer;
    m1,s  : Extended;
    cond  : Boolean;
    xp    : vector;
begin
  st:=0;
  if n<1
    then st:=1
    else begin
           m1:=0;
           for j:=1 to n do
             begin
               s:=abs(x1[j]);
               if s>m1
                 then m1:=s
             end;
           if m1<>1
             then st:=2
         end;
  if st=0
    then begin
           i:=0;
           for j:=1 to n do
             xp[j]:=x1[j];
           cond:=false;
           repeat
             m:=0;
             for j:=1 to n do
               begin
                 s:=0;
                 for k:=1 to n do
                   s:=s+a[j,k]*x1[k];
                 x[j]:=s;
                 m1:=abs(s);
                 if m1>m
                   then m:=m1
               end;
             if m=0
               then st:=3
               else begin
                      for j:=1 to n do
                        x[j]:=x[j]/m;
                      i:=i+1;
                      if i>it
                        then st:=4
                        else begin
                               if not odd(i)
                                 then begin
                                        s:=0;
                                        for j:=1 to n do
                                          begin
                                            m1:=abs(x[j]-xp[j]);
                                            if m1>s
                                              then s:=m1
                                          end;
                                        if s<=eps
                                          then cond:=true
                                          else for j:=1 to n do
                                                 xp[j]:=x[j]
                                      end;
                               if not cond
                                 then for j:=1 to n do
                                        x1[j]:=x[j]
                             end
                    end
           until (st<>0) or cond;
           if (st=0) or (st=4)
             then begin
                    s:=0;
                    for j:=1 to n do
                      begin
                        m1:=abs(x[j]-x1[j]);
                        if m1>s
                          then s:=m1
                      end;
                    if s>1
                      then m:=-m;
                    if odd(i)
                      then for j:=1 to n do
                             x[j]:=xp[j]
                  end
         end
end;