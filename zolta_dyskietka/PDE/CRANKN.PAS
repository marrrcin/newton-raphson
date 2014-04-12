procedure CrankNicolson (n,j           : Integer;
                         k,a,b         : Extended;
                         c,p,q,f       : coefficient;
                         phi,psi1,psi2 : boundary;
                         var u         : vector;
                         var st        : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure CrankNicolson finds on the j-th level the solution of a    }
{  parabolic partial differential equation c(x,t)u|t=(p(x,t)u|x)|x-q(x,t)u  }
{  +f(x,t), where u=u(x,t), u|x denotes the partial derivative of u with    }
{  respect to x, u|t - with respect to t, a<=x<=b, with the initial         }
{  condition u(x,0)=phi(x) for a<=x<=b and boundary conditions              }
{  u(a,t)=psi1(t), u(b,t)=psi2(t) for t>0. In order to solve this problem   }
{  it is applied the Crank-Nicolson scheme.                                 }
{  Data:                                                                    }
{    n             - number of subintervals in the interval [a,b],          }
{    j             - the level number (on which the solution should be      }
{                    found),                                                }
{    k             - step size in the t-axis direction, i.e. the distance   }
{                    between the (j-1)-th and j-th level,                   }
{    a,b           - the ends of interval in which the x variable is        }
{                    defined,                                               }
{    c,p,q,f       - Turbo Pascal functions which calculate the values of   }
{                    functions c=c(x,t), p=p(x,t), q=q(x,t) and f=f(x,t)    }
{                    occurring in the differential equation,                }
{    phi,psi1,psi2 - Turbo Pascal functions which calculate the values of   }
{                    functions phi=phi(x), psi1=psi1(t) and psi2=psi2(t)    }
{                    occurring in the initial and boundary conditions (the  }
{                    function phi is called only in the case of j=1),       }
{    u             - an array containing the solution on the (j-1)-th level }
{                    for j>1 (the element u[i] should contain the value     }
{                    of u at a+ih, where h=(b-a)/n and i=0,1,...,n).        }
{                    Note: If j=1, then the procedure uses the initial      }
{                          condition instead of u. If j>1, then the         }
{                          elements of u are changed on exit.               }
{  Result:                                                                  }
{    u - an array containing the solutions on the j-th level (the element   }
{        u[i] contains the solution at the point (a+ih,jk); i=0,1,..,n).    }
{  Other parameters:                                                        }
{    st - a variable which within the procedure CrankNicolson is assigned   }
{         the value of:                                                     }
{           1, if n<4 or j<1,                                               }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array u are not changed on    }
{               exit.                                                       }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q0..qm], where      }
{                  q0<=0 and qm>=n,                                         }
{    vector1     - a type identifier of extended array [q1..qn1], where     }
{                  q1<=1 and qn1>=n-1,                                      }
{    vector2     - a type identifier of extended array [q1..qn2], where     }
{                  q1<=1 and qn2>=n-2,                                      }
{    vector3     - a type identifier of extended array [q2..qn1], where     }
{                  q2<=2 and qn1>=n-1,                                      }
{    coefficient - a procedural-type identifier defined as follows          }
{                    type coefficient = function (x,t : Extended)           }
{                                       : Extended;                         }
{    boundary    - a procedural-type identifier defined as follows          }
{                    type boundary = function (t : Extended) : Extended;    }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,n1,n2                               : Integer;
    ah,ah1,bh,bh1,d1,d2,e,h,h2,jk,jk1,kh2 : Extended;
    mu,rho                                : vector1;
    nu                                    : vector2;
    nu1                                   : vector3;
begin
  if (n<4) or (j<1)
    then st:=1
    else begin
           st:=0;
           h:=(b-a)/n;
           h2:=h/2;
           kh2:=k/(h*h);
           n1:=n-1;
           n2:=n1-1;
           jk:=j*k;
           jk1:=jk-k;
           for i:=1 to n1 do
             begin
               ah:=a+i*h;
               e:=c(ah,jk)+c(ah,jk1);
               d1:=k*q(ah,jk);
               ah1:=ah+h2;
               ah:=ah-h2;
               mu[i]:=kh2*(p(ah,jk)+p(ah1,jk))+e+d1;
               e:=-kh2*(p(ah,jk1)+p(ah1,jk1))+e;
               if j=1
                 then rho[i]:=e*phi(a+i*h)
                 else rho[i]:=e*u[i];
             end;
           rho[1]:=rho[1]+kh2*p(a+h2,jk)*psi1(jk);
           rho[n1]:=rho[n1]+kh2*p(b-h2,jk)*psi2(jk);
           for i:=1 to n1 do
             begin
               ah:=a+i*h;
               d1:=kh2*p(ah-h2,jk1);
               d2:=kh2*p(ah+h2,jk1);
               if j=1
                 then e:=d1*phi(ah-h)+d2*phi(ah+h)
                 else e:=d1*u[i-1]+d2*u[i+1];
               rho[i]:=rho[i]+k*(f(ah,jk)+f(ah,jk1))+e;
               if i<n1
                 then nu[i]:=-kh2*p(ah+h2,jk);
               if i>1
                 then nu1[i]:=-kh2*p(ah-h2,jk)
             end;
           d1:=mu[1];
           i:=0;
           d2:=rho[1]/d1;
           rho[1]:=d2;
           repeat
             i:=i+1;
             e:=nu[i]/d1;
             nu[i]:=e;
             d1:=mu[i+1]-e*nu1[i+1];
             d2:=(rho[i+1]-d2*nu1[i+1])/d1;
             rho[i+1]:=d2
           until i=n2;
           d1:=rho[n1];
           u[n1]:=d1;
           for i:=n2 downto 1 do
             begin
               d1:=rho[i]-d1*nu[i];
               u[i]:=d1
             end;
           u[0]:=psi1(jk);
           u[n]:=psi2(jk)
         end
end;