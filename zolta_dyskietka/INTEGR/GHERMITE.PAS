function GaussHermite (f      : fx;
                       n      : Integer;
                       var x  : vector;
                       var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GaussHermite calculates an approximate value of the         }
{  integral from e^(-x*x)*f(x) in the interval (-infinity,+infinity) by the }
{  Gauss-Hermite quadrature formula.                                        }
{  Data:                                                                    }
{    f - a Turbo Pascal function which for the given x calculates the value }
{        of f(x) occurring in the integrand,                                }
{    n - number of nodes minus 1 (the nodes are numbered from 0 to n),      }
{    x - an array containing roots of the Hermite polynomial of the degree  }
{        n+1 (the element x[k] should contain the value of the k-th root;   }
{        k=0,1,...,n div 2).                                                }
{  Result:                                                                  }
{    GaussHermite(f,n,x,st) - approximate value of the integral.            }
{  Other parameters:                                                        }
{    st - a variable which within the function GaussHermite is assigned the }
{         value of:                                                         }
{           1, if n<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then GaussHermite(f,n,x,st) is not calculated.     }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qn2], where q0<=0    }
{             and qn2>=n div 2,                                             }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k,l,m            : Integer;
    ar,h0,h1,h2,s,x1 : Extended;
begin
  if n>0
    then begin
           st:=0;
           s:=0;
           ar:=2;
           l:=n div 2;
           for k:=0 to n do
             begin
               h0:=1;
               if k<=l
                 then x1:=x[k]
                 else x1:=-x[n-k];
               h1:=2*x1;
               for m:=1 to n-1 do
                 begin
                   h2:=2*(x1*h1-m*h0);
                   h0:=h1;
                   h1:=h2
                 end;
               s:=s+f(x1)/(h1*h1)
             end;
           for k:=2 to n do
             ar:=2*k*ar;
           GaussHermite:=ar*sqrt(pi)*s/(n+1)
         end
    else st:=1
end;