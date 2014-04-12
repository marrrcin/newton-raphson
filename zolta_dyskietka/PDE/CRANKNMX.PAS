procedure CrankNicolsonmixed (n,j              : Integer;
                              k,a,b,alpha,beta : Extended;
                              c,p,q,f          : coefficient;
                              phi,psi1,psi2    : boundary;
                              var u            : vector;
                              var st           : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure CrankNicolsonmixed finds on the j-th level the solution of }
{  a parabolic partial differential equation c(x,t)u|t=(p(x,t)u|x)|x        }
{  -q(x,t)u+f(x,t), where u=u(x,t), u|x denotes the partial derivative of u }
{  with respect to x, u|t - with respect to t, a<=x<=b, with the initial    }
{  condition u(x,0)=phi(x) for a<=x<=b and mixed boundary conditions        }
{  u|x-alpha*u=psi1(t) for x=a, t>0, and u|x+beta*u=psi2(t) for x=b, t>0.   }
{  In order to solve this problem it is applied the Crank-Nicolson scheme.  }
{  Data:                                                                    }
{    n             - number of subintervals in the interval [a,b],          }
{    j             - the level number (on which the solution should be      }
{                    found),                                                }
{    k             - step size in the t-axis direction, i.e. the distance   }
{                    between the (j-1)-th and j-th level,                   }
{    a,b           - the ends of interval in which the x variable is        }
{                    defined,                                               }
{    alpha,beta    - constants occurring in the mixed boundary conditions,  }
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
{    st - a variable which within the procedure CrankNicolsonmixed is       }
{         assigned the value of:                                            }
{           1, if n<1 or j<1,                                               }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array u are not changed on    }
{               exit.                                                       }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q0..qn], where      }
{                  q0<=0 and qn>=n,                                         }
{    vector1     - a type identifier of extended array [q0..qn1], where     }
{                  q0<=0 and qn1>=n-1,                                      }
{    vector2     - a type identifier of extended array [q1..qn], where      }
{                  q1<=0 and qn>=n,                                         }
{    coefficient - a procedural-type identifier defined as follows          }
{                    type coefficient = function (x,y : Extended)           }
{                                       : Extended;                         }
{    boundary    - a procedural-type identifier defined as follows          }
{                    type boundary = function (x : Extended) : Extended;    }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,n1                                     : Integer;
    ah,ah1,bh,bh1,d1,d2,e,e1,h,h2,jk,jk1,kh2 : Extended;
    mu,rho                                   : vector;
    nu                                       : vector1;
    nu1                                      : vector2;
begin
  if (n<1) or (j<1)
    then st:=1
    else begin
           st:=0;
           h:=(b-a)/n;
           h2:=h/2;
           kh2:=k/(h*h);
           n1:=n-1;
           jk:=j*k;
           jk1:=jk-k;
           d1:=1-2*h*alpha;
           d2:=1-2*h*beta;
           ah:=a-h2;
           ah1:=a+h2;
           e:=c(a,jk)+c(a,jk1);
           e1:=k*q(a,jk);
           mu[0]:=kh2*(d1*p(ah,jk)+p(ah1,jk))+e+e1;
           rho[0]:=-kh2*(d1*p(ah,jk1)+p(ah1,jk1))+e;
           for i:=1 to n1 do
             begin
               ah:=a+i*h;
               e:=c(ah,jk)+c(ah,jk1);
               e1:=k*q(ah,jk);
               ah1:=ah+h2;
               ah:=ah-h2;
               mu[i]:=kh2*(p(ah,jk)+p(ah1,jk))+e+e1;
               rho[i]:=-kh2*(p(ah,jk1)+p(ah1,jk1))+e
             end;
           bh:=b-h2;
           bh1:=b+h2;
           e:=c(b,jk)+c(b,jk1);
           e1:=k*q(b,jk);
           mu[n]:=kh2*(d2*p(bh,jk)+p(bh1,jk))+e+e1;
           rho[n]:=-kh2*(d2*p(bh,jk1)+p(bh1,jk1))+e;
           for i:=0 to n do
             if j=1
               then rho[i]:=rho[i]*phi(a+i*h)
               else rho[i]:=rho[i]*u[i];
           d1:=kh2*(p(a-h2,jk1)+p(a+h2,jk1));
           d2:=kh2*(p(bh,jk1)+p(bh1,jk1));
           if j=1
             then begin
                    rho[0]:=rho[0]+d1*phi(a+h);
                    rho[n]:=rho[n]+d2*phi(b-h)
                  end
             else begin
                    rho[0]:=rho[0]+d1*u[1];
                    rho[n]:=rho[n]+d2*u[n1]
                  end;
           ah:=a-h2;
           rho[0]:=rho[0]-2*h*kh2*(p(ah,jk)*psi1(j*k)+p(ah,jk1)*psi1(jk1));
           rho[n]:=rho[n]-2*h*kh2*(p(bh1,jk)*psi2(jk)+p(bh1,jk1)*psi2(jk1));
           nu[0]:=-kh2*(p(ah,jk)+p(a+h2,jk));
           for i:=1 to n1 do
             begin
               ah:=a+i*h;
               d1:=kh2*p(ah-h2,jk1);
               d2:=kh2*p(ah+h2,jk1);
               if j=1
                 then rho[i]:=rho[i]+d1*phi(ah-h)+d2*phi(ah+h)
                 else rho[i]:=rho[i]+d1*u[i-1]+d2*u[i+1];
               nu[i]:=-kh2*p(ah+h2,jk);
               nu1[i]:=-kh2*p(ah-h2,jk)
             end;
           nu1[n]:=-kh2*(p(bh,jk)+p(bh1,jk));
           for i:=0 to n do
             begin
               ah:=a+i*h;
               rho[i]:=rho[i]+k*(f(ah,jk)+f(ah,jk1))
             end;
           d1:=mu[0];
           i:=-1;
           d2:=rho[0]/d1;
           rho[0]:=d2;
           repeat
             i:=i+1;
             e:=nu[i]/d1;
             nu[i]:=e;
             d1:=mu[i+1]-e*nu1[i+1];
             d2:=(rho[i+1]-d2*nu1[i+1])/d1;
             rho[i+1]:=d2;
           until i=n1;
           d1:=rho[n];
           u[n]:=d1;
           for i:=n1 downto 0 do
             begin
               d1:=rho[i]-d1*nu[i];
               u[i]:=d1
             end
         end
end;