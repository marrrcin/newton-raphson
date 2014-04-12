procedure finitediff (m,n    : Integer;
                     f      : ithftu;
                     g      : ithgbound;
                     df     : ithdftu;
                     dg     : ithdgbound;
                     t      : vector0;
                     var u  : matrix;
                     alpha  : vector1;
                     mit    : Integer;
                     eps    : Extended;
                     var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure finitediff calculates approximate values u[i,l] (i=1,2,... }
{  ...,m; l=0,1,...,n) of the solutions of the boundary value problem       }
{  dy[i](x)/dt = f[i](x,y[1](x),y[2](x),...,y[m](x)) with the conditions    }
{  g[i](y[1](t[0]),...,y[m](t[0]),y[1](t[n]),...,y[m](t[n])) = 0, by finite }
{  diferences. The solutions are calculated at the points t[0], t[1], ...,  }
{  t[n].                                                                    }
{  Data:                                                                    }
{    m     - number of equations,                                           }
{    n     - number of points at which the solutions should be found minus  }
{            one,                                                           }
{    f     - a Turbo Pascal function which calculates the value of the i-th }
{            function occurring in the system of equations,                 }
{    g     - a Turbo Pascal function which calculates the value of the i-th }
{            function occurring in the boundary conditions,                 }
{    df    - a Turbo Pascal procedure which calculates the values of        }
{            derivatives df[i]/dy[j] (j=1,2,...,m),                         }
{    dg    - a Turbo Pascal procedure which calculates the values of        }
{            derivatives dg[i]/dy[j] and dg[i]/dz[j] (j=1,2,...,m),         }
{    t     - an array which contains the points t[l] (l=0,1,...,n),         }
{    u     - an array the elements u[i,l] (i=1,2,...,m; l=0,1,...,n) of     }
{            which contain initial approximations for m components of the   }
{            solutions at the points t[l] (changed on exit),                }
{    alpha - an array of coefficients of the difference method,             }
{    mit   - maximum number of iterations in Newton's method,               }
{    eps   - absolute accuracy of the solution.                             }
{  Result:                                                                  }
{    u - an array containing the solutions (the element u[i,l] contains the }
{        i-th component of the solution at the point t[l]; i=1,2,...,m;     }
{        l=0,1,...,n).                                                      }
{  Other parameters:                                                        }
{    st - a variable which within the procedure finitediff is assigned the  }
{         value of:                                                         }
{           1, if m<1 or n<1 or mit<1,                                      }
{           2, if the condition t[l]<t[l+1] is not fulfilled for at least   }
{              one l=0,1,...,n-1,                                           }
{           3, if the matrix of the linear system, which arises during the  }
{              application of Newton's method, is singular,                 }
{           4, if the number of iterations is greater than mit,             }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then u is not changed on exit, and if st=3 }
{               or st=4, then the array u contains the last approximations  }
{               to the solutions.                                           }
{  Unlocal identifiers:                                                     }
{    vector     - a type identifier of extended array [q1..qm], where       }
{                 q1<=1 and qm>=m,                                          }
{    vector0    - a type identifier of extended array [q0..qn], where       }
{                 q0<=0 and qn>=n,                                          }
{    vector1    - a type identifier of extended array [q1..qn], where       }
{                 q1<=1 and qn>=n,                                          }
{    vector2    - a type identifier of extended array [q1..qnm], where      }
{                 q1<=1 and qnm>=(n+1)*m+1,                                 }
{    vector3    - a type identifier of integer array [q1..qnm], where       }
{                 q1<=1 and qnm>=(n+1)*m+1,                                 }
{    vector4    - a type identifier of extended array [q1..qnm2], where     }
{                 q1<=1 and qnm2>=(n*m+m+2)*(nm+m+2)/4,                     }
{    matrix     - a type identifier of extended array [q1..qm,q0..qn],      }
{                 where q1<=1, qm>=m, q0<=0 and qn>=n,                      }
{    ithftu     - a procedural-type identifier defined as follows           }
{                   type ithftu = function (i : Integer;                    }
{                                           x : Extended;                   }
{                                           m : Integer;                    }
{                                           y : vector) : Extended;         }
{    ithgbound  - a procedural-type identifier defined as follows           }
{                   type ithgbound = function (i,m : Integer;               }
{                                              y,z : vector) : Extended;    }
{    ithdftu    - a procedural-type identifier defined as follows           }
{                   type ithdftu = procedure (i      : Integer;             }
{                                             x      : Extended;            }
{                                             m      : Integer;             }
{                                             y      : vector;              }
{                                             var dy : vector);             }
{    ithdgbound - a procedural-type identifier defined as follows           }
{                   type ithdgbound = procedure (i,m       : Integer;       }
{                                                y,z       : vector;        }
{                                                var dy,dz : vector);       }
{  Notes: 1) Any procedure and function passed as a parameter should be     }
{            declared with a far directive or compiled in the $F+ state.    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,it,j,jh,k,kh,l,lh,nm,n1,n2,p,q,rh : Integer;
    ai,al,max,s,s1,t0,t1                : Extended;
    cond                                : Boolean;
    dfy,dfz,dgy,dgz,y,z                 : vector;
    a,b                                 : vector2;
    r                                   : vector3;
    x                                   : vector4;
    u0                                  : matrix;
begin
  if (m<1) or (n<1) or (mit<1)
    then st:=1
    else st:=0;
  i:=0;
  repeat
    if t[i]>=t[i+1]
      then st:=2;
    i:=i+1;
  until (i=n) or (st=2);
  if st=0
    then begin
           it:=0;
           nm:=n*m;
           n2:=nm+m+1;
           n1:=n2-1;
           repeat
             it:=it+1;
             for i:=1 to m do
               for j:=0 to n do
                 begin
                   u0[i,j]:=u[i,j];
                   u[i,j]:=0
                 end;
             p:=n2;
             for i:=1 to n2 do
               r[i]:=0;
             k:=0;
             repeat
               k:=k+1;
               if k<=m
                 then begin
                        for i:=1 to m do
                          begin
                            y[i]:=u0[i,0];
                            z[i]:=u0[i,n]
                          end;
                        dg (k,m,y,z,dgy,dgz);
                        for i:=1 to m do
                          a[i]:=dgy[i];
                        for i:=m+1 to nm do
                          a[i]:=0;
                        for i:=nm+1 to nm+m do
                          a[i]:=dgz[i-nm];
                        ai:=-g(k,m,y,z);
                        for q:=1 to m do
                          ai:=ai+dgy[q]*u0[q,0]+dgz[q]*u0[q,n];
                        a[n2]:=ai
                      end
                 else begin
                        l:=trunc((k-1)/m);
                        j:=l*m;
                        for i:=1 to j-m do
                          a[i]:=0;
                        kh:=k-j;
                        al:=alpha[l];
                        t0:=t[l-1];
                        t1:=t[l];
                        s:=t1-t0;
                        s1:=s*(1-al);
                        s:=s*al;
                        for i:=1 to m do
                          begin
                            y[i]:=u0[i,l-1];
                            z[i]:=u0[i,l]
                          end;
                        df (kh,t0,m,y,dfy);
                        df (kh,t1,m,z,dfz);
                        for i:=j-m+1 to j do
                          begin
                            lh:=i-j+m;
                            ai:=-s*dfy[i-j+m];
                            if kh=lh
                              then ai:=ai-1;
                            a[i]:=ai
                          end;
                        for i:=j+1 to j+m do
                          begin
                            lh:=i-j;
                            ai:=-s1*dfz[i-j];
                            if kh=lh
                              then ai:=ai+1;
                            a[i]:=ai
                          end;
                        for i:=j+m+1 to n2-1 do
                          a[i]:=0;
                        ai:=-u0[kh,l]+s*f(kh,t0,m,y);
                        ai:=ai+u0[kh,l-1]+s1*f(kh,t1,m,z);
                        for q:=1 to m do
                          begin
                            ai:=ai-s*dfy[q]*y[q]-s1*dfz[q]*z[q];
                            if q=kh
                              then ai:=ai-y[q]+z[q]
                          end;
                        a[n2]:=ai
                      end;
               for i:=1 to n1 do
                 begin
                   rh:=r[i];
                   if rh<>0
                     then b[rh]:=a[i]
                 end;
               kh:=k-1;
               l:=0;
               max:=0;
               for j:=1 to n2 do
                 if r[j]=0
                   then begin
                          s:=a[j];
                          l:=l+1;
                          q:=l;
                          for i:=1 to kh do
                            begin
                              s:=s-b[i]*x[q];
                              q:=q+p
                            end;
                          a[l]:=s;
                          s:=abs(s);
                          if (j<n2) and (s>max)
                            then begin
                                   max:=s;
                                   jh:=j;
                                   lh:=l
                                 end
                        end;
               if max=0
                 then st:=3
                 else begin
                        max:=1/a[lh];
                        r[jh]:=k;
                        for i:=1 to p do
                          a[i]:=max*a[i];
                        jh:=0;
                        q:=0;
                        for j:=1 to kh do
                          begin
                            s:=x[q+lh];
                            for i:=1 to p do
                            if i<>lh
                              then begin
                                     jh:=jh+1;
                                     x[jh]:=x[q+i]-s*a[i]
                                   end;
                            q:=q+p
                          end;
                        for i:=1 to p do
                          if i<>lh
                            then begin
                                   jh:=jh+1;
                                   x[jh]:=a[i]
                                 end;
                        p:=p-1
                      end
             until (k=n1) or (st=3);
             if st=0
               then begin
                      for k:=1 to n1 do
                        begin
                          rh:=r[k];
                          if rh<>k
                            then begin
                                   s:=x[k];
                                   x[k]:=x[rh];
                                   i:=r[rh];
                                   while i<>k do
                                     begin
                                       x[rh]:=x[i];
                                       r[rh]:=rh;
                                       rh:=i;
                                       i:=r[rh]
                                     end;
                                   x[rh]:=s;
                                   r[rh]:=rh
                                 end
                        end;
                      i:=0;
                      for k:=1 to n1 do
                        begin
                          i:=i+1;
                          j:=trunc((k-1)/m);
                          u[i,j]:=x[k];
                          if i=m
                            then i:=0
                        end;
                      cond:=true;
                      i:=0;
                      repeat
                        i:=i+1;
                        j:=-1;
                        repeat
                          j:=j+1;
                          if abs(u[i,j]-u0[i,j])>=eps
                            then cond:=false
                        until (not cond) or (j=n)
                      until (not cond) or (i=m)
                    end
           until (it=mit) or cond or (st=3)
         end;
  if it=mit
    then st:=4
end;