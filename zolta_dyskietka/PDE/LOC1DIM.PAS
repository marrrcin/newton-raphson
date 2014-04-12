procedure loc1dim (n,j                         : Integer;
                   k                           : Extended;
                   phi1,phi2,psi1,psi2,xi1,xi2 : boundary2;
                   mit                         : Integer;
                   eps                         : Extended;
                   var u,u1                    : matrix;
                   var it,st                   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure loc1dim calculates on the j-th level (with respect to t)   }
{  an approximate solution of the hyperbolic differential equation in two   }
{  space variables u|tt=u|xx+u|yy, where u=u(x,y), u|tt denotes the second  }
{  partial derivative of u with respect to x, u|xx - with respect to x,     }
{  u|yy - with respect to y, 0<=x<=1, 0<=y<=1, with the initial conditions  }
{  u(x,y,0)=phi1(x,y), u|t(x,y,0)=phi2(x,y) for 0<=x<=1, 0<=y<=1, and       }
{  boundary conditions u(0,y,t)=psi1(y,t), u(1,y,t)=psi2(y,t),              }
{  u(x,0,t)=xi1(x,t), u(x,1,t)=xi2(x,t) for t>0, where psi1(0,t)=xi1(0,t),  }
{  xi1(1,t)=psi2(0,t), psi2(1,t)=xi2(1,t), xi2(0,t)=psi1(1,t). In order to  }
{  solve this problem it is applied the Samarskii locally one-dimensional   }
{  method, and a system of linear equations occuring in the algorithm is    }
{  solved by the Gauss-Seidel iteration method.                             }
{  Data:                                                                    }
{    n                - number of subintervals in the interval [0,1],       }
{    j                - the level number (on which the solution should be   }
{                       found),                                             }
{    k                - step size in the t-axis direction, i.e. the         }
{                       distance between two succeeding levels,             }
{    phi1,phi2        - Turbo Pascal functions which calculate the values   }
{                       of functions phi1=phi1(x,y) and phi2=phi2(x,y)      }
{                       occurring in the initial conditions,                }
{    psi1,psi2,xi1,x2 - Turbo Pascal functions which calculate the values   }
{                       of functions psi1=psi1(y,t), psi2=psi2(y,t),        }
{                       xi1=xi1(x,t) and xi2=xi2(x,t) occurring in the      }
{                       boundary conditions,                                }
{    mit              - maximum number of iterations in the Gauss-Seidel    }
{                       method used for solving linear equations occurring  }
{                       in the algorithm,                                   }
{    eps              - relative accuracy of the solution,                  }
{    u                - an array containing the solution on the (j-1)-th    }
{                       level for j>1 (the element u[l,i] should contain    }
{                       the solution at the point (lh,ih,(j-1)k), where     }
{                       h=1/n and l,i=0,1,...,n),                           }
{    u1               - an array containing the solution on the (j-2)-th    }
{                       level for j>2 (the element u1[l,i] should contain   }
{                       the solution at the point (lh,ih,(j-2)k), where     }
{                       h=1/n and l,i=0,1,...,n).                           }
{                       Note: If j=1, then, in order to calculate an        }
{                             initial approximation to the solution on the  }
{                             j-th level, the procedure uses the initial    }
{                             condition instead of u. If j>1, then the      }
{                             procedure uses u as initial approximations to }
{                             the solution on the j-th level (the elements  }
{                             of u are changed on exit). If j>2, then the   }
{                             elements of both arrays (u and u1) are        }
{                             changed on exit.                              }
{  Results:                                                                 }
{    u  - an array containing approximate solutions on the j-th level (the  }
{         element u[l,i] contains the approximate solution at the point     }
{         (lh,ih,jk), where h=1/n and l,i=0,1,...,n),                       }
{    u1 - an array containing the solutions on the (j-1)-th level (for j>1  }
{         the element u1[l,i] contains the value of u[l,i] given on entry,  }
{         and for j=1 - the value of phi1(l*h,i*h), where h=1/n and         }
{         l,i=0,1,...,n,                                                    }
{    it - number of iterations in the Gauss-Seidel method.                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure loc1dim is assigned the     }
{         value of:                                                         }
{           1, if n<4 or j<1 or k<=0 or mit<1 or eps<=0,                    }
{           2, if at least one of the conditions psi1(0,t)=xi1(0,t),        }
{              xi1(1,t)=psi2(0,t), psi2(1,t)=xi2(1,t), xi2(0,t)=psi1(1,t)   }
{              is not fulfilled (it means that the boundary conditions are  }
{              wrong),                                                      }
{           3, if the desired accuracy of the solution is not achieved in   }
{              mit iteration steps,                                         }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then the elements of array u are not       }
{               changed on exit, and if st=3, then u contains the last      }
{               approximation found.                                        }
{  Unlocal identifiers:                                                     }
{    vector    - a type identifier of extended array [q1..qn1], where q1<=1 }
{                and qn1>=(n-1)*(n-1),                                      }
{    matrix    - a type identifier of extended array [q0..qn,q0..qn], where }
{                q0<=0 and qn>=n,                                           }
{    boundary2 - a procedural-type identifier defined as follows            }
{                  type boundary2 = function (x,y : Extended) : Extended;   }
{  Notes: 1) Any function passed as a parameter should be declared with a   }
{            far directive or compiled in the $F+ state.                    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
const null=0.0e0;
      one=1.0e0;
var i,i1,i2,j1,j2,l,l1,l2,n1,n1sqr,n2,nl : Integer;
    a,alpha,alps,alsqr,b,c,ih,ih1,ih2,
    jk,jk1,jk2,lh,lh1,lh2,h,hsqr,max,v,w : Extended;
    t,x,x1                               : vector;
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
           then boundconds:=2
end {boundconds};
begin
  st:=0;
  if (n<4) or (j<1) or (k<=0) or (mit<1) or (eps<=0)
    then st:=1
    else
      begin
        jk:=j*k;
        st:=boundconds(psi1(null,jk),xi1(null,jk));
        if st=0 then
          begin
            st:=boundconds(xi1(one,jk),psi2(one,jk));
            if st=0 then
              begin
                st:=boundconds(psi2(one,jk),xi2(one,jk));
                if st=0 then
                  begin
                    st:=boundconds(xi2(null,jk),psi1(one,jk));
                    if (st=0) and (j>1) then
                      begin
                        jk:=(j-1)*k;
                        st:=boundconds(psi1(null,jk),xi1(null,jk));
                        if st=0 then
                          begin
                            st:=boundconds(xi1(one,jk),psi2(one,jk));
                            if st=0 then
                              begin
                                st:=boundconds(psi2(one,jk),xi2(one,jk));
                                if st=0 then st:=boundconds(xi2(null,jk),
                                                            psi1(one,jk))
                              end
                          end
                      end
                  end
              end
          end
      end;
  if st=0
    then begin
           h:=1/n;
           hsqr:=h*h;
           n1:=n-1;
           n1sqr:=n1*n1;
           n2:=n1-1;
           alps:=sqr(k/h);
           alpha:=2*(1+2/alps);
           alsqr:=alpha*alpha;
           alps:=alsqr-32/sqr(alps);
           if j=1
             then for l:=1 to n1 do
                    begin
                      nl:=n1*(l-1);
                      lh:=l*h;
                      lh1:=lh-h;
                      lh2:=lh+h;
                      for i:=1 to n1 do
                        begin
                          ih:=i*h;
                          ih1:=ih-h;
                          ih2:=ih+h;
                          v:=-phi1(lh1,ih1);
                          v:=v-phi1(lh1,ih2);
                          v:=v-alps*phi1(lh,ih);
                          v:=v-phi1(lh2,ih1);
                          v:=v-phi1(lh2,ih2);
                          w:=phi1(lh1,ih);
                          w:=w+phi1(lh,ih1);
                          w:=w+phi1(lh,ih2);
                          w:=w+phi1(lh2,ih);
                          v:=v+alpha*w;
                          w:=phi2(lh1,ih);
                          w:=w+phi2(lh,ih1);
                          w:=w+phi2(lh,ih2);
                          w:=-alpha*(w+phi2(lh2,ih));
                          w:=w+phi2(lh1,ih1);
                          w:=w+phi2(lh1,ih2);
                          w:=w+alsqr*phi2(lh,ih);
                          w:=w+phi2(lh2,ih1);
                          w:=w+phi2(lh2,ih2);
                          t[nl+i]:=v-k*w
                        end
                    end
             else if j=2
                    then begin
                           for l:=1 to n1 do
                             begin
                               nl:=n1*(l-1);
                               lh:=l*h;
                               lh1:=lh-h;
                               lh2:=lh+h;
                               for i:=1 to n1 do
                                 begin
                                   ih:=i*h;
                                   ih1:=ih-h;
                                   ih2:=ih+h;
                                   v:=-phi1(lh1,ih1);
                                   v:=v-phi1(lh1,ih2);
                                   v:=v-alsqr*phi1(lh,ih);
                                   v:=v-phi1(lh2,ih1);
                                   v:=v-phi1(lh2,ih2);
                                   w:=phi1(lh1,ih);
                                   w:=w+phi1(lh,ih1);
                                   w:=w+phi1(lh,ih2);
                                   w:=w+phi1(lh2,ih);
                                   t[nl+i]:=v+alpha*w
                                 end
                             end;
                           lh:=2*h;
                           v:=-psi1(null,k);
                           v:=v-psi1(lh,k);
                           v:=v-xi1(lh,k);
                           v:=v-alps*u[1,1]-u[2,2];
                           w:=psi1(h,k);
                           w:=w+xi1(h,k);
                           w:=alpha*(w+u[1,2]+u[2,1]);
                           t[1]:=t[1]+2*(v+w);
                           for i:=2 to n2 do
                             begin
                               i1:=i-1;
                               i2:=i+1;
                               ih:=i*h;
                               ih1:=ih-h;
                               ih2:=ih+h;
                               v:=-psi1(ih1,k);
                               v:=v-psi1(ih2,k);
                               v:=v-alps*u[1,i]-u[2,i1]-u[2,i2];
                               w:=psi1(ih,k);
                               w:=alpha*(w+u[1,i1]+u[1,i2]+u[2,i]);
                               t[i]:=t[i]+2*(v+w)
                             end;
                           ih:=n1*h;
                           ih1:=ih-h;
                           ih2:=ih+h;
                           v:=-psi1(ih1,k);
                           v:=v-psi1(ih2,k);
                           v:=v-xi2(lh,k);
                           v:=v-alps*u[1,n1]-u[2,n2];
                           w:=psi1(ih,k);
                           w:=w+xi2(h,k);
                           w:=alpha*(w+u[1,n2]+u[2,n1]);
                           t[n1]:=t[n1]+2*(v+w);
                           for l:=2 to n2 do
                             begin
                               l1:=l-1;
                               l2:=l+1;
                               nl:=n1*l1;
                               lh:=l*h;
                               lh1:=lh-h;
                               lh2:=lh+h;
                               v:=-xi1(lh1,k);
                               v:=v-xi1(lh2,k);
                               v:=v-u[l1,2]-alps*u[l,1]-u[l2,2];
                               w:=xi1(lh,k);
                               w:=alpha*(w+u[l1,1]+u[l,2]+u[l2,1]);
                               t[nl+1]:=t[nl+1]+2*(v+w);
                               for i:=2 to n2 do
                                 begin
                                   i1:=i-1;
                                   i2:=i+1;
                                   ih:=i*h;
                                   ih1:=ih-h;
                                   ih2:=ih+h;
                                   v:=-u[l1,i1]-u[l1,i2]-alps*u[l,i]
                                      -u[l2,i1]-u[l2,i2];
                                   w:=alpha*(u[l1,i]+u[l,i1]+u[l,i2]
                                      +u[l2,i]);
                                   t[nl+i]:=t[nl+i]+2*(v+w)
                                 end;
                               v:=-xi2(lh1,k);
                               v:=v-xi2(lh2,k);
                               v:=v-u[l1,n2]-alps*u[l,n1]-u[l2,n2];
                               w:=xi2(lh,k);
                               w:=alpha*(w+u[l1,n1]+u[l,n2]+u[l2,n1]);
                               t[nl+n1]:=t[nl+n1]+2*(v+w)
                             end;
                           nl:=n1*n2;
                           v:=-xi1(n2*h,k);
                           v:=v-xi1(n*h,k);
                           v:=v-psi2(2*h,k);
                           v:=v-u[n2,2]-alps*u[n1,1];
                           w:=xi1(n1*h,k);
                           w:=w+psi2(h,k);
                           w:=alpha*(w+u[n2,1]+u[n1,2]);
                           t[nl+1]:=t[nl+1]+2*(v+w);
                           for i:=2 to n2 do
                             begin
                               i1:=i-1;
                               i2:=i+1;
                               ih:=i*h;
                               v:=-psi2(ih-h,k);
                               v:=v-psi2(ih+h,k);
                               v:=v-u[n2,i1]-u[n2,i2]-alps*u[n1,i];
                               w:=psi2(ih,k);
                               w:=alpha*(w+u[n2,i]+u[n1,i1]+u[n1,i2]);
                               t[nl+i]:=t[nl+i]+2*(v+w)
                             end;
                           ih:=n1*h;
                           ih1:=ih-h;
                           v:=-xi2(ih1,k);
                           v:=v-psi2(ih1,k);
                           v:=v-psi2(n*h,k);
                           v:=v-u[n2,n2]-alps*u[n1,n1];
                           w:=xi2(ih,k);
                           w:=w+psi2(ih,k);
                           w:=alpha*(w+u[n2,n1]+u[n1,n2]);
                           t[nl+n1]:=t[nl+n1]+2*(v+w)
                         end
                    else begin
                           j1:=j-1;
                           j2:=j-2;
                           jk1:=j1*k;
                           jk2:=j2*k;
                           lh:=2*h;
                           v:=-psi1(null,jk1);
                           v:=v-psi1(lh,jk1);
                           v:=v-xi1(lh,jk1);
                           v:=v-alps*u[1,1]-u[2,2];
                           w:=psi1(h,jk1);
                           w:=w+xi1(h,jk1);
                           w:=alpha*(w+u[1,2]+u[2,1]);
                           v:=2*(v+w);
                           v:=v-psi1(null,jk2);
                           v:=v-psi1(lh,jk2);
                           v:=v-xi1(lh,jk2);
                           v:=v-alsqr*u1[1,1]-u1[2,2];
                           w:=psi1(h,jk2);
                           w:=w+xi1(h,jk2);
                           t[1]:=v+alpha*(w+u1[1,2]+u1[2,1]);
                           for i:=2 to n2 do
                             begin
                               i1:=i-1;
                               i2:=i+1;
                               ih:=i*h;
                               ih1:=ih-h;
                               ih2:=ih+h;
                               v:=-psi1(ih1,jk1);
                               v:=v-psi1(ih2,jk1);
                               v:=v-alps*u[1,i]-u[2,i1]-u[2,i2];
                               w:=psi1(ih,jk1);
                               w:=alpha*(w+u[1,i1]+u[1,i2]+u[2,i]);
                               v:=2*(v+w);
                               v:=v-psi1(ih1,jk2);
                               v:=v-psi1(ih2,jk2);
                               v:=v-alsqr*u1[1,i]-u1[2,i1]-u1[2,i2];
                               w:=psi1(ih,jk2);
                               t[i]:=v+alpha*(w+u1[1,i1]+u1[1,i2]+u1[2,i])
                             end;
                           ih:=n1*h;
                           ih1:=ih-h;
                           ih2:=ih+h;
                           v:=-psi1(ih1,jk1);
                           v:=v-psi1(ih2,jk1);
                           v:=v-xi2(lh,jk1);
                           v:=v-alps*u[1,n1]-u[2,n2];
                           w:=psi1(ih,jk1);
                           w:=w+xi2(h,jk1);
                           w:=alpha*(w+u[1,n2]+u[2,n1]);
                           v:=2*(v+w);
                           v:=v-psi1(ih1,jk2);
                           v:=v-psi1(ih2,jk2);
                           v:=v-xi2(lh,jk2);
                           v:=v-alsqr*u1[1,n1]-u1[2,n2];
                           w:=psi1(ih,jk2);
                           w:=w+xi2(h,jk2);
                           t[n1]:=v+alpha*(w+u1[1,n2]+u1[2,n1]);
                           for l:=2 to n2 do
                             begin
                               l1:=l-1;
                               l2:=l+1;
                               nl:=n1*l1;
                               lh:=l*h;
                               lh1:=lh-h;
                               lh2:=lh+h;
                               v:=-xi1(lh1,jk1);
                               v:=v-xi1(lh2,jk1);
                               v:=v-u[l1,2]-alps*u[l,1]-u[l2,2];
                               w:=xi1(lh,jk1);
                               w:=alpha*(w+u[l1,1]+u[l,2]+u[l2,1]);
                               v:=2*(v+w);
                               v:=v-xi1(lh1,jk2);
                               v:=v-xi1(lh2,jk2);
                               v:=v-u1[l1,2]-alsqr*u1[l,1]-u1[l2,2];
                               w:=xi1(lh,jk2);
                               t[nl+1]:=v+alpha*(w+u1[l1,1]+u1[l,2]
                                        +u1[l2,1]);
                               for i:=2 to n2 do
                                 begin
                                   i1:=i-1;
                                   i2:=i+1;
                                   ih:=i*h;
                                   ih1:=ih-h;
                                   ih2:=ih+h;
                                   v:=-u[l1,i1]-u[l1,i2]-alps*u[l,i]
                                      -u[l2,i1]-u[l2,i2];
                                   w:=u[l1,i]+u[l,i1]+u[l,i2]+u[l2,i];
                                   v:=2*(v+alpha*w);
                                   v:=v-u1[l1,i1]-u1[l1,i2]-alsqr*u1[l,i]
                                      -u1[l2,i1]-u1[l2,i2];
                                   w:=u1[l1,i]+u1[l,i1]+u1[l,i2]+u1[l2,i];
                                   t[nl+i]:=v+alpha*w
                                 end;
                               v:=-xi2(lh1,jk1);
                               v:=v-xi2(lh2,jk1);
                               v:=v-u[l1,n2]-alps*u[l,n1]-u[l2,n2];
                               w:=xi2(lh,jk1);
                               w:=w+u[l1,n1]+u[l,n2]+u[l2,n1];
                               v:=2*(v+alpha*w);
                               v:=v-xi2(lh1,jk2);
                               v:=v-xi2(lh2,jk2);
                               v:=v-u1[l1,n2]-alsqr*u1[l,n1]-u1[l2,n2];
                               w:=xi2(lh,jk2);
                               w:=w+u1[l1,n1]+u1[l,n2]+u1[l2,n1];
                               t[nl+n1]:=v+alpha*w
                             end;
                           nl:=n1*n2;
                           lh:=n1*h;
                           lh1:=lh-h;
                           lh2:=lh+h;
                           v:=-xi1(lh1,jk1);
                           v:=v-xi1(lh2,jk1);
                           v:=v-psi2(2*h,jk1);
                           v:=v-u[n2,2]-alps*u[n1,1];
                           w:=xi1(lh,jk1);
                           w:=w+psi2(h,jk1);
                           v:=2*(v+alpha*(w+u[n2,1]+u[n1,2]));
                           v:=v-xi1(lh1,jk2);
                           v:=v-xi1(lh2,jk2);
                           v:=v-psi2(2*h,jk2);
                           v:=v-u1[n2,2]-alsqr*u1[n1,1];
                           w:=xi1(lh,jk2);
                           w:=w+psi2(h,jk2);
                           t[nl+1]:=v+alpha*(w+u1[n2,1]+u1[n1,2]);
                           for i:=2 to n2 do
                             begin
                               i1:=i-1;
                               i2:=i+1;
                               ih:=i*h;
                               ih1:=ih-h;
                               ih2:=ih+h;
                               v:=-psi2(ih1,jk1);
                               v:=v-psi2(ih2,jk1);
                               v:=v-u[n2,i1]-u[n2,i2]-alps*u[n1,i];
                               w:=psi2(ih,jk1);
                               w:=w+alpha*(w+u[n2,i]+u[n1,i1]+u[n1,i2]);
                               v:=2*(v+w);
                               v:=v-psi2(ih1,jk2);
                               v:=v-psi2(ih2,jk2);
                               v:=v-u1[n2,i1]-u1[n2,i2]-alsqr*u1[n1,i];
                               w:=psi2(ih,jk2);
                               t[nl+i]:=v+alpha*(w+u1[n2,i]+u1[n1,i1]
                                        +u1[n1,i2])
                             end;
                           v:=-xi2(lh1,jk1);
                           v:=v-psi2(lh1,jk1);
                           v:=v-psi2(lh2,jk1);
                           v:=v-u[n2,n2]-alps*u[n1,n1];
                           w:=xi2(lh,jk1);
                           w:=w+psi2(lh,jk1);
                           v:=2*(v+alpha*(w+u[n2,n1]+u[n1,n2]));
                           v:=v-xi2(lh1,jk2);
                           v:=v-psi2(lh1,jk2);
                           v:=v-psi2(lh2,jk2);
                           v:=v-u1[n2,n2]-alsqr*u1[n1,n1];
                           w:=xi2(lh,jk2);
                           w:=w+psi2(lh,jk2);
                           t[nl+n1]:=v+alpha*(w+u1[n2,n1]+u1[n1,n2])
                         end;
           st:=3;
           for l:=1 to n1 do
             for i:=1 to n1 do
               begin
                 nl:=n1*(l-1)+i;
                 if j=1
                   then x[nl]:=phi1(l*h,i*h)
                   else x[nl]:=u1[l,i]
               end;
           it:=0;
           repeat
             it:=it+1;
             x1[1]:=(alpha*(x[2]+x[n])-x[n+1]+t[1])/alsqr;
             for i:=2 to n2 do
               x1[i]:=(alpha*(x1[i-1]+x[i+1]+x[n1+i])-x[n2+i]-x[n+i]+t[i])
                      /alsqr;
             x1[n1]:=(alpha*(x1[n2]+x[n1+n1])-x[n1+n2]+t[n1])/alsqr;
             for l:=2 to n2 do
               begin
                 nl:=n1*(l-1);
                 x1[nl+1]:=(alpha*(x1[nl-n2]+x[nl+2]+x[nl+n])-x1[nl-n1+2]
                           -x[nl+n1+2]+t[nl+1])/alsqr;
                 for i:=2 to n2 do
                   begin
                     i1:=nl+i;
                     w:=alpha*(x1[i1-n1]+x1[i1-1]+x[i1+1]+x[i1+n1]);
                     x1[i1]:=(w-x1[i1-n]-x1[i1-n2]-x[i1+n2]-x[i1+n]+t[i1])
                             /alsqr
                   end;
                 x1[nl+n1]:=(alpha*(x1[nl]+x1[nl+n2]+x[nl+n2+n])-x1[nl-1]
                            -x[nl+n1+n2]+t[nl+n1])/alsqr
               end;
             nl:=n1*n2;
             x1[nl+1]:=(alpha*(x1[nl-n2]+x[nl+2])-x[nl-n1+2]+t[nl+1])/alsqr;
             for i:=2 to n2 do
               begin
                 i1:=nl+i;
                 x1[i1]:=(alpha*(x1[i1-n1]+x1[i1-1]+x[i1+1])-x1[i1-n]
                         -x1[i1-n2]+t[i1])/alsqr
               end;
             x1[n1sqr]:=(alpha*(x1[nl]+x1[nl+n2])-x1[nl-1]+t[n1sqr])/alsqr;
             max:=0;
             for i:=1 to n1sqr do
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
             for i:=1 to n1sqr do
               x[i]:=x1[i]
           until (it=mit) or (st=0);
           for l:=0 to n do
             for i:=0 to n do
               if j=1
                 then u1[l,i]:=phi1(l*h,i*h)
                 else u1[l,i]:=u[l,i];
           for nl:=1 to n1sqr do
             begin
               l:=trunc((nl-1)/n1)+1;
               i:=nl-n1*(l-1);
               u[l,i]:=x[nl]
             end;
           for i:=0 to n do
             begin
               ih:=i*h;
               u[0,i]:=psi1(ih,jk);
               u[n,i]:=psi2(ih,jk)
             end;
           for l:=1 to n1 do
             begin
               lh:=l*h;
               u[l,0]:=xi1(lh,jk);
               u[l,n]:=xi2(lh,jk)
             end
         end
end;