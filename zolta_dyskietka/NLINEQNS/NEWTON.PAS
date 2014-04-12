function Newton (var x     : Extended;
                 f,df      : fx;
                 mit       : Integer;
                 eps       : Extended;
                 var fatx  : Extended;
                 var it,st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Newton finds an approximate value of the root of the        }
{  equation f(x)=0 by Newton's method.                                      }
{  Data:                                                                    }
{    x   - initial approximation to the root (changed on exit),             }
{    f   - a Turbo Pascal function which for the given x evaluates f(x),    }
{    df  - a Turbo Pascal function which for the given x evaluates          }
{          df(x)/dx,                                                        }
{    mit - maximum number of iterations in Newton's method,                 }
{    eps - relative accuracy of the solution.                               }
{  Results:                                                                 }
{    Newton(x,f,df,mit,eps,fatx,it,st) - approximate value of the root,     }
{    fatx                              - the value of the function f(x) at  }
{                                        the approximate root,              }
{    it                                - number of iterations.              }
{  Other parameters:                                                        }
{    st - a variable which within the function Newton is assigned the value }
{         of:                                                               }
{           1, if mit<1,                                                    }
{           2, if during the calculations df(x)/dx=0 at a point x,          }
{           3, if the given accuracy eps is not achieved in mit iteration   }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then Newton(x,f,df,mit,eps,fatx,st)        }
{               is not calculated, and if st=3, then                        }
{               Newton(x,f,df,mit,eps,fatx,st) yields the last              }
{               approximation to the root.                                  }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var dfatx,v,w,xh : Extended;
begin
  if mit<1
    then st:=1
    else begin
           st:=3;
           it:=0;
           repeat
             it:=it+1;
             dfatx:=df(x);
             if dfatx=0
               then st:=2
               else begin
                      xh:=x;
                      w:=abs(xh);
                      x:=x-f(x)/dfatx;
                      v:=abs(x);
                      if v<w
                        then v:=w;
                      if v=0
                        then st:=0
                        else if abs(x-xh)/v<=eps
                               then st:=0
                    end
           until (it=mit) or (st<>3)
         end;
  if (st=0) or (st=3)
    then begin
           Newton:=x;
           fatx:=f(x)
         end
end;