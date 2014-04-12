procedure linearRayleighRitz (n         : Integer;
                              x         : vector0;
                              p,q,f     : fx;
                              eps       : Extended;
                              var c,phi : vector;
                              var st    : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure linearRayleighRitz calculates coefficients c[i]            }
{  (i=1,2,...,n) of an approximation phi(x) = c[1]phi[1](x)                 }
{  + c[2]phi[2](x) +...+ c[n]phi[n](x) to the solution y(x) of a linear     }
{  two-point boundary-value problem given by the differential equation      }
{  -d(p(x)dy/dx)dx + q(x)y = f(x) for 0<=x<=1, with the boundary conditions }
{  y(0)=y(1)=0, where p(x)>0 and q(x)>=0 for 0<=x<=1. The functions         }
{  phi[i](x) are the piecewise linear basis in [0,1].                       }
{  Data:                                                                    }
{    n     - number of subintervals minus 1 of the interval [0,1],          }
{    x     - an array of nodes which define the subintervals in [0,1]       }
{            (x[0]=0 < x[1] < ... < x[n] < x[n+1]=1),                       }
{    p,q,f - Turbo Pascal functions which for a given x calculate values    }
{            of functions p(x), q(x) and f(x) occuring in differential      }
{            equation,                                                      }
{    eps   - accuracy for calculating integrals occuring in the algorithm   }
{            by Romberg's method.                                           }
{  Results:                                                                 }
{    c   - an array of coefficients of an approximation to the solution     }
{          the element c[i] contains the i-th coefficient of the piecewise  }
{          linear function; i=1,2,...,n).                                   }
{    phi - an array containing the approximate solution at nodes (the       }
{          element phi[i] contains the approximate solution at x[i];        }
{          i=1,2,...,n).                                                    }
{  Other parameters:                                                        }
{    st - a variable which within the procedure linearRayleighRitz is       }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if for at least one i (i=0,...,n) the condition              }
{              x[i]<x[i+1] is not fulfilled,                                }
{           3, if x[0]<>0 or x[n+1]<>1,                                     }
{           4, if p(x[i])<=0 or q(x[i])<0 for at least one i=0,1,...,n+1,   }
{           5, if at least one of the integral occuring in the method has   }
{              not been calculated with the given accuracy eps,             }
{           0, otherwise.                                                   }
{         Note: If st=1,2,3 or 4, then the elements of array c are not      }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector0 - a type identifier of extended array [q0..qn1], where q0<=0   }
{              and qn1>=n+1,                                                }
{    vector1 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n-1,                                                }
{    fx      - a procedural-type identifier defined as follows              }
{                 type fx = function (x : Extended) : Extended;             }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,st1                           : Integer;
    h2,node,node1,int3,int4,int5,int6,
    intnew1,intnew2,intold1,intold2   : Extended;
    a,alpha,b,z                       : vector;
    h                                 : vector0;
    beta,zeta                         : vector1;
function phiatz (i : Integer;
                 z : Extended;
                 x : vector0) : Extended;
begin
  if (z<=x[i-1]) or (z>x[i+1])
    then phiatz:=0
    else if (z>x[i-1]) and (z<=x[i])
           then phiatz:=(z-x[i-1])/(x[i]-x[i-1])
           else phiatz:=(x[i+1]-z)/(x[i+1]-x[i])
end;
function qi (x : Extended) : Extended;
begin
  qi:=sqr(x-node)*q(x)
end;
function qi1 (x : Extended) : Extended;
begin
  qi1:=sqr(node1-x)*q(x)
end;
function qi2 (x : Extended) : Extended;
begin
  qi2:=(node1-x)*(x-node)*q(x)
end;
function fi (x : Extended) : Extended;
begin
  fi:=sqr(x-node)*f(x)
end;
function fi1 (x : Extended) : Extended;
begin
  fi1:=sqr(node1-x)*f(x)
end;
function Romberg (kind   : Integer;
                  a,b    : Extended;
                  f      : fx;
                  eps    : Extended;
                  var st : Integer) : Extended;
var j,k,l        : Integer;
    h,h1,I,q,s,x : Extended;
    kon          : Boolean;
    t            : array [1..15] of Extended;
function fun (kind : Integer;
              x    : Extended) : Extended;
begin
  case kind of
    1 : fun:=f(x);
    2 : fun:=sqr(x-node)*f(x);
    3 : fun:=sqr(node1-x)*f(x);
    4 : fun:=(node1-x)*(x-node)*f(x);
    5 : fun:=(x-node)*f(x);
    6 : fun:=(node1-x)*f(x)
  end
end;
begin
  t[1]:=0.5*(fun(kind,a)+fun(kind,b));
  h:=b-a;
  h1:=h;
  l:=1;
  k:=1;
  repeat
    k:=k+1;
    I:=t[1];
    s:=0;
    x:=a+0.5*h1;
    while x<b do
      begin
        s:=s+fun(kind,x);
        x:=x+h1
      end;
    h1:=0.5*h1;
    t[k]:=0.5*(t[k-1]+s/l);
    q:=1;
    for j:=k-1 downto 1 do
      begin
        q:=4*q;
        t[j]:=t[j+1]+(t[j+1]-t[j])/(q-1)
      end;
    kon:=abs(I-t[1])*h<=eps;
    if not kon
      then l:=2*l
  until kon or (k>=15);
  if kon
    then st:=0
    else st:=1;
  Romberg:=h*t[1]
end;
begin
  st:=0;
  if n<1
    then st:=1
    else if (x[0]<>0) or (x[n+1]<>1)
           then st:=3;
  if st=0
    then begin
           i:=0;
           while (i<=n) and (st=0) do
             begin
               if x[i]>=x[i+1]
                 then st:=2;
               if (p(x[i])<=0) or (q(x[i])<0)
                 then st:=4;
               i:=i+1
             end;
           if (p(x[n+1])<=0) or (q(x[n+1])<0)
             then st:=4
         end;
  if st=0
    then begin
           for i:=0 to n do
             h[i]:=x[i+1]-x[i];
           h2:=sqr(h[0]);
           intold1:=Romberg(1,0,x[1],p,eps,st1)/h2;
           if st1=1
             then st:=5;
           node:=0;
           intold2:=Romberg(2,0,x[1],q,eps,st1)/h2;
           if st1=1
             then st:=5;
           for i:=1 to n-1 do
             begin
               h2:=sqr(h[i]);
               intnew1:=Romberg(1,x[i],x[i+1],p,eps,st1)/h2;
               if st1=1
                 then st:=5;
               node:=x[i];
               intnew2:=Romberg(2,x[i],x[i+1],q,eps,st1)/h2;
               if st1=1
                 then st:=5;
               node1:=x[i+1];
               int3:=Romberg(3,x[i],x[i+1],q,eps,st1)/h2;
               if st1=1
                 then st:=5;
               int4:=Romberg(4,x[i],x[i+1],q,eps,st1)/h2;
               if st1=1
                 then st:=5;
               node:=x[i-1];
               int5:=Romberg(5,x[i-1],x[i],f,eps,st1)/h[i-1];
               if st1=1
                 then st:=5;
               int6:=Romberg(6,x[i],x[i+1],f,eps,st1)/h[i];
               if st1=1
                 then st:=5;
               alpha[i]:=intold1+intnew1+intold2+int3;
               beta[i]:=-intnew1+int4;
               b[i]:=int5+int6;
               intold1:=intnew1;
               intold2:=intnew2
             end;
           h2:=sqr(h[n]);
           intnew1:=Romberg(1,x[n],1,p,eps,st1)/h2;
           if st1=1
             then st:=5;
           node1:=1;
           int3:=Romberg(3,x[n],1,q,eps,st1)/h2;
           if st1=1
             then st:=5;
           node:=x[n-1];
           int5:=Romberg(5,x[n-1],x[n],f,eps,st1)/h[n-1];
           if st1=1
             then st:=5;
           int6:=Romberg(6,x[n],1,f,eps,st1)/h[n];
           if st1=1
             then st:=5;
           alpha[n]:=intold1+intnew1+intold2+int3;
           b[n]:=int5+int6;
           a[1]:=alpha[1];
           zeta[1]:=beta[1]/alpha[1];
           for i:=2 to n-1 do
             begin
               a[i]:=alpha[i]-beta[i-1]*zeta[i-1];
               zeta[i]:=beta[i]/a[i]
             end;
           a[n]:=alpha[n]-beta[n-1]*zeta[n-1];
           z[1]:=b[1]/a[1];
           for i:=2 to n do
             z[i]:=(b[i]-beta[i-1]*z[i-1])/a[i];
           c[n]:=z[n];
           for i:=n-1 downto 1 do
             c[i]:=z[i]-zeta[i]*c[i+1];
           for j:=1 to n do
             begin
               h2:=0;
               for i:=1 to n do
                 h2:=h2+c[i]*phiatz(i,x[j],x);
               phi[j]:=h2
             end
           end
end;