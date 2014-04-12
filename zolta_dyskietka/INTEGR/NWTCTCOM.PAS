function NewtonCotescomp (a,b       : Extended;
                          f         : fx;
                          m,n       : Integer;
                          nrho      : LongInt;
                          var alpha : vector;
                          var st    : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function NewtonCotescomp calculates an approximate value of the      }
{  integral from a function f(x) in a finite interval [a,b] by the          }
{  composite Newton-Cotes quadrature formula.                               }
{  Data:                                                                    }
{    a,b   - the ends of the integration interval,                          }
{    f     - a Turbo Pascal function which for the given x calculates the   }
{            value of integrand f(x),                                       }
{    m     - number of subintervals of [a,b],                               }
{    n     - number of subintervals in each interval [a+ih,a+(i+1)h]        }
{            (i=0,1,...,m-1),                                               }
{    nrho  - a normalizing coefficient of the quadrature,                   }
{    alpha - an array of coefficients (the element alpha[k] should contain  }
{            the value of k-th coefficient, where k=0,1,...,n div 2).       }
{  Result:                                                                  }
{    NewtonCotescomp(a,b,f,n,nrho,alpha,st) - approximate value of the      }
{                                             integral.                     }
{  Other parameters:                                                        }
{    st - a variable which within the function NewtonCotescomp is assigned  }
{         the value of:                                                     }
{           1, if m<1 or n<1,                                               }
{           0, otherwise.                                                   }
{         Note: If st=1, then NewtonCotescomp(a,b,f,n,m,nrho,alpha,st) is   }
{               not calculated.                                             }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of integer array [q0..qn2], where q0<=0 and }
{             qn2>=n div 2,                                                 }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k,l : Integer;
    h,s   : Extended;
begin
  if (m>0) and (m>0)
    then begin
           st:=0;
           h:=(b-a)/m;
           s:=0;
           l:=n div 2;
           for i:=0 to m-1 do
             begin
               for k:=0 to l do
                 s:=s+alpha[k]*f(a+(i+k/n)*h);
               for k:=l+1 to n do
                 s:=s+alpha[n-k]*f(a+(i+k/n)*h)
             end;
           NewtonCotescomp:=h*s/nrho
         end
    else st:=1
end;