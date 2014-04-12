function GaussLegendre (f      : fx;
                        n      : Integer;
                        var x  : vector;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GaussLegendre calculates an approximate value of the        }
{  integral from a function f(x) in the interval [-1,1] by the Gauss-       }
{  -Legendre quadrature formula.                                            }
{  Data:                                                                    }
{    f - a Turbo Pascal function which for the given x calculates the value }
{        of integrand at x,                                                 }
{    n - number of nodes minus 1 (the nodes are numbered from 0 to n),      }
{    x - an array containing roots of the Legendre polynomial of the degree }
{        n+1 (the element x[k] should contain the value of the k-th root;   }
{        k=0,1,...,n div 2).                                                }
{  Result:                                                                  }
{    GaussLegendre(f,n,x,st) - approximate value of the integral.           }
{  Other parameters:                                                        }
{    st - a variable which within the function GaussLegendre is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then GaussLegendre(f,n,x,st) is not calculated.    }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn2], where q1<=1    }
{             and qn2>=n div 2,                                             }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended): Extended;                }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k,l,m         : Integer;
    p0,p1,p2,s,x1 : Extended;
begin
  if n>0
    then begin
           st:=0;
           s:=0;
           l:=n div 2;
           for k:=0 to n do
             begin
               p0:=1;
               if k<=l
                 then x1:=x[k]
                 else x1:=-x[n-k];
               p1:=x1;
               for m:=1 to n-1 do
                 begin
                   p2:=((2*m+1)*x1*p1-m*p0)/(m+1);
                   p0:=p1;
                   p1:=p2
                 end;
               s:=s-2*f(x1)*(x1*x1-1)/((n+1)*(n+1)*p1*p1)
             end;
           GaussLegendre:=s
         end
    else st:=1
end;