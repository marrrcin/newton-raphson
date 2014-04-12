procedure Adamsvarsteppredcorr (x0, xn, y0      : Extended;
                                var n           : Integer;
                                f               : fxy;
                                eps, hmin, hmax : Extended;
                                var x, y        : vector;
                                var st          : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Adamsvarsteppredcorr calculates approximate values         }
{  y(x[i]), where i=0,1,...,k, k<=n, of the solution of the single          }
{  differential equation y'=f(x,y) with the initial condition y(x0)=y0 by   }
{  the fourth order predictor-corrector method with an automatic step size  }
{  correction.                                                              }
{  Data:                                                                    }
{    x0, xn - the endpoints of the integration interval,                    }
{    y0     - the value of y at the initial point x0,                       }
{    n      - maximum number of points at which the approximate solution    }
{             should be found,                                              }
{    f      - a Turbo Pascal function which calculates the value of the     }
{             function f(x,y) occurring in the differential equation,       }
{    eps    - tolerance for the solution accuracy,                          }
{    hmin   - minimum admissible step size,                                 }
{    hmax   - maximum admissible step size.                                 }
{  Results:                                                                 }
{    n - number of points at which the approximate solution has been found, }
{    x - an array of points at which the solution has been colculated,      }
{    y - an array containing the solution at the points x[i] (the element   }
{        y[i] contains the solution at x[i]; y[0]=y0, where y0 is given).   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Adamspredcorr is assigned   }
{         the value of:                                                     }
{           1, if n<4,                                                      }
{           2, if hmax>xn-x0,                                               }
{           3, if hmin>=hmax,                                               }
{           4, if eps<=0,                                                   }
{           5, if the step size should be less then hmin to achieve the     }
{              given tolernce of the solution accuracy,                     }
{           6, if the end of the integration interval is not achieved after }
{              evaluations of n points,                                     }
{           0, otherwise.                                                   }
{         Note: If st=1, 2, 3 or 4, then the elements of arrays x and y are }
{               not changed on exit. If st=5, then some initial elements of }
{               these arrays may be changed, and if st=6, then y contains   }
{               the solution at n initial points of the interval [x0,xn].   }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qn], where q0<=0     }
{             and qn>=n,                                                    }
{    fxy    - a procedural-type identifier defined as follows               }
{               type fxy = function (x,y : Extended) : Extended;            }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
type vector3 = array [0..3] of Extended;
var i,j                          : Integer;
    delta,h,h1,f1,f2,f3,xx,yp,yc : Extended;
    notok1,notok2                : Boolean;
    t,v                          : vector3;
procedure RK4 (h       : Extended;
               var t,v : vector3);
var k                 : Integer;
    k1,k2,k3,k4,xk,yk : Extended;
begin
  for k:=1 to 3 do
    begin
      xk:=t[k-1];
      yk:=v[k-1];
      k1:=h*f(xk,yk);
      k2:=h*f(xk+h/2,yk+k1/2);
      k3:=h*f(xk+h/2,yk+k2/2);
      k4:=h*f(xk+h,yk+k3);
      v[k]:=yk+(k1+2*k2+2*k3+k4)/6;
      t[k]:=xk+h
    end
end;
begin
  st:=0;
  if n<4
    then st:=1
    else if hmax>xn-x0
           then st:=2
           else if hmin>=hmax
                  then st:=3
                  else if eps<=0
                         then st:=4;
  if st=0
    then begin
           h:=hmax;
           x[0]:=x0;
           y[0]:=y0;
           t[0]:=x0;
           v[0]:=y0;
           RK4 (h,t,v);
           for j:=1 to 3 do
             begin
               x[j]:=t[j];
               y[j]:=v[j]
             end;
           notok1:=True;
           notok2:=True;
           i:=4;
           xx:=x[3]+h;
           while ((x[i-1]<=xn) or notok2) and (st=0) do
             begin
               f1:=f(x[i-1],y[i-1]);
               f2:=f(x[i-2],y[i-2]);
               f3:=f(x[i-3],y[i-3]);
               yp:=y[i-1]+h*(55*f1-59*f2+37*f3-9*f(x[i-4],y[i-4]))/24;
               yc:=y[i-1]+h*(9*f(xx,yp)+19*f1-5*f2+f3)/24;
               delta:=19*abs(yc-yp)/(270*h);
               if delta<=eps
                 then begin
                        y[i]:=yc;
                        x[i]:=xx;
                        notok1:=False;
                        notok2:=False;
                        i:=i+1
                      end
                 else begin
                        if delta<=eps/10
                          then begin
                                 h1:=h;
                                 f1:=exp(0.25*ln(eps/(2*delta)));
                                 if f1>4
                                   then h:=4*h
                                   else h:=f1*h;
                                 if h>hmax
                                   then h:=hmax;
                                 if x[i-1]+3*h>=xn
                                   then h:=h1;
                                 if h<>h1
                                   then notok1:=True;
                                 t[0]:=x[i-1];
                                 v[0]:=y[i-1];
                                 RK4 (h,t,v);
                                 for j:=1 to 3 do
                                   begin
                                     x[i+j-1]:=t[j];
                                     y[i+j-1]:=v[j]
                                   end;
                                 i:=i+3
                               end
                          else begin
                                 notok2:=True;
                                 f1:=exp(0.25*ln(2*delta));
                                 if f1<=0.1
                                   then h:=0.1*h
                                   else h:=f1*h;
                                 if h<hmin
                                   then st:=5;
                                 if st=0
                                   then begin
                                          if notok1
                                            then i:=i-3;
                                          t[0]:=x[0];
                                          v[0]:=y[0];
                                          RK4 (h,t,v);
                                          for j:=1 to 3 do
                                            begin
                                              x[i+j-1]:=t[j];
                                              y[i+j-1]:=v[j]
                                            end;
                                          i:=i+3;
                                          notok1:=True
                                        end
                               end
                      end;
               xx:=x[i-1]+h;
               if i>n
                 then st:=6
             end;
           if st=0
             then n:=i-1
         end
end;