procedure AdamsBashforth (var x0 : Extended;
                          k      : Integer;
                          h      : Extended;
                          var y  : vector;
                          f      : fxy;
                          beta   : vector;
                          rho    : Extended;
                          var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure AdamsBashforth calculates an approximate value y(x0+kh) of }
{  the solution of the single differential equation y'=f(x,y) with the      }
{  initial condition y(x0)=y0 by the Adams-Bashforth method.                }
{  Data:                                                                    }
{    x0   - the argument occurring at the initial condition (changed on     }
{           exit),                                                          }
{    k    - number of steps of the method,                                  }
{    h    - step size,                                                      }
{    y    - an array which contains the solutions at the points x0, x0+h,   }
{           x0+2h, ..., x0+(k-1)h (changed on exit),                        }
{    f    - a Turbo Pascal function which calculates the value of the       }
{           function f(x,y) occurring in the differential equation,         }
{    beta - an array of coefficients of the k-step method,                  }
{    rho  - a normalizing coefficient of the k-step method.                 }
{  Results:                                                                 }
{    x0 - the given value x0 plus h,                                        }
{    y  - an array containing the solutions at the points x0+h, x0+2h, ..., }
{         x0+kh (the element y[k-1] contains the solution calculated in the }
{         procedure).                                                       }
{  Other parameters:                                                        }
{    st - a variable which within the procedure AdamsBashforth is assigned  }
{         the value of:                                                     }
{           1, if k<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of y are not changed on exit.    }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qk1], where q0<=0    }
{             and qk1>=k-1,                                                 }
{    fxy    - a procedural-type identifier defined as follows               }
{               type fxy = function (x,y : Extended) : Extended;            }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k1,l : Integer;
    z      : Extended;
begin
  k1:=k-1;
  if k1<0
    then st:=1
    else begin
           st:=0;
           z:=0;
           for i:=0 to k1 do
             begin
               l:=k1-i;
               z:=z+beta[i]*f(x0+l*h,y[l])
             end;
           z:=y[k1]+h*z/rho;
           x0:=x0+h;
           for i:=0 to k1-1 do
             y[i]:=y[i+1];
           y[k1]:=z
         end
end;