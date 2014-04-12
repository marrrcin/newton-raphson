procedure ellipticdiff2 (n,m                 : Integer;
                         alpha,beta          : Extended;
                         f                   : coefficient;
                         phi1,phi2,phi3,phi4 : boundary;
                         mit                 : Integer;
                         eps                 : Extended;
                         var u               : matrix;
                         var it,st           : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure ellipticdiff2 solves an elliptic partial differential      }
{  equation -u|xx-u|yy=f(x,y), where u=u(x,y), u|xx denotes the second      }
{  partial derivative of u with respect to x, u|yy - with respect to y,     }
{  0<=x<=alpha, 0<=y<=beta, with the boundary conditions u=phi1(y) for x=0, }
{  u=phi2(x) for y=0, u=phi3(y) for x=alpha, u=phi4(x) for y=beta, where    }
{  phi1(0)=phi2(0), phi2(alpha)=phi3(0), phi3(beta)=phi4(alpha),            }
{  phi4(0)=phi1(beta). In order to solve this problem it is applied a       }
{  difference scheme of the second order.                                   }
{  Data:                                                                    }
{    n                   - number of subintervals in the interval           }
{                          [0,alpha],                                       }
{    m                   - number of subintervals in the interval           }
{                          [0,beta],                                        }
{    alpha               - maximum value of x,                              }
{    beta                - maximum value of y,                              }
{    f                   - a Turbo Pascal function which calculates the     }
{                          value of the function f=f(x,y) occurring on the  }
{                          right-hand side of the differential equation,    }
{    phi1,phi2,phi3,phi4 - Turbo Pascal functions which calculate the       }
{                          values of functions phi1=phi1(y), phi2=phi2(x),  }
{                          phi3=phi3(y) and phi4=phi4(x) occurring in       }
{                          the boundary conditions,                         }
{    mit                 - maximum number of iterations in the Gauss-Seidel }
{                          method for solving linear equations occurring in }
{                          the algorithm,                                   }
{    eps                 - relative accuracy of the solution.               }
{                          Note: Within the procedure ellipticdiff2 it is   }
{                                assumed that the initial approximation to  }
{                                the solution at each point is equal to     }
{                                  (phi1(beta/2)+phi2(alpha/2)+phi3(beta/2) }
{                                  +phi4(alpha/2)/4.                        }
{  Results:                                                                 }
{    u  - an array containing the solution (the element u[i,j] contains the }
{         solution at the point (ih,jk), where i=0,1,...,n, j=0,1,...,m,    }
{         h=alpha/n, k=beta/m,                                              }
{    it - number of iterations in the Gauss-Seidel method.                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure ellipticdiff2 is assigned   }
{         the value of:                                                     }
{           1, if n<4 or m<4 or mit<1 or eps<=0,                            }
{           2, if alpha<=0 or beta<=0,                                      }
{           3, if at least one of the conditions phi1(0)=phi2(0),           }
{              phi2(alpha)=phi3(0), phi3(beta)=phi4(alpha),                 }
{              phi4(0)=phi1(beta) is not fulfilled (that means the boundary }
{              conditions are wrong),                                       }
{           4, if the desired accuracy of the solution is not achieved in   }
{              mit iteration steps,                                         }
{           0, otherwise.                                                   }
{         Note: If st=1,2 or 3, then the elements of array u are not        }
{               calculated, and if st=4, then u contains the last           }
{               approximation found.                                        }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q1..qn1m1], where   }
{                  q1<=1 and qn1m1>=(n-1)*(m-1),                            }
{    matrix      - a type identifier of extended array [q0..qn,q0..qm],     }
{                  where q0<=0, qn>=n and qm>=m,                            }
{    coefficient - a procedural-type identifier defined as follows          }
{                    type coefficient = function (x,y : Extended)           }
{                                       : Extended;                         }
{    boundary    - a procedural-type identifier defined as follows          }
{                    type boundary = function (x: Extended) : Extended;     }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k,l,m1,m2,mi,mij,mn,n1,n2         : Integer;
    a,b,c,ih,jh,h1,h1sqr,h2,h2sqr,max,v,w : Extended;
    t,x,x1                                : vector;
function boundconds (b1,b2 : Extended) : Integer;
var u,v : Extended;
begin
  u:=abs(b1);
  v:=abs(b2);
  if u<v
    then u:=v;
  boundconds:=0;
  if u<>0
    then if abs(b1-b2)/u>=1.0e-14
           then boundconds:=3
end {boundconds};
begin
  st:=0;
  if (n<4) or (m<4) or (mit<1) or (eps<=0)
    then st:=1
    else if (alpha<=0) or (beta<=0)
           then st:=2
           else begin
                  st:=boundconds(phi1(0.0e0),phi2(0.0e0));
                  if st=0
                    then begin
                           st:=boundconds(phi2(alpha),phi3(0.0e0));
                           if st=0
                             then begin
                                    st:=boundconds(phi3(beta),phi4(alpha));
                                    if st=0
                                      then st:=boundconds(phi4(0.0e0),
                                                          phi1(beta))
                                  end
                         end
                end;
  if st=0
    then begin
           h1:=alpha/n;
           h2:=beta/m;
           h1sqr:=h1*h1;
           h2sqr:=h2*h2;
           n1:=n-1;
           n2:=n1-1;
           m1:=m-1;
           m2:=m1-1;
           for i:=1 to n1 do
             begin
               mi:=m1*(i-1);
               ih:=i*h1;
               for j:=1 to m1 do
                 begin
                   jh:=j*h2;
                   v:=f(ih-h1,jh);
                   v:=v+f(ih,jh-h2);
                   v:=v+8*f(ih,jh);
                   v:=v+f(ih,jh+h2);
                   t[mi+j]:=v+f(ih+h1,jh)
                 end
             end;
           a:=(h1sqr+h2sqr)/(h1sqr*h2sqr);
           c:=2*a;
           b:=12/h1sqr-c;
           c:=12/h2sqr-c;
           v:=phi2(0.0e0)+phi1(2*h2);
           v:=a*(v+phi2(2*h1))+b*phi1(h2);
           t[1]:=t[1]+v+c*phi2(h1);
           for j:=2 to m2 do
             begin
               jh:=j*h2;
               v:=a*(phi1(jh-h2)+phi1(jh+h2));
               t[j]:=t[j]+v+b*phi1(jh);
             end;
           v:=phi1(beta-2*h2)+phi1(beta);
           v:=a*(v+phi4(2*h1))+b*phi1(beta-h2);
           t[m1]:=t[m1]+v+c*phi4(h1);
           for i:=2 to n2 do
             begin
               mi:=m1*(i-1);
               ih:=i*h1;
               v:=a*(phi2(ih-h1)+phi2(ih+h1));
               t[mi+1]:=t[mi+1]+v+c*phi2(ih);
               v:=a*(phi4(ih-h1)+phi4(ih+h1));
               t[mi+m1]:=t[mi+m1]+v+c*phi4(ih)
             end;
           mi:=m1*n2;
           v:=phi2(alpha-2*h1)+phi2(alpha);
           v:=a*(v+phi3(2*h2))+c*phi2(alpha-h1);
           t[mi+1]:=t[mi+1]+v+b*phi3(h2);
           for j:=2 to m2 do
             begin
               jh:=j*h2;
               v:=a*(phi3(jh-h2)+phi3(jh+h2));
               t[mi+j]:=t[mi+j]+v+b*phi3(jh)
             end;
           v:=phi4(alpha-2*h1)+phi3(beta-2*h2);
           v:=a*(v+phi3(beta))+c*phi4(alpha-h1);
           t[mi+m1]:=t[mi+m1]+v+b*phi3(beta-h1);
           st:=4;
           mn:=m1*n1;
           v:=phi1(beta/2)+phi2(alpha/2);
           v:=(v+phi3(beta/2)+phi4(alpha/2))/4;
           for k:=1 to mn do
             x[k]:=v;
           it:=0;
           repeat
             it:=it+1;
             v:=20*a;
             x1[1]:=(c*x[2]+b*x[m]+a*x[m+1]+t[1])/v;
             for j:=2 to m2 do
               x1[j]:=(c*(x1[j-1]+x[j+1])+a*(x[m2+j]+x[m1+j+1])+b*x[m1+j]
                      +t[j])/v;
             x1[m1]:=(c*x1[m2]+a*x[m1+m2]+b*x[m1+m1]+t[m1])/v;
             for i:=2 to n2 do
               begin
                 mi:=m1*(i-1);
                 x1[mi+1]:=(b*(x1[mi-m2]+x[mi+m])+a*(x1[mi-m1+2]+x[mi+m+1])
                           +c*x[mi+2]+t[mi+1])/v;
                 for j:=2 to m2 do
                   begin
                     mij:=mi+j;
                     w:=a*(x1[mij-m]+x1[mij-m2]+x[mij+m2]+x[mij+m]);
                     x1[mij]:=(w+b*(x1[mij-m1]+x[mij+m1])+c*(x1[mij-1]
                              +x[mij+1])+t[mij])/v
                   end;
                 x1[mi+m1]:=(a*(x1[mi-1]+x[mi+m1+m2])+b*(x1[mi]+x[mi+2*m1])
                            +c*x1[mi+m2]+t[mi+m1])/v
               end;
             mi:=m1*n2;
             x1[mi+1]:=(b*x1[mi-m2]+a*x1[mi-m2+1]+c*x[mi+2]+t[mi+1])/v;
             for j:=2 to m2 do
               begin
                 mij:=mi+j;
                 x1[mij]:=(a*(x1[mij-m]+x1[mij-m2])+b*x1[mij-m1]
                          +c*(x1[mij-1]+x[mij+1])+t[mij])/v
               end;
             x1[mi+m1]:=(a*x1[mi-1]+b*x1[mi]+c*x1[mi+m2]+t[mi+m1])/v;
             max:=0;
             for i:=1 to mn do
               begin
                 v:=abs(x[i]);
                 w:=abs(x1[i]);
                 if v<w
                   then v:=w;
                 if v<>0
                   then begin
                          v:=abs(x[i]-x1[i])/v;
                          if v>max
                            then max:=v
                        end
               end;
             if max<=eps
               then st:=0;
             for i:=1 to mn do
               x[i]:=x1[i]
           until (it=mit) or (st=0);
           for k:=1 to mn do
             begin
               i:=trunc((k-1)/n1)+1;
               j:=k-m1*(i-1);
               u[i,j]:=x[k]
             end;
           for i:=0 to n do
             begin
               ih:=i*h1;
               u[i,0]:=phi2(ih);
               u[i,m]:=phi4(ih)
             end;
           for j:=1 to m1 do
             begin
               jh:=j*h2;
               u[0,j]:=phi1(jh);
               u[n,j]:=phi3(jh)
             end
         end
end;