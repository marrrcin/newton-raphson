function GaussChebyshev (f      : fx;
                         n      : Integer;
                         var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GaussChebyshev calculates an approximate value of the       }
{  integral from f(x)(1-x^2)^(-1/2) in the interval [-1,1] by the Gauss-    }
{  -Chebyshev quadrature formula.                                           }
{  Data:                                                                    }
{    f - a Turbo Pascal function which for the given x calculates the value }
{        of f(x) occurring in the integrand,                                }
{    n - number of nodes minus 1 (the nodes are numbered from 0 to n).      }
{  Result:                                                                  }
{    GaussChebyshev(f,n,st) - approximate value of the integral.            }
{  Other parameters:                                                        }
{    st - a variable which within the function GaussChebyshev is assigned   }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then GaussChebyshev(f,n,st) is not calculated.     }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k   : Integer;
    p,s : Extended;
begin
  if n>=0
    then begin
           st:=0;
           p:=Pi/(2*n+2);
           s:=0;
           for k:=0 to n do
             s:=s+f(cos((2*k+1)*p));
           GaussChebyshev:=Pi*s/(n+1)
         end
    else st:=1
end;