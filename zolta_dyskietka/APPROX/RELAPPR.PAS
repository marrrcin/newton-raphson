procedure relapprox (n,p       : Integer;
                     var x,f   : vector0;
                     var a     : vector;
                     var error : Extended;
                     var st    : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure relapprox calculates the coefficients of the polynomial    }
{  of best approximation (in the sense of relative uniform approximation)   }
{  for a function f(x) on a finite set x[0],x[1],...x[p] and the error of   }
{  approximation.                                                           }
{  Data:                                                                    }
{    n - the degree of the required polynomial of best approximation,       }
{    p - number of points of the given finite set (p>n) minus 1,            }
{    x - an array containing the values of points of the finite set,        }
{    f - an array containing the values of the function at the points of    }
{        the finite set (f[k] should be different from 0 for each           }
{        k=0,1,...,p).                                                      }
{        Notes: 1. The points of the given finite set should be ordered in  }
{                  such a way that x[0] < x[1] < ... < x[p] or              }
{                  x[0] > x[1] > ... > x[p].                                }
{               2. For an approximation in a closed interval, e.g. [b,c],   }
{                  there must be a finite set which is sufficiently dense   }
{                  over the whole interval [b,c], but more dense near the   }
{                  ends, e.g.                                               }
{                    x[k]=(b+c-(c-b)*cos(k*pi/p))/2; k=0,1,...,p,           }
{                  where p>n*n.                                             }
{  Results:                                                                 }
{    a     - an array of coefficients of the required polynomial,           }
{    error - error of approximation.                                        }
{  Other parameters:                                                        }
{    st - a variable which within the procedure relapprox is assigned the   }
{         value of:                                                         }
{           1, if n<0,                                                      }
{           2, if p<=n or there exists k=0,1,...,p such that f[k]=0,        }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the error and the elements of array a are    }
{               not calculated.                                             }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector0 - a type identifier of extended array [q0..qp], where q0<=0    }
{              and qp>=p,                                                   }
{    vector1 - a type identifier of integer array [q0..qn4], where q0<=0    }
{              qn4>=n+4,                                                    }
{    vector2 - a type identifier of extended array [q1..qn4], where q1<=-1  }
{              and qn4>=n+4.                                                }
{                                                                           }
{---------------------------------------------------------------------------}
var i,i1,j,k,l,n1,n2            : Integer;
    bk,cenf,d,e,exj,pre,r,sk,xk : Extended;
    cond,endi,nl,z              : Boolean;
    ind                         : vector1;
    b,nx,s                      : vector2;
procedure compr;
var k : Integer;
begin
  exj:=1.0e37;
  for k:=j-1 downto 0 do
    if s[k]<exj
      then begin
             exj:=s[k];
             i1:=k
           end;
  if i1=0
    then begin
           for k:=1 to j do
             begin
               s[k-1]:=s[k];
               ind[k-1]:=ind[k]
             end
         end
    else if (i1<j-1) or nl
           then begin
                  s[i1-1]:=s[i1-1]-s[i1]+s[i1+1];
                  for k:=i1+2 to j do
                    begin
                      s[k-2]:=s[k];
                      ind[k-2]:=ind[k]
                    end;
                  j:=j-1
                end;
  j:=j-1
end {compr};
procedure refp;
begin
  if exj>cenf
    then cenf:=exj;
  s[j]:=s[j]+exj;
  j:=j+1;
  s[j]:=exj;
  ind[j]:=i1;
  if j=n+4
    then compr
end {refp};
begin
  st:=0;
  if n<0
    then st:=1
    else if p<=n
           then st:=2
           else for i:=0 to p do
                  if f[i]=0
                    then st:=2;
  if st=0
    then begin
           error:=1.0e37;
           pre:=-1;
           n1:=n+1;
           n2:=n+2;
           l:=p-n1;
           ind[0]:=0;
           ind[n1]:=p;
           r:=x[0];
           d:=x[p];
           e:=0.5*(r+d);
           d:=0.5*(d-r);
           r:=pi/n1;
           i:=0;
           cond:=true;
           k:=1;
           while (k<=n) and cond do
             begin
               xk:=e-d*cos(k*r);
               repeat
                 i:=i+1
               until d*(x[i]-xk)>=0;
               if i<k+l
                 then ind[k]:=i
                 else begin
                        for k:=k to n do
                          ind[k]:=k+l;
                        cond:=false
                      end;
               k:=k+1
             end;
           repeat
             i:=ind[n1];
             nx[n1]:=x[i];
             b[n1]:=f[i];
             s[n1]:=f[i];
             e:=1;
             l:=n1;
             for k:=n downto 0 do
               begin
                 i:=ind[k];
                 xk:=x[i];
                 nx[k]:=xk;
                 bk:=f[i];
                 e:=-e;
                 sk:=e*bk;
                 for j:=n1 downto l do
                   begin
                     r:=nx[j]-xk;
                     bk:=(b[j]-bk)/r;
                     sk:=(s[j]-sk)/r
                   end;
                 b[k]:=bk;
                 s[k]:=sk;
                 l:=k
               end;
             e:=bk/sk;
             b[0]:=b[1]-e*s[1];
             for k:=2 to n1 do
               begin
                 xk:=nx[k];
                 bk:=b[k]-e*s[k];
                 for j:=k-1 downto 1 do
                   begin
                     r:=b[j-1];
                     b[j]:=bk-r*xk;
                     bk:=r
                   end
               end;
             j:=-1;
             e:=abs(e);
             nl:=true;
             z:=true;
             cenf:=0;
             exj:=0;
             sk:=0;
             s[-1]:=0;
             for i:=0 to p do
               begin
                 xk:=x[i];
                 d:=b[0];
                 for k:=1 to n do
                   d:=d*xk+b[k];
                 d:=1-d/f[i];
                 if (d<>0) and z
                   then begin
                          if d<0
                            then sk:=-1
                            else sk:=1;
                          if i>0
                            then sk:=-sk;
                          z:=false
                        end;
                 bk:=abs(d);
                 endi:=true;
                 if (sk*d<=0) and (i>0)
                   then begin
                          sk:=-sk;
                          refp
                        end
                   else if bk<exj
                          then endi:=false;
                 if endi
                   then begin
                          exj:=bk;
                          i1:=i
                        end
               end;
             nl:=false;
             refp;
             if cenf<error
               then begin
                      error:=cenf;
                      for k:=0 to n do
                        a[k]:=b[k]
                    end;
             cond:=true;
             if (j>n) and (e>pre)
               then begin
                      pre:=e;
                      if j>n2
                        then compr;
                      if (j=n2) and (s[0]<s[j-1])
                        then for k:=1 to j do
                               ind[k-1]:=ind[k];
                      cond:=false
                    end
           until cond
         end
end;