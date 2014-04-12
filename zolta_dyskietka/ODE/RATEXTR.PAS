procedure ratextrapol (var x0   : Extended;
                       x1       : Extended;
                       n        : Integer;
                       var y    : vector;
                       fun      : fxysys;
                       eps      : Extended;
                       var ymax : vector;
                       var h    : Extended;
                       var fl   : Boolean;
                       var st   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure ratextrapol calculates approximate values y[1](x1),        }
{  y[2](x1), ..., y[n](x1) of the solution of the system of differential    }
{  equations y'[i]=f[i](x,y[1],y[2],...,y[n]) with the initial conditions   }
{  y[i](x0)=y0[i] (i=1,2,...,n) by rational extrapolation using the         }
{  Bulirsch-Stoer algorithm.                                                }
{  Data:                                                                    }
{    x0  - the argument occurring at the initial condition (changed on      }
{          exit),                                                           }
{    x1  - the value of x for which the solution should be found,           }
{    n   - number of equations,                                             }
{    y   - an array containing the values of y0[i] (i=1,2,...,n) at the     }
{          initial point x0 (changed on exit),                              }
{    fun - a Turbo Pascal procedure which calculates the values of          }
{          functions occurring in the differential equations,               }
{    eps - relative accuracy of the solution (should not exceed 1.0e-14).   }
{  Results:                                                                 }
{    x0 - the given value x1,                                               }
{    y  - an array of approximate values of the components of solution at   }
{         the point x1.                                                     }
{  Other parameters:                                                        }
{    ymax - an array containing maximum values of y[i] (i=1,2,...,n) in the }
{           interval [ x0,x1 ] (do not assign any values),                  }
{    h    - optimal step size for the next integration step (do not assign  }
{           any value),                                                     }
{    fl   - a Boolean variable which should be assigned the value of true   }
{           before the first calling of the procedure, and which should not }
{           be changed later,                                               }
{    st   - a variable which within the procedure ratextrapol is assigned   }
{           the value of:                                                   }
{             1, if n<1,                                                    }
{             2, if eps<1.0e-14,                                            }
{             3, if optimal step size is greater than x1-x0 (in the next    }
{                integration step it is possible to increase the interval   }
{                [ x0,x1 ],                                                 }
{             0, otherwise.                                                 }
{           Note: If st=1 or st=2, then the array y is not changed on exit, }
{                 and if st=3, then the step size h is equal to x1-x0 on    }
{                 exit.                                                     }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [q1..qn,q0..q6], where   }
{              q1<=1, qn>=n, q0<=0 and q6>=6,                               }
{    matrix1 - a type identifier of extended array [q0..q7,q1..qn], where   }
{              q0<=0, q7>=7, q1<=1 and qn>=n,                               }
{    fxysys  - a procedural-type identifier defined as follows              }
{                type fxysys = procedure (x     : Extended;                 }
{                                         n     : Integer;                  }
{                                         ya    : vector;                   }
{                                         var f : vector);                  }
{  Note: A procedure passed as a parameter should be declared with a far    }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k,kappa,l,lambda,rho,sigma,tau     : Integer;
    a,b,beta,c,dh,g,h1,omega,phi,theta,w,x : Extended;
    bo,bh,exit,exit1,exit2,konv            : Boolean;
    f,f1,ya,yl,ym                          : vector;
    d                                      : array [0..6] of Extended;
    delta                                  : matrix;
    yg,yh                                  : matrix1;
begin
  st:=0;
  if n<1
    then st:=1;
  if eps<9e-15
    then st:=2;
  if st=0
    then begin
           x:=x0;
           dh:=x1-x0;
           if fl
             then begin
                    fl:=false;
                    h:=dh;
                    for i:=1 to n do
                      ymax[i]:=0
                  end;
           exit:=false;
           exit1:=false;
           repeat
             fun (x,n,y,f);
             bh:=false;
             for i:=1 to n do
               ya[i]:=y[i];
             exit2:=false;
             repeat
               a:=x+h;
               phi:=1.5e0;
               bo:=false;
               rho:=1;
               sigma:=2;
               tau:=3;
               lambda:=-1;
               j:=0;
               repeat
                 if bo
                   then begin
                          d[1]:=1.77777777777777778e0;
                          d[3]:=7.11111111111111111e0;
                          d[5]:=2.84444444444444444e1
                        end
                   else begin
                          d[1]:=2.25;
                          d[3]:=9;
                          d[5]:=36
                        end;
                 if j>2
                   then konv:=true
                   else konv:=false;
                 if j>6
                   then begin
                          l:=6;
                          d[6]:=64;
                          phi:=0.6*phi
                        end
                   else begin
                          l:=j;
                          d[l]:=sqr(rho)
                        end;
                 rho:=2*rho;
                 g:=h/rho;
                 b:=2*g;
                 if bh and (j<8)
                   then for i:=1 to n do
                          begin
                            ym[i]:=yh[j,i];
                            yl[i]:=yg[j,i]
                          end
                   else begin
                          w:=(rho-2)/2;
                          kappa:=round(w);
                          rho:=rho-1;
                          for i:=1 to n do
                            begin
                              yl[i]:=ya[i];
                              ym[i]:=ya[i]+g*f[i]
                            end;
                          for k:=1 to rho do
                            begin
                              fun (x+k*g,n,ym,f1);
                              for i:=1 to n do
                                begin
                                  w:=yl[i]+b*f1[i];
                                  yl[i]:=ym[i];
                                  ym[i]:=w;
                                  w:=abs(w);
                                  if w>ymax[i]
                                    then ymax[i]:=w
                                end;
                              if (k=kappa) and (k<>2)
                                then begin
                                       lambda:=lambda+1;
                                       for i:=1 to n do
                                         begin
                                           yh[lambda,i]:=ym[i];
                                           yg[lambda,i]:=yl[i]
                                         end
                                     end
                            end
                        end;
                 fun (a,n,ym,f1);
                 for i:=1 to n do
                   begin
                     theta:=delta[i,0];
                     c:=(ym[i]+yl[i]+g*f1[i])/2;
                     omega:=c;
                     delta[i,0]:=c;
                     for k:=1 to l do
                       begin
                         beta:=theta*d[k];
                         b:=beta-c;
                         w:=theta;
                         if b<>0
                           then begin
                                  b:=(c-theta)/b;
                                  w:=b*c;
                                  c:=b*beta
                                end;
                         theta:=delta[i,k];
                         delta[i,k]:=w;
                         omega:=omega+w
                       end;
                     if abs(y[i]-omega)>eps*ymax[i]
                       then konv:=false;
                     y[i]:=omega
                   end;
                 if konv
                   then exit2:=true
                   else begin
                          d[2]:=4;
                          d[4]:=16;
                          bo:=not bo;
                          rho:=sigma;
                          sigma:=tau;
                          tau:=2*rho;
                          j:=j+1
                        end
               until (j=10) or konv;
               if not konv
                 then begin
                        bh:=not bh;
                        h:=h/2
                      end
             until exit2;
             h:=phi*h;
             x:=a;
             if exit
               then begin
                      h:=h1;
                      if abs(h)>abs(dh)
                        then begin
                               st:=3;
                               h:=dh
                             end;
                      x0:=x;
                      exit1:=true
                    end
               else if abs(x+h)>abs(x1)
                      then begin
                             h1:=h;
                             h:=x1-x;
                             exit:=true
                           end;
           until exit and exit1
         end
end;