function Simpsondouble (a,b    : Extended;
                        c,d    : fx;
                        f      : fxy;
                        n, m   : Integer;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Simpsondouble finds an approximate value of the double      }
{  integral from an integrand f(x,y) in a region R = [(x,y) : a<=x<=b,      }
{  c(x)<=y<=d(x)] by Simpson's method.                                      }
{  Data:                                                                    }
{    a,b - the ends of the integration interval with respect to x,          }
{    c,d - the functions which bound the values of y,                       }
{    f   - a Turbo Pascal function which for the given x and y calculates   }
{          the value of integrand f(x,y),                                   }
{    n,m - positive integers which determine the step sizes for x and y     }
{          (the step size for x is equal to (b-a)/(2n)), while the step     }
{          size for y varies with x and is equal to (d(x)-c(x))/(2m)).      }
{  Result:                                                                  }
{    Simpsondouble(a,b,c,d,f,n,m,st) - approximate value of the integral.   }
{  Other parameters:                                                        }
{    st - a variable which within the function Simpsondouble is assigned    }
{         the value of:                                                     }
{           1, if n<1 or m<1,                                               }
{           0, otherwise.                                                   }
{         Note: If st=1, then Simpsondouble(a,b,c,d,f,n,m,st) is not        }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    fx  - a procedural-type identifier defined as follows                  }
{             type fx = function (x : Extended) : Extended;                 }
{    fxy - a procedural-type identifier defined as follows                  }
{             type fxy = function (x,y : Extended) : Extended;              }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j              : Integer;
    h,hx,j1,j2,j3,
    k1,k2,k3,l,x,y,z : Extended;
begin
  if (n<1) or (m<1)
    then st:=1
    else begin
           st:=0;
           h:=(b-a)/(2*n);
           j1:=0;
           j2:=0;
           j3:=0;
           for i:=0 to 2*n do
             begin
               x:=a+i*h;
               hx:=(d(x)-c(x))/(2*m);
               k1:=f(x,c(x))+f(x,d(x));
               k2:=0;
               k3:=0;
               for j:=1 to 2*m-1 do
                 begin
                   y:=c(x)+j*hx;
                   z:=f(x,y);
                   if Odd(j)
                     then k3:=k3+z
                     else k2:=k2+z
                 end;
               l:=(k1+2*k2+4*k3)*hx/3;
               if (i=0) or (i=2*n)
                 then j1:=j1+l
                 else if Odd(i)
                        then j3:=j3+l
                        else j2:=j2+l
             end;
           Simpsondouble:=(j1+2*j2+4*j3)*h/3
         end
end;