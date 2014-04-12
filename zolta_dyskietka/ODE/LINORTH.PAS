procedure linorthogon (m         : Integer;
                       at        : atmatrix;
                       ft        : ftfunction;
                       var b     : matrix;
                       var gamma : vector;
                       var t     : vector;
                       n         : Integer;
                       var u     : matrix1;
                       var st    : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure linorthogon calculates approximate values u[i,l]           }
{  (i=1,2,...,m; l=1,2,...,n) of the solutions of the linear boundary value }
{  problem dy[i](t)/dt + A[i,1](t)y[1](t) +...+ A[i,m](t)y[m](t) +          }
{  + f[i](t) = 0 with the conditions b[j,1]y[1](t[j]) + b[j,2]y[2](t[j]) +  }
{  +...+ b[j,m]u[m](t[j]) = gamma[j] (j=1,2,...,m).                         }
{  Data:                                                                    }
{    m       - number of differential equations,                            }
{    at      - a Turbo Pascal procedure which calculates the values of      }
{              elements of the matrix A(x) occurring in the differential    }
{              equations,                                                   }
{    ft      - a Turbo Pascal procedure which calculates the values of      }
{              elements of the vector f(x) occurring in the differential    }
{              equations,                                                   }
{    b,gamma - arrays which contain the values occurring in boundary        }
{              conditions,                                                  }
{    t       - a vector containing the points of boundary conditions (it    }
{              should be t[j]<=t[j+1], j=1,2,...,m-1),                      }
{    n       - number of points at which the solutions should be found (the }
{              first point is equal to t[1], and the last one to t[m]).     }
{  Result:                                                                  }
{    u - an array of approximate solutions (the element u[i,l] contains the }
{        i-th component of the solution at the l-th point of the interval   }
{        [ t[1],t[m] ]; i=1,2,...,m; l=1,2,...,n).                          }
{  Other parameters:                                                        }
{    st - a variable which within the procedure linorthogon is assigned the }
{         value of:                                                         }
{           1, if m<2 or n<2,                                               }
{           2, if the columns of matrix b are dependent linearly,           }
{           3, if the condition t[j]<=t[j+1] is not fulfilled for at least  }
{              one j=1,2,...,m-1,                                           }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array u are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector     - a type identifier of extended array [q1..qm], where q1<=1 }
{                 and qm>=m,                                                }
{    vector1    - a type identifier of extended array [q1..qm1], where      }
{                 q1<=1 and qm1>=m*(m+1),                                   }
{    matrix     - a type identifier of extended array [q1..qm,q1..qm],      }
{                 where q1<=1 and qm>=m,                                    }
{    matrix1    - a type identifier of extended array [q1..qm,q1..qn],      }
{                 where q1<=1, qm>=m and qn>=n,                             }
{    matrix2    - a type identifier of extended array [q1..qm1,q0..q6],     }
{                 where q1<=1, qm1>=m*(m+1), q0<=0 and q6>=6,               }
{    matrix3    - a type identifier of extended array [q0..q7,q1..qm1],     }
{                 where q0<=0, q7>=7, q1<=1 and qm1>=m*(m+1),               }
{    atmatrix   - a procedural-type identifier defined as follows           }
{                   type atmatrix = procedure (x     : Extended;            }
{                                              m     : Integer;             }
{                                              var a : matrix);             }
{    ftfunction - a procedural-type identifier defined as follows           }
{                   type ftfunction = procedure (x     : Extended;          }
{                                                m     : Integer;           }
{                                                var f : vector);           }
{  Notes: 1) Any procedure passed as a parameter should be declared with a  }
{            far directive or compiled in the $F+ state.                    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k,k1,m1,p          : Integer;
    del,h,hh,nck,sum,x0,x1 : Extended;
    fl                     : Boolean;
    alpha,c,f,v            : vector;
    y,ymax                 : vector1;
    a,phi                  : matrix;
procedure GBS (version    : Integer;
               var x0     : Extended;
               x1         : Extended;
               n          : Integer;
               var y,ymax : vector1;
               var h      : Extended;
               var fl     : Boolean);
const eps=9e-15;
var i,j,k,kappa,l,lambda,rho,sigma,tau     : Integer;
    a,b,beta,c,dh,g,h1,omega,phi,theta,w,x : Extended;
    bo,bh,exit,exit1,exit2,konv            : Boolean;
    ff,f1,ya,yl,ym                         : vector1;
    d                                      : array [0..6] of Extended;
    delta                                  : matrix2;
    yg,yh                                  : matrix3;
procedure prod (var aa,bb,cc : matrix);
var i,j,k : Integer;
    sum   : Extended;
begin
  for i:=1 to m do
    for j:=1 to m do
      begin
        sum:=0;
        for k:=1 to m do
          sum:=sum+aa[i,k]*bb[k,j];
        cc[i,j]:=sum
      end
end {prod};
procedure fun (x      : Extended;
               var y  : vector1;
               var ff : vector1);
var i1,i2,i3,j,p,q,r    : Integer;
    sum,sum1,sum2,y1,y2 : Extended;
    f,v                 : vector;
    a,a1,a2,b1,c1,c2    : matrix;
begin
  at (x,m,a);
  ft (x,m,f);
  if version=1
    then begin
           for i1:=1 to m do
             for j:=1 to m do
               a1[i1,j]:=a[j,i1];
           for i1:=1 to m do
             for j:=1 to m do
               begin
                 y1:=a[i1,j];
                 y2:=a1[i1,j];
                 a2[i1,j]:=y1+y2
               end;
           for j:=1 to k1 do
             begin
               p:=(j-1)*m1;
               for i2:=1 to m do
                 begin
                   y1:=y[p+i2];
                   for i3:=1 to m do
                     begin
                       sum:=-y1*y[p+i3];
                       if i2=i3
                         then sum:=sum+1;
                       b1[i2,i3]:=sum
                     end
                 end;
               prod (b1,a1,c1);
               for r:=1 to j-1 do
                 begin
                   q:=(r-1)*m1;
                   for i2:=1 to m do
                     begin
                       y1:=y[q+i2];
                       for i3:=1 to m do
                         b1[i2,i3]:=y1*y[q+i3]
                     end;
                   prod (b1,a2,c2);
                   for i2:=1 to m do
                     for i3:=1 to m do
                       begin
                         y1:=c1[i2,i3];
                         y2:=c2[i2,i3];
                         c1[i2,i3]:=y1-y2
                       end
                 end;
               for i1:=1 to m do
                 begin
                   sum:=0;
                   for i2:=1 to m do
                     begin
                       y1:=c1[i1,i2];
                       y2:=y[p+i2];
                       sum:=sum+y1*y2
                     end;
                   ff[p+i1]:=sum
                 end;
               for i1:=1 to m do
                 begin
                   sum:=0;
                   for i2:=1 to m do
                     begin
                       y1:=y[p+i2];
                       y2:=a2[i2,i1];
                       sum:=sum+y1*y2
                     end;
                   v[i1]:=sum
                 end;
               sum:=0;
               for i1:=1 to m do
                 begin
                   y1:=y[p+i1];
                   y2:=f[i1];
                   sum:=sum+y1*y2
                 end;
               for q:=1 to j-1 do
                 begin
                   r:=(q-1)*m1;
                   sum1:=0;
                   for i1:=1 to m do
                     begin
                       y1:=v[i1];
                       y2:=y[r+i1];
                       sum1:=sum1+y1*y2
                     end;
                   sum:=sum+sum1*y[r+m1]
                 end;
               sum1:=0;
               for i1:=1 to m do
                 begin
                   sum2:=0;
                   for i2:=1 to m do
                     begin
                       y1:=y[p+i2];
                       y2:=a[i2,i1];
                       sum2:=sum2+y1*y2
                     end;
                   sum1:=sum1+sum2*y[p+i1]
                 end;
               sum:=sum+sum1*y[p+m1];
               ff[p+m1]:=-sum
             end
         end
    else for i1:=1 to m do
           begin
             sum:=f[i1];
             for j:=1 to m do
               begin
                 y1:=a[i1,j];
                 y2:=y[j];
                 sum:=sum+y1*y2
               end;
             ff[i1]:=-sum
           end
end {fun};
begin
  x:=x0;
  dh:=x1-x0;
  if fl
    then begin
           fl:=false;
           h:=dh;
           for i:=1 to n do
             ymax[i]:=0
         end;
  exit:=false;
  exit1:=false;
  repeat
    fun (x,y,ff);
    bh:=false;
    for i:=1 to n do
      ya[i]:=y[i];
    exit2:=false;
    repeat
      a:=x+h;
      phi:=1.5e0;
      bo:=false;
      rho:=1;
      sigma:=2;
      tau:=3;
      lambda:=-1;
      j:=0;
      repeat
        if bo
          then begin
                 d[1]:=1.77777777777777778e0;
                 d[3]:=7.11111111111111111e0;
                 d[5]:=2.84444444444444444e1
               end
          else begin
                 d[1]:=2.25;
                 d[3]:=9;
                 d[5]:=36
               end;
        if j>2
          then konv:=true
          else konv:=false;
        if j>6
          then begin
                 l:=6;
                 d[6]:=64;
                 phi:=0.6*phi
               end
          else begin
                 l:=j;
                 d[l]:=sqr(rho)
               end;
        rho:=2*rho;
        g:=h/rho;
        b:=2*g;
        if bh and (j<8)
          then for i:=1 to n do
                 begin
                   ym[i]:=yh[j,i];
                   yl[i]:=yg[j,i]
                 end
          else begin
                 w:=(rho-2)/2;
                 kappa:=round(w);
                 rho:=rho-1;
                 for i:=1 to n do
                   begin
                     yl[i]:=ya[i];
                     ym[i]:=ya[i]+g*ff[i]
                   end;
                 for k:=1 to rho do
                   begin
                     w:=x+k*g;
                     fun (w,ym,f1);
                     for i:=1 to n do
                       begin
                         w:=yl[i]+b*f1[i];
                         yl[i]:=ym[i];
                         ym[i]:=w;
                         w:=abs(w);
                         c:=ymax[i];
                         if w>c
                           then ymax[i]:=w
                       end;
                     if (k=kappa) and (k<>2)
                       then begin
                              lambda:=lambda+1;
                              for i:=1 to n do
                                begin
                                  yh[lambda,i]:=ym[i];
                                  yg[lambda,i]:=yl[i]
                                end
                            end
                   end
               end;
        fun (a,ym,f1);
        for i:=1 to n do
          begin
            theta:=delta[i,0];
            c:=yl[i]+g*f1[i];
            c:=(ym[i]+c)/2;
            omega:=c;
            delta[i,0]:=c;
            for k:=1 to l do
              begin
                beta:=theta*d[k];
                b:=beta-c;
                w:=theta;
                if b<>0
                  then begin
                         b:=(c-theta)/b;
                         w:=b*c;
                         c:=b*beta
                       end;
                theta:=delta[i,k];
                delta[i,k]:=w;
                omega:=omega+w
              end;
            c:=abs(y[i]-omega);
            w:=eps*ymax[i];
            if c>w
              then konv:=false;
            y[i]:=omega;
          end;
        if konv
          then exit2:=true
          else begin
                 d[2]:=4;
                 d[4]:=16;
                 bo:=not bo;
                 rho:=sigma;
                 sigma:=tau;
                 tau:=2*rho;
                 j:=j+1
               end
      until (j=10) or konv;
      if not konv
        then begin
               bh:=not bh;
               h:=h/2
             end
    until exit2;
    h:=phi*h;
    x:=a;
    if exit
      then begin
             h:=h1;
             if abs(h)>abs(dh)
               then h:=dh;
             x0:=x;
             exit1:=true
           end
      else if abs(x+h)>=abs(x1)
             then begin
                    h1:=h;
                    h:=x1-x;
                    exit:=true
                  end;
  until exit and exit1
end {GBS};
function norm (m : integer;
               v : vector) : extended;
var i: integer;
    s: extended;
begin
  s:=0;
  for i:=1 to m do
    s:=s+sqr(v[i]);
  norm:=sqrt(s)
end {norm};
begin
  if (m<2) or (n<2)
    then st:=1
    else st:=0;
  m1:=m+1;
  j:=1;
  repeat
    if t[j]>t[j+1]
      then st:=3;
    j:=j+1
  until (j=m) or (st=3);
  if st=0
    then begin
           k:=-1;
           repeat
             k:=k+1;
             fl:=true;
             k1:=k+1;
             for j:=1 to k do
               begin
                 sum:=0;
                 for i:=1 to m do
                   sum:=sum+phi[j,i]*b[k1,i];
                 alpha[j]:=sum
               end;
             for i:=1 to m do
               begin
                 sum:=b[k1,i];
                 for j:=1 to k do
                   sum:=sum-alpha[j]*phi[j,i];
                 c[i]:=sum
               end;
             nck:=norm(m,c);
             if nck=0
               then st:=2
               else begin
                      sum:=gamma[k1];
                      for j:=1 to k do
                        sum:=sum-alpha[j]*v[j];
                      del:=sum/nck;
                      for i:=1 to m do
                        c[i]:=c[i]/nck;
                      if k1<m
                        then begin
                               p:=k*m1;
                               for i:=1 to m do
                                 y[p+i]:=c[i];
                               y[p+m1]:=del;
                               x0:=t[k1];
                               x1:=t[k1+1];
                               GBS (1,x0,x1,k1*m1,y,ymax,h,fl);
                               for j:=1 to k1 do
                                 begin
                                   p:=(j-1)*m1;
                                   for i:=1 to m do
                                     phi[j,i]:=y[p+i];
                                   v[j]:=y[p+m1]
                                   end
                             end
                    end
           until (k=m-1) or (st=2);
           if st=0
             then begin
                    for i:=1 to m do
                      begin
                        sum:=c[i]*del;
                        for j:=1 to m-1 do
                          sum:=sum+phi[j,i]*v[j];
                        u[i,n]:=sum;
                        for j:=n-1 downto 1 do
                          u[i,j]:=0
                      end;
                    x0:=t[m];
                    h:=(x0-t[1])/(n-1);
                    hh:=h;
                    fl:=true;
                    for k:=n downto 2 do
                      begin
                        x1:=x0-hh;
                        for i:=1 to m do
                          y[i]:=u[i,k];
                        GBS (2,x0,x1,m,y,ymax,h,fl);
                        for i:=1 to m do
                          u[i,k-1]:=y[i]
                      end
                  end
         end
end;