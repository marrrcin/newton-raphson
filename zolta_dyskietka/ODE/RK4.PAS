procedure RungeKutta4 (var x0     : Extended;
                       x1         : Extended;
                       var y      : Extended;
                       f          : fxy;
                       mh,eps,eta : Extended;
                       var h      : Extended;
                       var fl     : Boolean;
                       var st     : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure RungeKutta4 calculates an approximate value y(x1) of the   }
{  solution of the single differential equation y'=f(x,y) with the initial  }
{  condition y(x0)=y0 by the fourth order Runge-Kutta method with an        }
{  automatic step size correction.                                          }
{  Data:                                                                    }
{    x0      - the argument occurring at the initial condition (changed on  }
{              exit),                                                       }
{    x1      - the value of x for which the solution should be found,       }
{    y       - the value of y0 at the initial condition (changed on exit),  }
{    f       - a Turbo Pascal function which calculates the value of the    }
{              function f(x,y) occurring in the differential equation,      }
{    mh      - minimum admissible absolute value of step size,              }
{    eps,eta - values which characterize the accuracy of the solution.      }
{  Results:                                                                 }
{    x0 - the given value x1,                                               }
{    y  - an approximate value of the solution at the point x1.             }
{  Other parameters:                                                        }
{    h  - a step size used within the procedure (do not assign any value),  }
{    fl - a Boolean variable which should be assigned the value of true     }
{         before the first calling of the procedure, and which should not   }
{         be changed later,                                                 }
{    st - a variable which within the procedure RungeKutta4 is assigned the }
{         value of:                                                         }
{           1, if for abs(h)<mh the given accuracy eps is not achieved,     }
{           0, otherwise.                                                   }
{         Note: If st=1, then y contains the last calculated solution, and  }
{               x0 is the point at which this solution has been found.      }
{  Unlocal identifier:                                                      }
{    fxy - a procedural-type identifier defined as follows                  }
{            type fxy = function (x,y : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
const c=1.25e0;
var   sh                              : Integer;
      eps1,h1,h2,w1,w2,w3,w4,y1,y2,y3 : Extended;
      gd,nk,nt,rp                     : Boolean;
procedure onestep (x,u,hh : Extended;
                   var yh : Extended);
var i  : Integer;
    yw : Extended;
begin
  w1:=hh/2;
  w4:=w1;
  w2:=x;
  yw:=u;
  yh:=0;
  for i:=1 to 4 do
    begin
      if (i=1) or (i=4)
        then w3:=w4
        else w3:=hh;
      w2:=f(w2,yw);
      yh:=yh+w3*w2;
      yw:=u+w1*w2;
      w2:=x+w1;
      w1:=w3
    end;
  yh:=u+yh/3
end {onestep};
begin
  st:=0;
  eps1:=eps/40;
  w1:=x1-x0;
  if w1<0
    then sh:=-1
    else if w1=0
           then sh:=0
           else sh:=1;
  nt:=false;
  if fl
    then begin
           h:=w1;
           h1:=h;
           fl:=false
         end
    else begin
           h1:=h;
           if abs(h1)<mh
             then begin
                    h:=mh*sh;
                    h1:=h
                  end;
           if (x0+c*h1-x1)*sh>=0
             then h1:=w1
             else nt:=true
         end;
  rp:=true;
  repeat
    gd:=true;
    onestep (x0,y,h1,y1);
    nk:=true;
    repeat
      h2:=h1/2;
      onestep (x0,y,h2,y2);
      onestep (x0+h2,y2,h2,y3);
      w4:=0;
      w1:=y1;
      w3:=y3;
      w2:=abs(w1-w3);
      w1:=abs(w2);
      w3:=abs(w3);
      if w1<w3
        then w1:=w3;
      if w1<eta
        then w1:=eta;
      w1:=w2/w1;
      if w1>w4
        then w4:=w1;
      if w4>eps
        then begin
               gd:=false;
               if abs(h2)<mh
                 then begin
                        st:=1;
                        rp:=false
                      end
                 else begin
                        h:=h2;
                        h1:=h;
                        nt:=true;
                        y1:=y2
                      end
             end
        else nk:=false
    until not nk or (st=1);
    if not nk
      then begin
             w3:=y3;
             y:=w3+(w3-y1)/15;
             if nt
               then begin
                      x0:=x0+h1;
                      if (w4<eps1) and gd
                        then begin
                               h:=2*h1;
                               h1:=h
                             end;
                      if (x0+c*h1-x1)*sh>=0
                        then begin
                               h1:=x1-x0;
                               nt:=false
                             end
                    end
               else begin
                      x0:=x1;
                      rp:=false
                    end
           end
  until not rp
end;