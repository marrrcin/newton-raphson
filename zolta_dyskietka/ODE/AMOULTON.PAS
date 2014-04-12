procedure AdamsMoulton (var x0    : Extended;
                        k         : Integer;
                        h         : Extended;
                        var y     : vector;
                        f,df      : fxy;
                        beta      : vector1;
                        rho,eps   : Extended;
                        mit       : Integer;
                        iny       : Boolean;
                        var yk    : Extended;
                        var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure AdamsMoulton calculates an approximate value y(x0+kh) of   }
{  the solution of the single differential equation y'=f(x,y) with the      }
{  initial condition y(x0)=y0 by the Adams-Moulton method.                  }
{  Data:                                                                    }
{    x0   - the argument occuring at the initial condition (changed on      }
{           exit),                                                          }
{    k    - number of steps of the method,                                  }
{    h    - step size,                                                      }
{    y    - an array which contains the solutions at the points x0, x0+h,   }
{           x0+2h, ..., x0+(k-1)h (changed on exit),                        }
{    f    - a Turbo Pascal function which calculates the value of the       }
{           function f(x,y) occurring in the differential equation,         }
{    df   - a Turbo Pascal function which calculates df(x,y)/dy for the     }
{           function f(x,y) occurring in the differential equation,         }
{    beta - an array of coefficients of the k-step method,                  }
{    rho  - a normalizing coefficient of the k-step method,                 }
{    eps  - relative accuracy in the iterative process,                     }
{    mit  - maximum admissible number of iterations.                        }
{  Results:                                                                 }
{    x0 - the given value x0 plus h,                                        }
{    y  - an array containing the solutions at the points x0+h, x0+2h, ..., }
{         x0+kh (the element y[k-1] contains the solution calculated in the }
{         procedure),                                                       }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    iny - a Boolean variable which should be assigned the value of true,   }
{          if in the iterative process the given value y[k-1] should be     }
{          taken as the initial approximation to the solution at x0+kh, and }
{          the value of false otherwise,                                    }
{    yk  - an initial approximation to the solution at x0+kh (only if       }
{          iny=false; changed on exit),                                     }
{    st  - a variable which within the procedure AdamsMoulton is assigned   }
{          the value of:                                                    }
{            1, if k<1 or mit<1,                                            }
{            2, if in the iterative process the desired accuracy is not     }
{               achieved in mit iteration steps,                            }
{            0, otherwise.                                                  }
{          Note: If st<>0, then the elements of y are not changed on exit.  }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qk1], where q0<=0   }
{              and qk1>=k-1,                                                }
{    vector1 - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k,                                                   }
{    fxy     - a procedural-type identifier defined as follows              }
{                type fxy = function (x,y : Extended) : Extended;           }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k1,l          : Integer;
    hb,yk1,xk,v,w,z : Extended;
    cond            : Boolean;
begin
  k1:=k-1;
  if (k1<0) or (mit<1)
    then st:=1
    else begin
           st:=0;
           z:=0;
           if iny
             then yk:=y[k1];
           for i:=0 to k1 do
             begin
               l:=k1-i;
               z:=z+beta[i+1]*f(x0+l*h,y[l])
             end;
           z:=y[k1]+h*z/rho;
           hb:=h*beta[0]/rho;
           xk:=x0+k*h;
           it:=0;
           w:=abs(yk);
           repeat
             yk1:=yk-(yk-z-hb*f(xk,yk))/(1-hb*df(xk,yk));
             v:=abs(yk1);
             if v<w
               then v:=w;
             if v<>0
               then cond:=(abs(yk1-yk)/v<eps)
               else cond:=true;
             yk:=yk1;
             w:=abs(yk);
             it:=it+1
           until (it=mit) or cond;
           if it=mit
             then st:=2
             else begin
                    x0:=x0+h;
                    for i:=0 to k1-1 do
                      y[i]:=y[i+1];
                    y[k1]:=yk1
                  end
         end
end;