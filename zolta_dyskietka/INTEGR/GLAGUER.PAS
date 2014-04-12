function GaussLaguerre (f      : fx;
                        n      : Integer;
                        var x  : vector;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GaussLaguerre calculates an approximate value of the        }
{  integral from e^(-x)*f(x) in the interval [0,infinity) by the Gauss-     }
{  -Laguerre quadrature formula.                                            }
{  Data:                                                                    }
{    f - a Turbo Pascal function which for the given x calculates the value }
{        of f(x) occurring in the integrand,                                }
{    n - number of nodes minus 1 (the nodes are numbered from 0 to n),      }
{    x - an array containing roots of the Laguerre polynomial of the degree }
{        n+1 (the element x[k] should contain the value of the k-th root;   }
{        k=0,1,...,n).                                                      }
{  Result:                                                                  }
{    GaussLaguerre(f,n,x,st) - approximate value of the integral.           }
{  Other parameters:                                                        }
{    st - a variable which within the function GaussLaguerre is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then GaussLaguerre(f,n,x,st) is not calculated.    }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with the far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k,m              : Integer;
    ar,l0,l1,l2,s,x1 : Extended;
begin
  if n>0
    then begin
           st:=0;
           s:=0;
           ar:=1;
           for k:=0 to n do
             begin
               l0:=1;
               x1:=x[k];
               l1:=1-x1;
               for m:=1 to n-1 do
                 begin
                   l2:=(2*m+1-x1)*l1-m*m*l0;
                   l0:=l1;
                   l1:=l2
                 end;
               s:=s+x1*f(x1)/(l1*l1)
             end;
           for k:=2 to n do
             ar:=k*ar;
           GaussLaguerre:=ar*ar*s/((n+1)*(n+1))
         end
    else st:=1
end;