function Simpsonsimple (a,b    : Extended;
                        f      : fx;
                        eps    : Extended;
                        n      : Integer;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Simpsonsimple finds an approximate value of the integral    }
{  from a simple integrand f(x) in a finite interval [a,b] by Simpson's     }
{  method.                                                                  }
{  Data:                                                                    }
{    a,b - the ends of the integration interval,                            }
{    f   - a Turbo Pascal function which for the given x calculates the     }
{          value of integrand f(x).                                         }
{    eps - relative error for calculating the integral,                     }
{    n   - a positive integer which limits the calculations (the            }
{          calculations are finished if the length of subintervals,         }
{          evaluated in the method, are less than (b-a)/3^n).               }
{          Notes: 1) The condition 1<=n<=9 should be fulfilled.             }
{                 2) If the relative error is not achieved and the length   }
{                    of subintervals are less than (b-a)/3^n, the function  }
{                    Simpsonsimple yields the last approximation found.     }
{  Result:                                                                  }
{    Simpsonsimple(a,b,f,eps,n,st) - approximate value of the integral.     }
{  Other parameters:                                                        }
{    st - a variable which within the function Simpsonsimple is assigned    }
{         the value of:                                                     }
{           1, if the condition 1<=n<=9 is not fulfilled,                   }
{           0, otherwise.                                                   }
{         Note: If st=1, then Simpsonsimple(a,b,f,eps,n,st) is not          }
{               calculated.                                                 }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k,k1,lev             : Integer;
    dx,sum,sum1,x0,x1,x2 : Extended;
begin
  if (n>=1) and (n<=9)
    then begin
           st:=0;
           dx:=b-a;
           sum:=0;
           lev:=0;
           k1:=1;
           repeat
             lev:=lev+1;
             sum1:=sum;
             dx:=dx/3;
             x0:=a;
             sum:=0;
             for k:=1 to k1 do
               begin
                 x1:=x0+dx;
                 x2:=x1+dx;
                 x0:=f(x0)+4*f(x0+0.5*dx)+2*f(x1)+4*f(x1+0.5*dx);
                 x1:=+2*f(x2)+4*f(x2+0.5*dx)+f(x2+dx);
                 sum:=sum+dx*(x0+x1)/6;
                 x0:=x2+dx
               end;
             k1:=3*k1
           until (lev>1) and (abs(sum-sum1)<=eps*sum) or (lev=n);
           Simpsonsimple:=sum
         end
    else st:=1
end;