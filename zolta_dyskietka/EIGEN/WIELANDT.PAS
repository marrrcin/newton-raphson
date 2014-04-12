procedure Wielandt (n       : Integer;
                    var d,e : vector;
                    m1,m2   : Integer;
                    var x   : vector;
                    norm    : Extended;
                    var y   : matrix;
                    var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Wielandt calculates the eigenvectors for a symmetric       }
{  tridiagonal matrix B by Wielandt's method.                               }
{  Data:                                                                    }
{    n     - number of rows (columns) of matrix B,                          }
{    d     - an array containing the values of the diagonal elements of     }
{            matrix B,                                                      }
{    e     - an array the elements e[i] (i=2,3,...,n) of which contain the  }
{            values of elements below (above) the main diagonal of matrix B,}
{    m1,m2 - the ordered numbers of the smallest and the largest eigenvalue }
{            which should be calculated (fulfilling the condition           }
{            1<=m1<=m2<=n),                                                 }
{    x     - an array the elements x[m1],x[m1+1],...,x[m2] of which contain }
{            the eigenvalues of matrix B ordered from the smallest,         }
{    norm  - any norm of matrix B which is consistent with the vector norm. }
{  Result:                                                                  }
{    y - an array containing the eigenvectors (the element y[k,i] contains  }
{        the i-th component of the k-th eigenvector corresponding to the    }
{        k-th eigenvalue; k=m1,m1+1,...,m2; i=1,2,...,n).                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Wielandt is assigned the    }
{         value of:                                                         }
{           1, if the condition 1<=m1<=m2<=n is not fulfilled,              }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array y are not calculated.   }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of Boolean array [q1..qn], where q1<=1 and }
{              qn>=n,                                                       }
{    matrix  - a type identifier of extended array [q1..qn,q1..qn], where   }
{              q1<=1 and qn>=n.                                             }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j                                  : Integer;
    ei,ei1,eps,eta,h,lambda,mi,pi,qi,u,v : Extended;
    inti                                 : Boolean;
    ev,m,p,q,r                           : vector;
    int                                  : vector1;
procedure auxproc;
begin
  u:=u-q[i]*ei-r[i]*ei1;
  pi:=p[i];
  if pi=0
    then qi:=eps
    else qi:=pi;
  qi:=u/qi;
  ev[i]:=qi;
  ei1:=ei;
  ei:=qi
end {auxproc};
begin
  if (1<=m1) and (m1<=m2) and (m2<=n)
    then begin
           st:=0;
           lambda:=norm;
           eps:=1.46e-16*norm;
           for j:=m2 downto m1 do
             begin
               lambda:=lambda-eps;
               v:=x[j];
               if v<lambda
                 then lambda:=v;
               u:=d[1]-lambda;
               v:=e[2];
               ei:=v;
               if v=0
                 then begin
                        v:=eps;
                        ei:=v
                      end;
               for i:=2 to n do
                 begin
                   if i=n
                     then ei1:=eps
                     else ei1:=e[i+1];
                   if ei1=0
                     then ei1:=eps;
                   inti:=abs(ei)>=abs(u);
                   int[i]:=inti;
                   if inti
                     then begin
                            mi:=u/ei;
                            if (mi=0) and (ei<=eps)
                              then mi:=1;
                            m[i]:=mi;
                            p[i-1]:=ei;
                            qi:=d[i]-lambda;
                            q[i-1]:=qi;
                            u:=v-mi*qi;
                            r[i-1]:=ei1;
                            v:=-mi*ei1
                          end
                     else begin
                            mi:=ei/u;
                            m[i]:=mi;
                            p[i-1]:=u;
                            q[i-1]:=v;
                            r[i-1]:=0;
                            u:=d[i]-lambda-mi*v;
                            v:=ei1
                          end;
                   ei:=ei1
                 end;
               p[n]:=u;
               q[n]:=0;
               r[n]:=0;
               ei:=0;
               ei1:=0;
               h:=0;
               eta:=1/n;
               for i:=n downto 1 do
                 begin
                   u:=eta;
                   auxproc;
                   h:=h+abs(qi)
                 end;
               h:=1/h;
               ev[1]:=ev[1]*h;
               for i:=2 to n do
                 begin
                   ei:=ev[i]*h;
                   if int[i]
                     then begin
                            u:=ev[i-1];
                            ev[i-1]:=ei;
                            ev[i]:=u-m[i]*ei
                          end
                     else ev[i]:=ei-m[i]*ev[i-1]
                 end;
               ei:=0;
               ei1:=0;
               h:=0;
               for i:=n downto 1 do
                 begin
                   u:=ev[i];
                   auxproc;
                   h:=h+qi*qi
                 end;
               h:=1/sqrt(h);
               for i:=1 to n do
                 y[j,i]:=ev[i]*h
             end
         end
    else st:=1
end;