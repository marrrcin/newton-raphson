procedure Chebyshev (n          : Integer;
                     a          : matrix;
                     b          : vector;
                     s          : Integer;
                     alpha,beta : Extended;
                     mit        : Integer;
                     eps        : Extended;
                     var x      : vector;
                     var it,st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Chebyshev solves a system of linear equations by           }
{  Chebyshev's method.                                                      }
{  Data:                                                                    }
{    n     - number of equations = number of unknowns,                      }
{    a     - a two-dimensional array containing elements of the matrix of   }
{            the system,                                                    }
{    b     - a one-dimensional array containing free terms of the system,   }
{    s     - maximum degree of Chebyshev's polynomial used in the method,   }
{    alpha - the beginning of the interval which contains all eigenvalues   }
{            of the matrix of the system,                                   }
{    beta  - the end of the interval which contains all eigenvalues of the  }
{            matrix of the system,                                          }
{    mit   - maximum number of iterations in the method,                    }
{    eps   - absolute accuracy of the solution,                             }
{    x     - an array containing an initial approximation to the solution   }
{            (changed on exit).                                             }
{  Results:                                                                 }
{    x  - an array containing the solution,                                 }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Chebyshev is assigned the   }
{         value of:                                                         }
{           1, n<1 or alpha<=0 or beta<=alpha,                              }
{           2, if the number of iterations is greater than mit,             }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array x are not changed on    }
{               exit, and if st=2, then x contains the last approximation   }
{               to the solution.                                            }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k               : Integer;
    c,l,omh,om1,om2,sum : Extended;
    x1,x2               : vector;
begin
  st:=1;
  if (n>=1) and (alpha>0) and (beta>alpha)
    then begin
           omh:=(beta-alpha)/(beta+alpha);
           c:=2/(beta+alpha);
           l:=2/omh;
           for i:=1 to n do
             begin
               x2[i]:=x[i];
               x1[i]:=0
             end;
           it:=0;
           repeat
             it:=it+1;
             if it>mit
               then begin
                      st:=2;
                      it:=it-1
                    end
               else begin
                      k:=0;
                      om1:=0;
                      om2:=omh;
                      repeat
                        for i:=1 to n do
                          begin
                            sum:=0;
                            for j:=1 to n do
                              sum:=sum+a[i,j]*x2[j];
                            x1[i]:=x2[i]+om1*om2*(x2[i]-x1[i])-c*(1+om1*om2)
                                   *(sum-b[i])
                          end;
                        om1:=om2;
                        om2:=1/(l-om2);
                        k:=k+1;
                        if k<s
                          then for i:=1 to n do
                                 begin
                                   sum:=x2[i];
                                   x2[i]:=x1[i];
                                   x1[i]:=sum
                                 end
                      until k=s;
                      sum:=abs(x[1]-x1[1]);
                      for i:=2 to n do
                        begin
                          om1:=abs(x[i]-x1[i]);
                          if om1>sum
                            then sum:=om1
                        end;
                      if sum<=eps
                        then begin
                               st:=0;
                               for i:=1 to n do
                                 x[i]:=x1[i]
                             end
                        else for i:=1 to n do
                               begin
                                 x[i]:=x1[i];
                                 x1[i]:=x2[i];
                                 x2[i]:=x[i]
                               end
                    end
                  until st<>1
         end
end;