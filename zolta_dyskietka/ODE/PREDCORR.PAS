procedure Adamspredcorr (x0, xn, y0 : Extended;
                         n          : Integer;
                         f          : fxy;
                         var y      : vector;
                         var st     : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Adamspredcorr calculates approximate values y(x0+kh),      }
{  where k=0,1,...,n and h=(xn-x0)/n, of the solution of the single         }
{  differential equation y'=f(x,y) with the initial condition y(x0)=y0 by   }
{  the fourth order predictor-corrector method.                             }
{  Data:                                                                    }
{    x0, xn - the endpoints of the integration interval,                    }
{    y0     - the value of y at the initial point x0,                       }
{    n      - number of points at which the approximate solution should be  }
{             found,                                                        }
{    f      - a Turbo Pascal function which calculates the value of the     }
{             function f(x,y) occurring in the differential equation.       }
{  Result:                                                                  }
{    y - an array containing the solution at the points x0, x0+h, ...,      }
{        x0+nh=xn (the element y[k] contains the solution at x0+kh for      }
{        k=0,1,...,n; y[0]=y0, where y0 is given).                          }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Adamspredcorr is assigned   }
{         the value of:                                                     }
{           1, if n<4,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of y are not changed on exit.    }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qn], where q0<=0     }
{             and qn>=n,                                                    }
{    fxy    - a procedural-type identifier defined as follows               }
{               type fxy = function (x,y : Extended) : Extended;            }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i                  : Integer;
    h,k1,k2,k3,k4,x,yi : Extended;
begin
  if n<4
    then st:=1
    else begin
           h:=(xn-x0)/n;
           y[0]:=y0;
           for i:=1 to 3 do
             begin
               x:=x0+(i-1)*h;
               yi:=y[i-1];
               k1:=h*f(x,yi);
               k2:=h*f(x+h/2,yi+k1/2);
               k3:=h*f(x+h/2,yi+k2/2);
               k4:=h*f(x+h,yi+k3);
               y[i]:=yi+(k1+2*k2+2*k3+k4)/6
             end;
           for i:=4 to n do
             begin
               x:=x0+i*h;
               k1:=f(x-h,y[i-1]);
               k2:=f(x-2*h,y[i-2]);
               k3:=f(x-3*h,y[i-3]);
               yi:=y[i-1]+h*(55*k1-59*k2+37*k3-9*f(x-4*h,y[i-4]))/24;
               y[i]:=y[i-1]+h*(9*f(x,yi)+19*k1-5*k2+k3)/24
             end
         end
end;