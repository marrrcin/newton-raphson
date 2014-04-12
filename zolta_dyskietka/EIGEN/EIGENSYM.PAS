procedure eigensymmatrix (n      : Integer;
                          var a  : vector1;
                          k1,k2  : Integer;
                          vec    : Boolean;
                          var x  : vector;
                          var y  : matrix;
                          var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure eigensymmatrix calculates the eigenvalues and optionally   }
{  also eigenvectors for a given symmetric matrix.                          }
{  Data:                                                                    }
{    n     - number of rows (columns) of the given matrix,                  }
{    a     - a one-dimensional array containing the values of the elements  }
{            of the given symmetric matrix (the element a[k] should contain }
{            the value of element in the i-th row and j-th column, where    }
{            k=j+i*(i-1)/2; i=1,2,...,n; j=1,2,...,i),                      }
{    k1,k2 - the numbers which determines the eigenvalues and eigenvectors  }
{            to find (the procedure eigensymmatrix calculates these         }
{            eigenvalues and eigenvectors which ordered from the smallest   }
{            have the order number k1,k1+1,...,k2; 1<=k1<=k2<=n),           }
{    vec   - a Boolean variable which should be assign the value of true if }
{            the procedure eigensymmatrix should calculates the eigenvalues }
{            and the corresponding eigenvectors, and the value of false if  }
{            only the eigenvalues should be determined.                     }
{  Results:                                                                 }
{    x     - an array the elements x[k1],x[k1+1],...,x[k2] of which contain }
{            the eigenvalues with the order numbers k1,k1+1,...,k2 ordered  }
{            from the smallest,                                             }
{    y     - an array containing the eigenvectors corresponding to the      }
{            eigenvalues given in array x (the element y[k,j] contains the  }
{            j-th component of the k-th eigenvector; k=k1,k1+1,...,k2;      }
{            j=1,2,...,n).                                                  }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure eigensymmatrix is         }
{           assigned the value of:                                          }
{             1, if the condition 1<=k1<=k2<=n is not fulfilled,            }
{             0, otherwise.                                                 }
{           Note: If st=1, then the elements of arrays x and y are not      }
{                 calculated.                                               }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n*(n+1)/2,                                          }
{    vector2 - a type identifier of Boolean array [q1..qn], where q1<=1 and }
{              qn>=n,                                                       }
{    matrix  - a type identifier of extended array [q1..qn,q1..qn], where   }
{              q1<=1 and qn>=n.                                             }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k,k3,k4,l,l1,z                                : Integer;
    ei,ei1,eps,g,h,lambda,ma,mi,mn,norm,pi,qi,s,t,u,w : Extended;
    cond,inti                                         : Boolean;
    d,e,e2,lb,m,p,q,r,v                               : vector;
    int                                               : vector2;
procedure auxproc;
begin
  t:=t-q[i]*ei-r[i]*ei1;
  pi:=p[i];
  if pi=0
    then qi:=eps
    else qi:=pi;
  qi:=t/qi;
  v[i]:=qi;
  ei1:=ei;
  ei:=qi
end {auxproc};
begin
  if (1<=k1) and (k1<=k2) and (k2<=n)
    then begin
           st:=0;
           i:=0;
           for l:=1 to n do
             begin
               i:=i+l;
               d[l]:=a[i]
             end;
           for l:=n downto 2 do
             begin
               i:=i-1;
               j:=i;
               h:=a[j];
               s:=0;
               for k:=l-2 downto 1 do
                 begin
                   i:=i-1;
                   g:=a[i];
                   s:=s+g*g
                 end;
               i:=i-1;
               if s=0
                 then begin
                        e[l]:=h;
                        e2[l]:=h*h;
                        a[j]:=0
                      end
                 else begin
                        s:=s+h*h;
                        e2[l]:=s;
                        g:=sqrt(s);
                        if h>=0
                          then g:=-g;
                        e[l]:=g;
                        s:=1/(s-h*g);
                        a[j]:=h-g;
                        h:=0;
                        l1:=l-1;
                        k3:=1;
                        for j:=1 to l1 do
                          begin
                            k4:=k3;
                            g:=0;
                            for k:=1 to l1 do
                              begin
                                g:=g+a[k4]*a[i+k];
                                if k<j
                                  then z:=1
                                  else z:=k;
                                k4:=k4+z
                              end;
                            k3:=k3+j;
                            g:=g*s;
                            e[j]:=g;
                            h:=h+a[i+j]*g
                          end;
                        h:=0.5*h*s;
                        k3:=1;
                        for j:=1 to l1 do
                          begin
                            s:=a[i+j];
                            g:=e[j]-h*s;
                            e[j]:=g;
                            for k:=1 to j do
                              begin
                                a[k3]:=a[k3]-s*e[k]-a[i+k]*g;
                                k3:=k3+1
                              end
                          end
                      end;
               h:=d[l];
               d[l]:=a[i+l];
               a[i+l]:=h
             end;
           h:=d[1];
           d[1]:=a[1];
           a[1]:=h;
           e[1]:=0;
           e2[1]:=0;
           s:=d[n];
           t:=abs(e[n]);
           mn:=s-t;
           ma:=s+t;
           for i:=n-1 downto 1 do
             begin
               u:=abs(e[i]);
               h:=t+u;
               t:=u;
               s:=d[i];
               u:=s-h;
               if u<mn
                 then mn:=u;
               u:=s+h;
               if u>ma
                 then ma:=u
             end;
           for i:=1 to n do
             begin
               lb[i]:=mn;
               x[i]:=ma
             end;
           norm:=abs(mn);
           s:=abs(ma);
           if s>norm
             then norm:=s;
           w:=ma;
           lambda:=norm;
           for k:=k2 downto k1 do
             begin
               eps:=7.28e-17*norm;
               s:=mn;
               i:=k;
               repeat
                 cond:=true;
                 g:=lb[i];
                 if s<g
                   then s:=g
                   else begin
                          i:=i-1;
                          if i>=k1
                            then cond:=false
                        end
               until cond;
               g:=x[k];
               if w>g
                 then w:=g;
               while w-s>2.91e-16*(abs(s)+abs(w))+eps do
                 begin
                   l1:=0;
                   g:=1;
                   t:=0.5*(s+w);
                   for i:=1 to n do
                     begin
                       if g<>0
                         then g:=e2[i]/g
                         else g:=abs(6.87e15*e[i]);
                       g:=d[i]-t-g;
                       if g<0
                         then l1:=l1+1
                     end;
                   if l1<k1
                     then begin
                            s:=t;
                            lb[k1]:=s
                          end
                     else if l1<k
                            then begin
                                   s:=t;
                                   lb[l1+1]:=s;
                                   if x[l1]>t
                                     then x[l1]:=t
                                 end
                            else w:=t
                 end;
               u:=0.5*(s+w);
               x[k]:=u;
               if vec
                 then begin
                        eps:=eps+eps;
                        lambda:=lambda-eps;
                        if u<lambda
                          then lambda:=u;
                        t:=d[1]-lambda;
                        u:=e[2];
                        ei:=u;
                        if u=0
                          then begin
                                 u:=eps;
                                 ei:=u
                               end;
                        for i:=2 to n do
                          begin
                            if i=n
                              then ei1:=eps
                              else ei1:=e[i+1];
                            if ei1=0
                              then ei1:=eps;
                            inti:=abs(ei)>=abs(t);
                            int[i]:=inti;
                            if inti
                              then begin
                                     mi:=t/ei;
                                     if (mi=0) and (ei<=eps)
                                       then mi:=1;
                                     m[i]:=mi;
                                     p[i-1]:=ei;
                                     qi:=d[i]-lambda;
                                     q[i-1]:=qi;
                                     t:=u-mi*qi;
                                     r[i-1]:=ei1;
                                     u:=-mi*ei1
                                   end
                              else begin
                                     mi:=ei/t;
                                     m[i]:=mi;
                                     p[i-1]:=t;
                                     q[i-1]:=u;
                                     r[i-1]:=0;
                                     t:=d[i]-lambda-mi*u;
                                     u:=ei1
                                   end;
                            ei:=ei1
                          end;
                        p[n]:=t;
                        q[n]:=0;
                        r[n]:=0;
                        ei:=0;
                        ei1:=0;
                        h:=0;
                        g:=1/n;
                        for i:=n downto 1 do
                          begin
                            t:=g;
                            auxproc;
                            h:=h+abs(qi)
                          end;
                        h:=1/h;
                        v[1]:=v[1]*h;
                        for i:=2 to n do
                          begin
                            ei:=v[i]*h;
                            if int[i]
                              then begin
                                     t:=v[i-1];
                                     v[i-1]:=ei;
                                     v[i]:=t-m[i]*ei
                                   end
                              else v[i]:=ei-m[i]*v[i-1]
                          end;
                        ei:=0;
                        ei1:=0;
                        h:=0;
                        for i:=n downto 1 do
                          begin
                            t:=v[i];
                            auxproc;
                            h:=h+qi*qi
                          end;
                        h:=1/sqrt(h);
                        for i:=1 to n do
                          v[i]:=h*v[i];
                        i:=3;
                        for l:=3 to n do
                          begin
                            l1:=l-1;
                            s:=a[i+l1];
                            if s<>0
                              then begin
                                     h:=s*e[l];
                                     s:=0;
                                     for j:=1 to l1 do
                                       s:=s+a[i+j]*v[j];
                                     s:=s/h;
                                     for j:=1 to l1 do
                                       v[j]:=v[j]+s*a[i+j]
                                   end;
                            i:=i+l
                          end;
                        for l:=1 to n do
                          y[k,l]:=v[l]
                      end
             end
         end
    else st:=1
end;