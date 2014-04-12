procedure Fehlberg (var x0  : Extended;
                    x1      : Extended;
                    n       : Integer;
                    var y   : vector;
                    fun     : fxysys;
                    eps,eta : Extended;
                    var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Fehlberg calculates approximate values y[1](x1), y[2](x1), }
{  ..., y[n](x1) of the solution of the system of differential equations    }
{  y'[i]=f[i](x,y[1],y[2],...,y[n]) with the initial conditions             }
{  y[i](x0)=y0[i] (i=1,2,...,n) by Fehlberg's method with an automatic step }
{  size correction.                                                         }
{  Data:                                                                    }
{    x0  - the argument occurring at the initial conditions (changed on     }
{          exit),                                                           }
{    x1  - the value of x for which the solution should be found,           }
{    n   - number of equations,                                             }
{    y   - an array containing the values of y0[i] (i=1,2,...,n) at the     }
{          initial point x0 (changed on exit),                              }
{    fun - a Turbo Pascal procedure which calculates the values of the      }
{          functions occurring in differential equations,                   }
{    eps - relative error (cannot be less then 1.0e-14),                    }
{    eta - absolute error.                                                  }
{          Note: At each step the procedure requires that                   }
{                  abs(local error)<=eps*abs(y)+eta                         }
{                for each component of the local error and solution.        }
{  Results:                                                                 }
{    x0 - the given value x1,                                               }
{    y  - an array of approximate values of components of the solution at   }
{         the point x1.                                                     }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Fehlberg is assigned the    }
{         value of:                                                         }
{           1, if n<1,                                                      }
{           2, if x0=x1,                                                    }
{           3, if eps<1.0e-14 or eta<0,                                     }
{           4, if more than 12000 function evaluations are needed (the      }
{              method is too expensive),                                    }
{           5, if the given accuracy is not achieved using the smallest     }
{              allowable step size,                                         }
{           0, otherwise.                                                   }
{         Note: If st=1,2 or 3, then y is not changed on exit. If st=4 or   }
{               5, then the elements of array y contain the last calculated }
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
const u=2.0e-13;
var   k,nfe                                : Integer;
      a,ae,dx,et,etn,h,hmin,ym,ypm,s,sc,s1 : Extended;
      fl,fh,fsh,hf                         : Boolean;
      f1,f2,f3,f4,f5,yp                    : vector;
begin
  st:=0;
  if n<1
    then st:=1
    else if x0=x1
           then st:=2
           else if (eps<9e-15) or (eta<0)
                  then st:=3;
  if st=0
    then begin
           dx:=x1-x0;
           a:=x0;
           nfe:=1;
           fun (a,n,y,yp);
           ym:=0;
           ypm:=0;
           for k:=1 to n do
             begin
               s:=abs(yp[k]);
               if s>ypm
                 then ypm:=s;
               s:=abs(y[k]);
               if s>ym
                 then ym:=s
             end;
           etn:=eps*ym+eta;
           h:=abs(dx);
           if etn<ypm*exp(5*ln(h))
             then begin
                    s:=abs(x0);
                    if s<h
                      then s:=h;
                    s:=u*s;
                    s1:=exp(0.2*ln(etn/ypm));
                    if s>s1
                      then h:=s
                      else h:=s1
                  end;
           if dx<0
             then h:=-h;
           if abs(dx)>u*abs(x0)
             then begin
                    fsh:=false;
                    sc:=2/eps;
                    ae:=sc*eta;
                    fl:=false;
                    repeat
                      hf:=false;
                      hmin:=u*abs(x0);
                      dx:=x1-x0;
                      if abs(dx)<2*abs(h)
                        then if abs(dx)>abs(h)
                               then h:=dx/2
                               else begin
                                      fsh:=true;
                                      h:=dx
                                    end;
                      fh:=false;
                      repeat
                        s:=0.25*h;
                        for k:=1 to n do
                          f5[k]:=y[k]+s*yp[k];
                        fun (x0+s,n,f5,f1);
                        s:=9.375e-2*h;
                        for k:=1 to n do
                          f5[k]:=y[k]+s*(yp[k]+3*f1[k]);
                        fun (x0+0.375*h,n,f5,f2);
                        s:=h/2197;
                        for k:=1 to n do
                          f5[k]:=y[k]+s*(1932*yp[k]+(7296*f2[k]-7200*f1[k]));
                        fun (x0+12*h/13,n,f5,f3);
                        s:=h/4104;
                        for k:=1 to n do
                          f5[k]:=y[k]+s*((8341*yp[k]-845*f3[k])
                                 +(29440*f2[k]-32832*f1[k]));
                        fun (x0+h,n,f5,f4);
                        s:=h/20520;
                        for k:=1 to n do
                          f1[k]:=y[k]+s*((-6080*yp[k]+(9295*f3[k]
                                 -5643*f4[k]))+(41040*f1[k]-28352*f2[k]));
                        fun (x0+0.5*h,n,f1,f5);
                        s:=h/7618050;
                        for k:=1 to n do
                          f1[k]:=y[k]+s*((902880*yp[k]+(3855735*f3[k]
                                 -1371249*f4[k]))+(3953664*f2[k]
                                 +277020*f5[k]));
                        nfe:=nfe+5;
                        et:=0;
                        for k:=1 to n do
                          begin
                            s:=abs(-2090*yp[k]+(21970*f3[k]-15048*f4[k])
                               +(22528*f2[k]-27360*f5[k]))
                               /(abs(y[k])+abs(f1[k])+ae);
                            if s>et
                              then et:=s
                          end;
                        etn:=abs(h)*et*sc/752400;
                        if etn<=1
                          then begin
                                 x0:=x0+h;
                                 for k:=1 to n do
                                   y[k]:=f1[k];
                                 a:=x0;
                                 fun (a,n,y,yp);
                                 nfe:=nfe+1;
                                 if not hf
                                   then begin
                                          if etn>1.889568e-4
                                            then s:=0.9/exp(0.2*ln(etn))
                                            else s:=5;
                                          s1:=s*abs(h);
                                          if s1>hmin
                                            then s:=s1
                                            else s:=hmin;
                                          if h<0
                                            then h:=-s
                                            else h:=s
                                        end;
                                 if fsh
                                   then begin
                                          x0:=x1;
                                          fh:=true;
                                          fl:=true
                                        end
                                   else fh:=true
                               end
                          else begin
                                 hf:=true;
                                 fsh:=false;
                                 if etn<59049
                                   then s:=0.9/exp(0.2*ln(etn))
                                   else s:=0.1;
                                 h:=s*h;
                                 if abs(h)<=hmin
                                   then begin
                                          st:=5;
                                          fh:=true;
                                          fl:=true;
                                        end
                               end
                      until fh or (nfe>12000);
                      if nfe>12000
                        then begin
                               st:=4;
                               fl:=true
                             end
                    until fl
                  end
             else begin
                    for k:=1 to n do
                      y[k]:=y[k]+dx*yp[k];
                    a:=x1
                  end
         end
end;