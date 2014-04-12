procedure hyperdiff4 (n,j                 : Integer;
                      k                   : Extended;
                      a                   : coefficient;
                      phi1,phi2,psi1,psi2 : boundary;
                      var u,u1            : vector;
                      var st              : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure hyperdiff4 finds on the j-th level the solution of a       }
{  hyperbolic partial differential equation u|tt=a(x,t)u|xx, where          }
{  u=u(x,t), u|tt denotes the second order partial derivative of u with     }
{  respect to t, u|xx - with respect to x, 0<=x<=1, with the initial        }
{  conditions u(x,0)=phi1(x), u(x,0)|t=phi2(x) for 0<=x<=1, and boundary    }
{  conditions u(0,t)=psi1(y,t), u(1,t)=psi2(y,t) for t>0. The problem is    }
{  solved by a difference scheme of the fourth order. The adequate systems  }
{  of linear equations are solved by Crout's method.                        }
{  Data:                                                                    }
{    n         - number of subintervals in the interval [0,1],              }
{    j         - the level number (on which the solution should be found),  }
{    k         - step size in the t-axis direction, i.e. the difference     }
{                between two succeeding levels (it should be fulfilled the  }
{                condition 0<nk*sqrt(a)<1, where a=a(x,t) is the function   }
{                occurring in the differential equation),                   }
{    a         - a Turbo Pascal function which for given x and t calculates }
{                the value of function a=a(x,t) occurring in the            }
{                differential equation,                                     }
{    phi1,phi2 - Turbo Pascal functions which calculate the values of       }
{                functions phi1=phi1(x) and phi2=phi2(x) occurring in the   }
{                initial conditions (the functions phi1 and phi2 are called }
{                only in the case of j=1 or j=2),                           }
{    psi1,psi2 - Turbo Pascal functions which calculate the values of       }
{                functions psi1=psi1(t) and psi2=psi2(t) occuring in the    }
{                boundary conditions,                                       }
{    u         - an array containing the solution on the (j-1)-th level for }
{                j>1 (the element u[i] should contain the value of u at     }
{                x=ih and t=(j-1)k, where h=1/n and i=0,1,...,n),           }
{    u1        - an array containing the solution on the (j-2)-th level for }
{                j>2 (the element u1[i] should contain the value of u at    }
{                x=ih and t=(j-2)k, where h=1/n and i=0,1,...,n).           }
{                Note: If j=1, then the procedure uses the initial          }
{                      conditions instead of u and u1. If j=2, then the     }
{                      procedure uses the initial conditions and u (the     }
{                      elements of u are changed on exit). Finally, if j>2, }
{                      then the elements of u and u1 are changed on exit.   }
{  Results:                                                                 }
{    u  - an array containing approximate solutions on the j-th level (the  }
{         element u[i] contains the approximate solution at the point       }
{         (ih,jk); i=0,1,..,n),                                             }
{    u1 - an array containing approximate solutions on the (j-1)-th level   }
{         for j>1 (the element u1[i] contains the value of u[i] given on    }
{         entry; i=0,1,..,n).                                               }
{  Other parameters:                                                        }
{    st - a variable which within the procedure hyperdiff4 is assigned the  }
{         value of:                                                         }
{           1, if n<4 or j<1 or k<=0,                                       }
{           2, if a=a(x,t) is not a positive function,                      }
{           3, if the condition 0<nk*sqrt(a)<1, where a=a(x,t), is not      }
{              fulfilled (it means that the stability condition fails),     }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array u and u1 are not       }
{               changed on exit.                                            }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q0..qn], where      }
{                  q0<=0 and qn>=n,                                         }
{    vector1     - a type identifier of extended array [q1..qn1], where     }
{                  q1<=1 and qn1>=n-1,                                      }
{    coefficient - a procedural-type identifier defined as follows          }
{                    type coefficient = function (x,t : Extended)           }
{                                       : Extended;                         }
{    boundary    - a procedural-type identifier defined as follows          }
{                    type boundary = function (x : Extended) : Extended;    }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,n1,n2                          : Integer;
    h,i1h,i2h,ih,j1k,j2k,jk,nk,x,y,z : Extended;
    alpha,beta,d                     : vector1;
begin
  st:=0;
  if (n<4) or (j<1) or (k<=0)
    then st:=1
    else begin
           h:=1/n;
           nk:=n*k;
           jk:=j*k;
           j1k:=jk-k;
           i:=-1;
           repeat
             i:=i+1;
             ih:=i*h;
             x:=a(ih,jk);
             y:=a(ih,j1k);
             if (x<=0) or (y<=0)
               then st:=2
               else if (nk*sqrt(x)>=1) or (nk*sqrt(y)>=1)
                      then st:=3
           until (i=n) or (st=2) or (st=3)
         end;
  if st=0
    then begin
           n1:=n-1;
           n2:=n1-1;
           nk:=nk*nk;
           for i:=1 to n1 do
             begin
               ih:=i*h;
               x:=nk*a(ih,j1k);
               y:=1-x;
               alpha[i]:=2*(5+x)/y;
               beta[i]:=(1+5*x)/y
             end;
           if j=1
             then begin
                    for i:=1 to n1 do
                      begin
                        ih:=i*h;
                        i1h:=ih-h;
                        i2h:=ih+h;
                        d[i]:=beta[i]*(phi1(i1h)+phi1(i2h))+10*phi1(ih)
                              +k*(phi2(i1h)+alpha[i]*phi2(ih)+phi2(i2h))
                      end;
                    d[1]:=d[1]-psi1(k);
                    d[n1]:=d[n1]-psi2(k)
                  end
             else if j=2
                    then begin
                           for i:=1 to n1 do
                             begin
                               ih:=i*h;
                               d[i]:=20*u[i]-phi1(ih-h)-alpha[i]*phi1(ih)
                                     -phi1(ih+h)
                             end;
                           d[1]:=d[1]-psi1(2*k)+2*beta[1]*(psi1(k)+u[2]);
                           for i:=2 to n2 do
                             d[i]:=d[i]+2*beta[i]*(u[i-1]+u[i+1]);
                           d[n1]:=d[n1]+2*beta[n1]*(u[n2]+psi2(k))-psi2(2*k)
                         end
                    else begin
                           j2k:=j1k-k;
                           for i:=1 to n1 do
                             d[i]:=20*u[i]-alpha[i]*u1[i];
                           d[1]:=d[1]-psi1(jk)+2*beta[1]*(psi1(j1k)+u[2])
                                 -psi1(j2k)-u1[2];
                           for i:=2 to n2 do
                             d[i]:=d[i]+2*beta[i]*(u[i-1]+u[i+1])-u1[i-1]
                                   -u1[i+1];
                           d[n1]:=d[n1]-psi2(jk)+2*beta[n1]*(u[n2]+psi2(j1k))
                                  -u1[n2]-psi2(j2k)
                         end;
           for i:=1 to n2 do
             beta[i]:=1;
           x:=alpha[1];
           i:=0;
           y:=d[1]/x;
           d[1]:=y;
           repeat
             i:=i+1;
             z:=beta[i]/x;
             beta[i]:=z;
             x:=alpha[i+1]-z;
             y:=(d[i+1]-y)/x;
             d[i+1]:=y
           until i=n2;
           x:=d[n1];
           for i:=n2 downto 1 do
             begin
               x:=d[i]-x*beta[i];
               d[i]:=x
             end;
           for i:=0 to n do
             if j=1
               then u1[i]:=phi1(i*h)
               else u1[i]:=u[i];
           for i:=1 to n1 do
             u[i]:=d[i];
           u[0]:=psi1(jk);
           u[n]:=psi2(jk)
         end
end;