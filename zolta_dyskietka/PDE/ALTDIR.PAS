procedure altdirection (n,j                   : Integer;
                        k                     : Extended;
                        phi,psi1,psi2,xi1,xi2 : boundary2;
                        var u                 : matrix;
                        var st                : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure altdirection finds on the j-th level the solution of a     }
{  parabolic partial differential equation u|t=u|xx+u|yy, where u=u(x,t),   }
{  u|t denotes the partial derivative of u with respect to t, u|xx - the    }
{  second order partial derivative of u with respect to x, and u|yy - with  }
{  respect to y, 0<=x<=1, 0<=y<=1, with the initial condition               }
{  u(x,y,0)=phi(x,y) for 0<=x<=1, 0<=y<=1, and boundary conditions          }
{  u(0,y,t)=psi1(y,t), u(1,y,t)=psi2(y,t) for 0<=y<=1, t>0, and             }
{  u(x,0,t)=xi1(x,t), u(x,1,t)=xi2(x,t) for 0<=x<=1, t>0 (it must be        }
{  fulfilled the conditions psi1(0,t)=xi1(0,t), xi1(1,t)=psi2(0,t),         }
{  psi2(1,t)=xi2(1,t), xi2(0,t)=psi1(1,t)). The problem is solved by the    }
{  Peaceman-Rachford alternating direction implicit method. The adequate    }
{  systems of linear equations are solved by Crout's method.                }
{  Data:                                                                    }
{    n                 - number of subintervals in the interval 0<=x<=1     }
{                        (which is equal to the number of subintervals in   }
{                        the interval 0<=y<=1),                             }
{    j                 - the level number (on which the solution should be  }
{                        found),                                            }
{    k                 - step size in the t-axis direction, i.e. the        }
{                        difference between the (j-1)-th and j-th level,    }
{    phi               - a Turbo Pascal function which calculates the value }
{                        of function phi=phi(x,y) occurring in the initial  }
{                        condition (the function phi is called only in the  }
{                        case of j=1),                                      }
{    psi1,psi2,xi1,xi2 - Turbo Pascal functions which calculate the values  }
{                        of functions psi1=psi1(y,t), psi2=psi2(y,t),       }
{                        xi1=xi1(x,t) and xi2=xi2(x,t) occuring in the      }
{                        boundary conditions,                               }
{    u                 - an array containing the solution on the (j-1)-th   }
{                        level for j>1 (the element u[l,i] should contain   }
{                        the value of u at x=lh and y=ih, where h=1/n and   }
{                        i=0,1,...,n).                                      }
{                        Note: If j=1, then the procedure uses the initial  }
{                              condition instead of u. If j>1, then the     }
{                              elements of u are changed on exit.           }
{  Result:                                                                  }
{    u - an array containing approximate solutions on the j-th level (the   }
{        element u[l,i] contains the approximate solution at the point      }
{        (lh,ih,jk); l,i=0,1,..,n).                                         }
{  Other parameters:                                                        }
{    st - a variable which within the procedure altdirection is assigned    }
{         the value of:                                                     }
{           1, if n<4 or j<1,                                               }
{           2, if at least one of the conditions psi1(0,t)=xi1(0,t),        }
{              xi1(1,t)=psi2(0,t), psi2(1,t)=xi2(1,t), xi2(0,t)=psi1(1,t),  }
{              where t=(j-1)k,(j-1/2)k,jk, is not fulfilled (it means that  }
{              the boundary conditions are wrong),                          }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then the elements of array u are not       }
{               changed on exit.                                            }
{  Unlocal identifiers:                                                     }
{    vector    - a type identifier of extended array [q1..qn1], where q1<=1 }
{                and qn1>=(n-1)*(n-1),                                      }
{    vector1   - a type identifier of extended array [q1..qn11], where      }
{                q1<=1 and qn11>=(n-1)*(n-1)-1,                             }
{    matrix    - a type identifier of extended array [q0..qn,q0..qn], where }
{                q0<=0 and qn>=n,                                           }
{    boundary2 - a procedural-type identifier defined as follows            }
{                  type boundary2 = function (x,t : Extended) : Extended;   }
{  Notes: 1) Any function passed as a parameter should be declared with a   }
{            far directive or compiled in the $F+ state.                    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
const one  = 1.0e0;
      null = 0.0e0;
var i,i1,i2,n1,n1sqr,n2           : Integer;
    alpha,beta,h,j1k,j12k,jk,lh,r : Extended;
    d                             : vector;
procedure Crout (var d : vector);
var i     : Integer;
    x,y,z : Extended;
    b     : vector1;
begin
  x:=alpha;
  for i:=1 to n1sqr-1 do
    if int(i/n1)=i/n1
      then b[i]:=0
      else b[i]:=-1;
  i:=0;
  y:=d[1]/x;
  d[1]:=y;
  repeat
    i:=i+1;
    z:=b[i]/x;
    b[i]:=z;
    if int(j/n1)=j/n1
      then x:=alpha
      else x:=alpha+z;
    if int(i/n1)=i/n1
      then y:=d[i+1]/x
      else y:=(d[i+1]+y)/x;
    d[i+1]:=y
  until i=n1sqr-1;
  x:=d[n1sqr];
  for i:=n1sqr-1 downto 1 do
    begin
      x:=d[i]-x*b[i];
      d[i]:=x
    end
end {Crout};
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
  if (n<4) or (j<1)
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
              if st=0 then
               begin
                j1k:=jk-k;
                st:=boundconds(psi1(null,j1k),xi1(null,j1k));
                if st=0 then
                 begin
                  st:=boundconds(xi1(one,j1k),psi2(one,j1k));
                  if st=0 then
                   begin
                    st:=boundconds(psi2(one,j1k),xi2(one,j1k));
                    if st=0 then
                     begin
                      st:=boundconds(xi2(null,j1k),psi1(one,j1k));
                      if st=0 then
                       begin
                        j12k:=j1k+k/2;
                        st:=boundconds(psi1(null,j12k),xi1(null,j12k));
                        if st=0 then
                         begin
                          st:=boundconds(xi1(one,j12k),psi2(one,j12k));
                          if st=0 then
                           begin
                            st:=boundconds(psi2(one,j12k),xi2(one,j12k));
                            if st=0 then
                             st:=boundconds(xi2(null,j12k),psi1(one,j12k))
                           end
                         end
                       end
                     end
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
           n1:=n-1;
           n1sqr:=n1*n1;
           n2:=n1-1;
           alpha:=2*h*h/k;
           beta:=alpha-2;
           alpha:=alpha+2;
           r:=psi1(h,j12k)+xi1(h,j1k);
           if j=1
             then r:=r+beta*phi(h,h)+phi(h,2*h)
             else r:=r+beta*u[1,1]+u[1,2];
           d[1]:=r;
           for i:=2 to n2 do
             begin
               r:=psi1(i*h,j12k);
               i1:=i-1;
               i2:=i+1;
               if j=1
                 then r:=r+phi(h,i1*h)+beta*phi(h,i*h)+phi(h,i2*h)
                 else r:=r+u[1,i1]+beta*u[1,i]+u[1,i2];
               d[n1*i1+1]:=r
             end;
           r:=psi1(n1*h,j12k)+xi2(h,j1k);
           if j=1
             then r:=r+phi(h,n2*h)+beta*phi(h,n1*h)
             else r:=r+u[1,n2]+beta*u[1,n1];
           d[n1*n2+1]:=r;
           for l:=2 to n2 do
             begin
               lh:=l*h;
               r:=xi1(lh,j1k);
               if j=1
                 then r:=r+beta*phi(lh,h)+phi(lh,2*h)
                 else r:=r+beta*u[l,1]+u[l,2];
               d[l]:=r;
               for i:=2 to n2 do
                 begin
                   i1:=i-1;
                   i2:=i+1;
                   if j=1
                     then r:=phi(lh,i1*h)+beta*phi(lh,i*h)+phi(lh,i2*h)
                     else r:=u[l,i1]+beta*u[l,i]+u[l,i2];
                   d[n1*i1+l]:=r
                 end;
               r:=xi2(lh,j1k);
               if j=1
                 then r:=r+phi(lh,n2*h)+beta*phi(lh,n1*h)
                 else r:=r+u[l,n2]+beta*u[l,n1];
               d[n1*n2+l]:=r
             end;
           lh:=n1*h;
           r:=psi2(h,j12k)+xi1(lh,j1k);
           if j=1
             then r:=r+beta*phi(lh,h)+phi(lh,2*h)
             else r:=r+beta*u[n1,1]+u[n1,2];
           d[n1]:=r;
           for i:=2 to n2 do
             begin
               r:=psi2(i*h,j12k);
               i1:=i-1;
               i2:=i+1;
               if j=1
                 then r:=r+phi(lh,i1*h)+beta*phi(lh,i*h)+phi(lh,i2*h)
                 else r:=r+u[n1,i1]+beta*u[n1,i]+u[n1,i2];
               d[n1*i]:=r
             end;
           r:=psi2(lh,j12k)+xi2(lh,j1k);
           if j=1
             then r:=r+phi(lh,n2*h)+beta*phi(lh,lh)
             else r:=r+u[n1,n2]+beta*u[n1,n1];
           d[n1sqr]:=r;
           Crout (d);
           for i:=1 to n1 do
             for l:=1 to n1 do
               u[l,i]:=d[n1*(i-1)+l];
           d[1]:=psi1(h,j12k)+xi1(h,jk)+beta*u[1,1]+u[2,1];
           for i:=2 to n2 do
             d[i]:=psi1(i*h,j12k)+beta*u[1,i]+u[2,i];
           d[n1]:=psi1(n1*h,j12k)+xi2(h,jk)+beta*u[1,n1]+u[2,n1];
           for l:=2 to n2 do
             begin
               lh:=l*h;
               i1:=l-1;
               i2:=l+1;
               d[n1*i1+1]:=xi1(lh,jk)+u[i1,1]+beta*u[l,1]+u[i2,1];
               for i:=2 to n2 do
                 d[n1*i1+i]:=u[i1,i]+beta*u[l,i]+u[i2,i];
               d[n1*l]:=xi2(lh,jk)+u[i1,n1]+beta*u[l,n1]+u[i2,n1]
             end;
           lh:=n1*h;
           d[n1*n2+1]:=psi2(h,j12k)+xi1(lh,jk)+u[n2,1]+beta*u[n1,1];
           for i:=2 to n2 do
             d[n1*n2+i]:=psi2(i*h,j12k)+u[n2,i]+beta*u[n1,i];
           d[n1sqr]:=psi2(lh,j12k)+xi2(lh,jk)+u[n2,n1]+beta*u[n1,n1];
           Crout (d);
           for l:=1 to n1 do
             for i:=1 to n1 do
               u[l,i]:=d[n1*(l-1)+i];
           for l:=0 to n do
             begin
               lh:=l*h;
               u[l,0]:=xi1(lh,jk);
               u[l,n]:=xi2(lh,jk)
             end;
           for i:=1 to n1 do
             begin
               lh:=i*h;
               u[0,i]:=psi1(lh,jk);
               u[n,i]:=psi2(lh,jk)
             end
         end
end;