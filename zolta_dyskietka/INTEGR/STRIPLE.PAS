function Simpsontriple (alpha,beta   : Extended;
                        gamma, delta : fx;
                        eta, kappa   : fxy;
                        f            : fxyz;
                        n, m, p      : Integer;
                        var st       : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Simpsontriple finds an approximate value of the triple      }
{  integral from an integrand f(x,y,z) in a region V = [(x,y,z) :           }
{  alpha<=x<=beta, delta(x)<=y<=gamma(x), eta(x,y)<=z<=kappa(x,y)]          }
{  by Simpson's method.                                                     }
{  Data:                                                                    }
{    alpha,beta  - the ends of the integration interval with respect to x,  }
{    gamma,delta - the functions of x which bound the values of y,          }
{    eta,kappa   - the functions of x and y which bound the values of z,    }
{    f           - a Turbo Pascal function which for the given x, y and z   }
{                  calculates the value of integrand f(x,y,z),              }
{    n,m,p       - positive integers which determine the step sizes for x,  }
{                  y and z (the step size for x is equal to                 }
{                  (beta-alpha)/(2n)), the step size for y varies with x    }
{                  and is equal to (delta(x)-gamma(x))/(2m), and the step   }
{                  size for z varies with both x and y and is equal to      }
{                  (kappa(x,y)-eta(x,y))/(2p)).                             }
{  Result:                                                                  }
{    Simpsontriple(alpha,beta,gamma,delta,f,n,m,p,st) - approximate value   }
{                                                       of the integral.    }
{  Other parameters:                                                        }
{    st - a variable which within the function Simpsontriple is assigned    }
{         the value of:                                                     }
{           1, if n<1 or m<1 or p<1,                                        }
{           0, otherwise.                                                   }
{         Note: If st=1, then                                               }
{               Simpsontriple(alpha,beta,gamma,delta,f,n,m,p,st) is not     }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    fx   - a procedural-type identifier defined as follows                 }
{              type fx = function (x : Extended) : Extended;                }
{    fxy  - a procedural-type identifier defined as follows                 }
{              type fxy = function (x,y : Extended) : Extended;             }
{    fxyz - a procedural-type identifier defined as follows                 }
{              type fxyz = function (x,y,z : Extended) : Extended;          }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k                  : Integer;
    h,hx,hxy,i1,i2,i3,j1,
    j2,j3,k1,k2,k3,w,x,y,z : Extended;
begin
  if (n<1) or (m<1) or (p<1)
    then st:=1
    else begin
           st:=0;
           h:=(beta-alpha)/(2*n);
           i1:=0;
           i2:=0;
           i3:=0;
           for i:=0 to 2*n do
             begin
               x:=alpha+i*h;
               hx:=(delta(x)-gamma(x))/(2*m);
               j1:=0;
               j2:=0;
               j3:=0;
               for j:=0 to 2*m do
                 begin
                   y:=gamma(x)+j*hx;
                   hxy:=kappa(x,y);
                   hxy:=(hxy-eta(x,y))/(2*p);
                   k1:=f(x,y,eta(x,y));
                   k1:=k1+f(x,y,kappa(x,y));
                   k2:=0;
                   k3:=0;
                   for k:=1 to 2*p-1 do
                     begin
                       z:=eta(x,y)+k*hxy;
                       w:=f(x,y,z);
                       if Odd(k)
                         then k3:=k3+w
                         else k2:=k2+w
                     end;
                   w:=(k1+2*k2+4*k3)*hxy/3;
                   if (j=0) or (j=2*m)
                     then j1:=j1+w
                     else if Odd(j)
                            then j3:=j3+w
                            else j2:=j2+w
                 end;
               w:=(j1+2*j2+4*j3)*hx/3;
               if (i=0) or (i=2*n)
                 then i1:=i1+w
                 else if Odd(i)
                        then i3:=i3+w
                        else i2:=i2+w
             end;
           Simpsontriple:=(i1+2*i2+4*i3)*h/3
         end
end;