procedure RungeKutta4system (var x0     : Extended;
                             x1         : Extended;
                             n          : Integer;
                             var y      : vector;
                             fun        : fxysys;
                             mh,eps,eta : Extended;
                             var h      : Extended;
                             var fl     : Boolean;
                             var st     : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure RungeKutta4system calculates approximate values y[1](x1),  }
{  y[2](x1), ..., y[n](x1) of the solution of the system of differential    }
{  equations y'[i]=f[i](x,y[1],y[2],...,y[n]) with the initial conditions   }
{  y[i](x0)=y0[i] (i=1,2,...,n) by the fourth order Runge-Kutta method with }
{  an automatic step size correction.                                       }
{  Data:                                                                    }
{    x0      - the argument occurring at the initial conditions (changed on }
{              exit),                                                       }
{    x1      - the value of x for which the solution should be found,       }
{    n       - number of equations,                                         }
{    y       - an array containing the values of y0[i] (i=1,2,...,n) at the }
{              initial point x0 (changed on exit),                          }
{    fun     - a Turbo Pascal procedure which calculates the values of the  }
{              functions occurring in the differential equations,           }
{    mh      - minimum admissible absolute value of step size,              }
{    eps,eta - values which characterize the accuracy of the solution.      }
{  Results:                                                                 }
{    x0 - the given value x1,                                               }
{    y  - an array of approximate values of the components of solution at   }
{         the point x1.                                                     }
{  Other parameters:                                                        }
{    h  - a step size used within the procedure (do not assign any value),  }
{    fl - a Boolean variable which should be assigned the value of true     }
{         before the first calling of the procedure, and which should not   }
{         be changed later,                                                 }
{    st - a variable which within the procedure RungeKutta4system is        }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if for abs(h)<mh the given accuracy eps is not achieved,     }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array y are not changed on    }
{               exit. If st=2, then y contains the last calculated          }
{               components of the solution, and x0 is the point at which    }
{               this solution has been found.                               }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    fxysys - a procedural-type identifier defined as follows               }
{               type fxysys = procedure (x     : Extended;                  }
{                                        n     : Integer;                   }
{                                        y     : vector;                    }
{                                        var f : vector);                   }
{  Note: A procedure passed as a parameter should be declared with a far    }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
const c=1.25e0;
var   k,sh                   : Integer;
      eps1,h1,h2,w1,w2,w3,w4 : Extended;
      gd,nk,nt,rp            : Boolean;
      f,y1,y2,y3             : vector;
procedure onestep (x      : Extended;
                   u      : vector;
                   hh     : Extended;
                   var yh : vector);
var i,k : Integer;
    yw  : vector;
begin
  w1:=hh/2;
  w4:=w1;
  w2:=x;
  for k:=1 to n do
    begin
      yw[k]:=u[k];
      yh[k]:=0
    end;
  for i:=1 to 4 do
    begin
      if (i=1) or (i=4)
        then w3:=w4
        else w3:=hh;
      fun (w2,n,yw,f);
      for k:=1 to n do
        begin
          w2:=f[k];
          yh[k]:=yh[k]+w3*w2;
          yw[k]:=u[k]+w1*w2
        end;
      w2:=x+w1;
      w1:=w3
    end;
  for k:=1 to n do
    yh[k]:=u[k]+yh[k]/3
end {onestep};
begin
  if n<1
    then st:=1
    else begin
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
               for k:=1 to n do
                 begin
                   w1:=y1[k];
                   w3:=y3[k];
                   w2:=abs(w1-w3);
                   w1:=abs(w2);
                   w3:=abs(w3);
                   if w1<w3
                     then w1:=w3;
                   if w1<eta
                     then w1:=eta;
                   w1:=w2/w1;
                   if w1>w4
                     then w4:=w1
                 end;
               if w4>eps
                 then begin
                        gd:=false;
                        if abs(h2)<mh
                          then begin
                                 st:=2;
                                 rp:=false
                               end
                          else begin
                                 h:=h2;
                                 h1:=h;
                                 nt:=true;
                                 for k:=1 to n do
                                   y1[k]:=y2[k]
                               end
                      end
                 else nk:=false
             until not nk or (st=2);
             if not nk
               then begin
                      for k:=1 to n do
                        begin
                          w3:=y3[k];
                          y[k]:=w3+(w3-y1[k])/15
                        end;
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
         end
end;