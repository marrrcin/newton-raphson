procedure Euler (var x0 : Extended;
                 x1     : Extended;
                 var y  : Extended;
                 f      : fxy;
                 mh,eps : Extended;
                 var h  : Extended;
                 var fl : Boolean;
                 var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Euler calculates an approximate value y(x1) of the         }
{  solution of the single differential equation y'=f(x,y) with the initial  }
{  condition y(x0)=y0 by modified Euler's method with an automatic step     }
{  size correction.                                                         }
{  Data:                                                                    }
{    x0  - the argument occurring at the initial condition (changed on      }
{          exit),                                                           }
{    x1  - the value of x for which the solution should be found (x1 must   }
{          be greater than x0),                                             }
{    y   - the value of y0 at the initial condition (changed on exit),      }
{    f   - a Turbo Pascal function which calculates the value of the        }
{          function f(x,y) occurring in the differential equation,          }
{    mh  - minimum admissible absolute value of step size,                  }
{    eps - accuracy of the solution.                                        }
{  Results:                                                                 }
{    x0 - the given value x1,                                               }
{    y  - an approximate value of the solution at the point x1.             }
{  Other parameters:                                                        }
{    h  - a step size used within the procedure (do not assign any value),  }
{    fl - a Boolean variable which should be assigned the value of true     }
{         before the first calling of the procedure, and which should not   }
{         be changed later,                                                 }
{    st - a variable which within the procedure Euler is assigned the value }
{         of:                                                               }
{           1, if x1<=x0,                                                   }
{           2, if for h<mh the given accuracy eps is not achieved,          }
{           0, otherwise.                                                   }
{         Note: If st=1, then y is not changed on exit, and if st=2, then y }
{               contains the last calculated solution, and x0 is the point  }
{               at which this solution has been found.                      }
{  Unlocal identifier:                                                      }
{    fxy - a procedural-type identifier defined as follows                  }
{            type fxy = function (x,y : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
const c=3.333333333333333333e-1;
var   h1,h2,g,g1,x,xh,y1,y2,yh : Extended;
      hend,tend                : Boolean;
begin
  st:=0;
  if fl
    then begin
           h:=x1-x0;
           fl:=false
         end;
  if h<=0
    then st:=1
    else begin
           tend:=true;
           hend:=true;
           x:=x0;
           repeat
             g:=h/2;
             g1:=g/2;
             yh:=y+g*f(x,y);
             xh:=x+g;
             y1:=y+h*f(xh,yh);
             yh:=y+g1*f(x,y);
             xh:=x+g1;
             y2:=y+g*f(xh,yh);
             xh:=x+g;
             yh:=y2+g1*f(xh,y2);
             y2:=y2+g*f(xh,yh);
             xh:=ln((1+c)*abs(y1-y2)/eps);
             h1:=h/exp(c*xh);
             if h1<=c*h
               then if 2*h1<mh
                      then begin
                             st:=2;
                             hend:=false;
                             y:=y2;
                             x:=x+h;
                             h2:=h
                           end
                      else h:=2*h1
               else if h1>=h
                      then if x+2*h<=x1
                             then h:=2*h
                             else begin
                                    h2:=h;
                                    h:=x1-x;
                                    x:=x+h;
                                    tend:=false
                                  end
                      else begin
                             y:=y2;
                             x:=x+h;
                             if x+2*h1<x1
                               then h:=2*h1
                               else begin
                                      h:=x1-x;
                                      x:=x+h;
                                      h2:=2*h1;
                                      if h2>x1-x0
                                        then h2:=x1-x0;
                                      tend:=false
                                    end
                           end
           until not tend or not hend;
           if hend
             then begin
                    g:=h/2;
                    xh:=x+g;
                    yh:=y+g*f(x,y);
                    y:=y+h*f(xh,yh)
                  end;
           x0:=x;
           h:=h2
         end
end;