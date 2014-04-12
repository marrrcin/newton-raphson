procedure shooting (m              : Integer;
                    fun            : ftufunction;
                    gfun           : gboundary;
                    s,ds           : vector;
                    n              : Integer;
                    a,b,mh,eps,eta : Extended;
                    mit            : Integer;
                    var u          : matrix1;
                    var st         : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure shooting calculates approximate values u[i,l] (i=1,2,...,  }
{  ...,m; l=0,1,...,n) of the solutions of the boundary value problem       }
{  dy[i](t)/dt = f[i](t,y[1],y[2],...,y[m]) with the conditions             }
{  g[i](y[1](a),...,y[m](a),y[1](b),...,y[m](b)) = 0 at the points          }
{  t[k]=a+kh, where h=(b-a)/n, by the simple shooting method.               }
{  Data:                                                                    }
{    m       - number of equations,                                         }
{    fun     - a Turbo Pascal procedure which evaluates the functions       }
{              occurring in the differential equations,                     }
{    gfun    - a Turbo Pascal procedure which evaluates the functions       }
{              occurring in the boundary conditions,                        }
{    s       - an array containing initial approximations to conditions     }
{              y[i](a)=s[i] (i=1,2,...,m),                                  }
{    ds      - an array of increments for s (sufficiently small numbers),   }
{    n       - number of points at which the solutions should be found      }
{              minus one,                                                   }
{    a,b     - the ends of the integration interval,                        }
{    mh      - minimum admissible absolute value of step size for each of   }
{              the initial problem arising in the method,                   }
{    eps,eta - values which characterize the accuracy of the solutions,     }
{    mit     - maximum number of iterations for finding s[i] (i=1,2,...,m)  }
{              which fulfill the conditions y[i](a)=s[i].                   }
{  Result:                                                                  }
{    u - an array containing the solutions (the element u[i,k] contains the }
{        i-th component of the solution at the point a+kh; i=1,2,...,m;     }
{        k=0,1,...,n).                                                      }
{  Other parameters:                                                        }
{    st - a variable which within the procedure shooting is assigned the    }
{         value of:                                                         }
{           1, if m<1 or n<1 or mit<1,                                      }
{           2, if for abs(h)<mh the given accuracy eps is not achieved in   }
{              at least one of the initial value problems,                  }
{           3, if the matrix of the adequate linear system of equations is  }
{              singular,                                                    }
{           4, if number of iterations for finding s[i] (i=1,2,...,n) is    }
{              greater than mit,                                            }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array u are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q1..qm], where      }
{                  q1<=1 and qm>=m,                                         }
{    vector1     - a type identifier of extended array [q1..qm1], where     }
{                  q1<=1 and qm1>=m+1,                                      }
{    vector2     - a type identifier of integer array [q1..qm1], where      }
{                  q1<=1 and qm1>=m+1,                                      }
{    vector3     - a type identifier of extended array [q1..qm2], where     }
{                  q1<=1 and qm2>=(m+2)(m+2)/4,                             }
{    matrix      - a type identifier of extended array [q1..qm,q1..qm],     }
{                  where q1<=1 and qm>=m,                                   }
{    matrix1     - a type identifier of extended array [q1..qm,q0..qn],     }
{                  where q1<=1, qm>=m, q0<=0 and qn>=n,                     }
{    ftufunction - a procedural-type identifier defined as follows          }
{                    type ftufunction = procedure (t     : Extended;        }
{                                                  m     : Integer;         }
{                                                  ut    : vector;          }
{                                                  var f : vector);         }
{    gboundary   - a procedural-type identifier defined as follows          }
{                    type gboundary = procedure (m     : Integer;           }
{                                                ua,ub : vector;            }
{                                                var g : vector);           }
{  Note: Any procedure passed as a parameter should be declared with a far  }
{        directive before the block or compiled in the $F+ state.           }
{                                                                           }
{---------------------------------------------------------------------------}
var i,it,j,jh,k,kh,l,lh,m1,p,q,rh : Integer;
    dsk,h,hh,max,s1,uj,x0,x1      : Extended;
    fl,ft                         : Boolean;
    g,gk,ss,w,y                   : vector;
    a1,b1                         : vector1;
    r                             : vector2;
    x                             : vector3;
    df                            : matrix;
procedure RK4 (var x0 : Extended;
               x1     : Extended;
               n      : Integer;
               var y  : vector);
const c=1.25e0;
var   k,sh                   : Integer;
      eps1,h1,h2,w1,w2,w3,w4 : Extended;
      gd,nk,nt,rp            : Boolean;
      f,y1,y2,y3             : vector;
procedure onestep (x      : Extended;
                   u      : vector;
                   hh     : Extended;
                   var yh : vector);
var i,k : Integer;
    yw  : vector;
begin
  w1:=hh/2;
  w4:=w1;
  w2:=x;
  for k:=1 to n do
    begin
      yw[k]:=u[k];
      yh[k]:=0
    end;
  for i:=1 to 4 do
    begin
      if (i=1) or (i=4)
        then w3:=w4
        else w3:=hh;
      fun (w2,n,yw,f);
      for k:=1 to n do
        begin
          w2:=f[k];
          yh[k]:=yh[k]+w3*w2;
          yw[k]:=u[k]+w1*w2
        end;
      w2:=x+w1;
      w1:=w3
    end;
  for k:=1 to n do
    yh[k]:=u[k]+yh[k]/3
end {onestep};
begin
  eps1:=eps/40;
  w1:=x1-x0;
  if w1<0
    then sh:=-1
    else if w1=0
           then sh:=0
           else sh:=1;
  nt:=false;
  if fl
    then begin
           h:=w1;
           h1:=h;
           fl:=false
         end
    else begin
           h1:=h;
           if abs(h1)<mh
             then begin
                    h:=mh*sh;
                    h1:=h
                  end;
           if (x0+c*h1-x1)*sh>=0
             then h1:=w1
             else nt:=true
         end;
  rp:=true;
  repeat
    gd:=true;
    onestep (x0,y,h1,y1);
    nk:=true;
    repeat
      h2:=h1/2;
      onestep (x0,y,h2,y2);
      onestep (x0+h2,y2,h2,y3);
      w4:=0;
      for k:=1 to n do
        begin
          w1:=y1[k];
          w3:=y3[k];
          w2:=abs(w1-w3);
          w1:=abs(w2);
          w3:=abs(w3);
          if w1<w3
            then w1:=w3;
          if w1<eta
            then w1:=eta;
          w1:=w2/w1;
          if w1>w4
            then w4:=w1
        end;
      if w4>eps
        then begin
               gd:=false;
               if abs(h2)<mh
                 then begin
                        st:=2;
                        rp:=false
                      end
                 else begin
                        h:=h2;
                        h1:=h;
                        nt:=true;
                        for k:=1 to n do
                          y1[k]:=y2[k]
                      end
             end
        else nk:=false
    until not nk or (st=2);
    if not nk
      then begin
             for k:=1 to n do
               begin
                 w3:=y3[k];
                 y[k]:=w3+(w3-y1[k])/15
               end;
             if nt
               then begin
                      x0:=x0+h1;
                      if (w4<eps1) and gd
                        then begin
                               h:=2*h1;
                               h1:=h
                             end;
                      if (x0+c*h1-x1)*sh>=0
                        then begin
                               h1:=x1-x0;
                               nt:=false
                             end
                    end
               else begin
                      x0:=x1;
                      rp:=false
                    end
           end
  until not rp
end {RK4};
begin
  if (m<1) or (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           it:=0;
           fl:=true;
           repeat
             x0:=a;
             for j:=1 to m do
               y[j]:=s[j];
             RK4 (x0,b,m,y);
             if st=0
               then begin
                      gfun (m,s,y,g);
                      for k:=1 to m do
                        begin
                          dsk:=ds[k];
                          for j:=1 to n do
                            begin
                              uj:=s[j];
                              if j=k
                                then uj:=uj+dsk;
                              y[j]:=uj;
                              w[j]:=uj
                            end;
                          x0:=a;
                          RK4 (x0,b,m,y);
                          if st=0
                            then begin
                                   gfun (m,w,y,gk);
                                   for j:=1 to m do
                                     df[k,j]:=(gk[j]-g[j])/dsk
                                 end
                        end;
                      if st=0
                        then begin
                               m1:=m+1;
                               p:=m1;
                               for i:=1 to m1 do
                                 r[i]:=0;
                               k:=0;
                               repeat
                                 k:=k+1;
                                 for i:=1 to m do
                                   a1[i]:=df[i,k];
                                 a1[m1]:=g[k];
                                 for i:=1 to m do
                                   begin
                                     rh:=r[i];
                                     if rh<>0
                                       then b1[rh]:=a1[i]
                                   end;
                                 kh:=k-1;
                                 l:=0;
                                 max:=0;
                                 for j:=1 to m1 do
                                   if r[j]=0
                                     then begin
                                            s1:=a1[j];
                                            l:=l+1;
                                            q:=l;
                                            for i:=1 to kh do
                                              begin
                                                s1:=s1-b1[i]*x[q];
                                                q:=q+p
                                              end;
                                            a1[l]:=s1;
                                            s1:=abs(s1);
                                            if (j<m1) and (s1>max)
                                              then begin
                                                     max:=s1;
                                                     jh:=j;
                                                     lh:=l
                                                   end
                                          end;
                                 if max=0
                                   then st:=3
                                   else begin
                                          max:=1/a1[lh];
                                          r[jh]:=k;
                                          for i:=1 to p do
                                            a1[i]:=max*a1[i];
                                          jh:=0;
                                          q:=0;
                                          for j:=1 to kh do
                                            begin
                                              s1:=x[q+lh];
                                              for i:=1 to p do
                                                if i<>lh
                                                  then begin
                                                         jh:=jh+1;
                                                         x[jh]:=x[q+i]
                                                                -s1*a1[i]
                                                       end;
                                              q:=q+p
                                            end;
                                          for i:=1 to p do
                                            if i<>lh
                                              then begin
                                                     jh:=jh+1;
                                                     x[jh]:=a1[i]
                                                   end;
                                          p:=p-1
                                        end
                               until (k=m) or (st=3);
                               if st=0
                                 then begin
                                        for k:=1 to m do
                                          begin
                                            rh:=r[k];
                                            if rh<>k
                                              then begin
                                                     s1:=x[k];
                                                     x[k]:=x[rh];
                                                     i:=r[rh];
                                                     while i<>k do
                                                       begin
                                                         x[rh]:=x[i];
                                                         r[rh]:=rh;
                                                         rh:=i;
                                                         i:=r[rh]
                                                       end;
                                                     x[rh]:=s1;
                                                     r[rh]:=rh
                                                   end
                                          end;
                                        for j:=1 to m do
                                          ss[j]:=s[j]-x[j];
                                        ft:=true;
                                        j:=0;
                                        repeat
                                          j:=j+1;
                                          if abs(ss[j]-s[j])>=eps*eta
                                            then ft:=false;
                                        until not ft or (j=m);
                                        if not ft
                                          then begin
                                                 for j:=1 to m do
                                                   s[j]:=ss[j];
                                                 it:=it+1
                                               end
                                      end
                             end
                    end
           until ft or (it>mit) or (st<>0);
           if ft and (st=0)
             then begin
                    for i:=1 to m do
                      u[i,0]:=s[i];
                    hh:=(b-a)/n;
                    x0:=a;
                    k:=1;
                    repeat
                      x1:=a+k*hh;
                      RK4 (x0,x1,m,s);
                      if st=0
                        then begin
                               for i:=1 to m do
                                 u[i,k]:=s[i];
                               k:=k+1
                             end
                    until (k>n) or (st=2)
                  end
             else if it>mit
                    then st:=4
         end
end;