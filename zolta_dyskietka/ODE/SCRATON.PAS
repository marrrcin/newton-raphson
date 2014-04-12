procedure Scraton (var x0 : Extended;
                   x1     : Extended;
                   var y  : Extended;
                   f      : fxy;
                   mh,eps : Extended;
                   var h  : Extended;
                   var fl : Boolean;
                   var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Scraton calculates an approximate value y(x1) of the       }
{  solution of the single differential equation y'=f(x,y) with the initial  }
{  condition y(x0)=y0 by Scraton's method with an automatic step size       }
{  correction.                                                              }
{  Data:                                                                    }
{    x0  - the argument occurring at the initial condition (changed on      }
{          exit),                                                           }
{    x1  - the value of x for which the solution should be found,           }
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
{    st - a variable which within the procedure Scraton is assigned the     }
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
      d=2.222222222222222222e-1;
var   sh                               : Integer;
      eps1,h1,k1,k2,k3,k4,k5,k41,xh,yh : Extended;
      gd,nk,nl,rp                      : Boolean;
begin
  st:=0;
  eps1:=eps/40;
  k1:=x1-x0;
  if k1<0
    then sh:=-1
    else if k1=0
           then sh:=0
           else sh:=1;
  if not fl
    then begin
           h1:=h;
           if abs(h1)<mh
             then begin
                    h:=mh*sh;
                    h1:=h
                  end;
           if (x0+c*h1-x1)*sh<0
             then nl:=true
             else h1:=k1
         end
    else begin
           h:=k1;
           h1:=h;
           fl:=false
         end;
  rp:=true;
  repeat
    gd:=true;
    nk:=true;
    repeat
      k1:=h1*f(x0,y);
      xh:=x0+d*h1;
      yh:=y+d*k1;
      k2:=h1*f(xh,yh);
      xh:=x0+h1/3;
      yh:=y+k1/12+k2/4;
      k3:=h1*f(xh,yh);
      xh:=x0+7.5e-1*h1;
      yh:=y+5.390625e-1*k1-1.8984375e0*k2+2.109375e0*k3;
      k4:=h1*f(xh,yh);
      xh:=x0+9.0e-1*h1;
      yh:=y-3.105e-1*k1+1.8225e0*k2;
      yh:=yh-1.1016e0*k3+4.896e-1*k4;
      k5:=h1*f(xh,yh);
      k41:=k4-k1;
      if k41<>0
        then begin
               xh:=3.4e-1*k1-9.72e-1*k2+1.632e0*k4-k5;
               yh:=1.29357298474945534e-1*k1-5.51470588235294118e-1*k2;
               yh:=yh+4.65686274509803922e-1*k3-4.35729847494553377e-2*k4;
               k2:=xh*yh/k41;
               yh:=1.04938271604938272e-1*k1+4.76470588235294118e-1*k3;
               yh:=yh+2.37037037037037037e-1*k4+1.81554103122730574e-1*k5;
               k1:=y-k2+yh;
               k2:=abs(k2);
               nk:=not (k2<=eps)
             end;
      if nk
        then begin
               gd:=false;
               if abs(h1)<mh
                 then begin
                        st:=1;
                        rp:=false
                      end
                 else begin
                        h:=h1/2;
                        h1:=h;
                        nl:=true
                      end
             end
    until not nk or (st=1);
    if not nk
      then begin
             y:=k1;
             if nl
               then begin
                      x0:=x0+h1;
                      if (k2<eps1) and gd
                        then begin
                               h:=2*h1;
                               h1:=h
                             end;
                      if (x0+c*h1-x1)*sh>=0
                        then begin
                               h1:=x1-x0;
                               nl:=false
                             end
                    end
               else begin
                      x0:=x1;
                      rp:=false
                    end
           end
  until not rp
end;