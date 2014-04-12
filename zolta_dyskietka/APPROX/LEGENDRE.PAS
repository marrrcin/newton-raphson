procedure Legendre (n1     : Integer;
                    f      : fx;
                    x1,x2  : Extended;
                    eps    : Extended;
                    m      : Integer;
                    var a  : vector;
                    var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Legendre approximates a continuous function f(x), where    }
{  x1<=x<=x2, by Legendre's polynomials.                                    }
{  Data:                                                                    }
{    n1 - number of coefficients of approximation polynomial = the degree   }
{         of approximation polynomial plus 1,                               }
{    f  - a Turbo Pascal function which calculates the value of function f  }
{         at x,                                                             }
{    x1 - the beginning of approximation interval,                          }
{    x2 - the end of approximation interval.                                }
{         Note: For composite functions the approximation interval [x1,x2]  }
{               should be small.                                            }
{  Result:                                                                  }
{    a - an array of coefficients of approximation polynomial (the element  }
{        a[i+1] contains the value of the i-th coefficient; i=0,1,...,n1-1).}
{  Other parameters:                                                        }
{    eps  - relative accuracy for calculating integrals which appear in the }
{           method,                                                         }
{    m    - maximum number of steps in Simpson's method which is used to    }
{           find integrals,                                                 }
{    st   - a variable which within the procedure Legendre is assigned the  }
{           value of:                                                       }
{             1, if n1<1,                                                   }
{             2, if x2<=x1,                                                 }
{             3, if in m steps of Simpson's method for at least one of      }
{                integrals the given accuracy eps is not achieved,          }
{             0, otherwise.                                                 }
{           Note: If st=1 or st=2, then the elements of array a are not     }
{                 calculated. If st=3, then the calculations are continued  }
{                 and the last approximations to integrals are taken as     }
{                 their values.                                             }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n1,                                                 }
{    vector1 - a type identifier of extended array [q1..qm], where q1<=1    }
{              and qm>=m,                                                   }
{    matrix  - a type identifier of extended array [q1..qn1,q1..qn1], where }
{              q1<=1 and qn1>=n1,                                           }
{    fx      - a procedural-type identifier defined as follows              }
{                type fx = function (x : Extended) : Extended;              }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ii,ip,j,jp,k,m1,n2                                      : Integer;
    ak,ba4i,bk,b1,b2,epsp,faj,famj,fbj,fmbj,fmj,lei,lej,wa,wb : Extended;
    cond                                                      : Boolean;
    ba4,d4,fa,fam,fb,fm,fmb,le                                : vector1;
    p                                                         : matrix;
function f1 (x : Extended) : Extended;
var i,ip,j,jp,jpp : Integer;
    fp,mx         : Extended;
begin
  fp:=0;
  ip:=(ii+1) div 2;
  if odd(ii)
    then jp:=2
    else jp:=1;
  for j:=1 to ip do
    begin
      jpp:=2*j-jp;
      if jpp=0
        then fp:=fp+p[ii,1]
        else begin
               mx:=1;
               for i:=1 to jpp do
                 mx:=mx*x;
               fp:=fp+p[ii,j]*mx
             end
    end;
  f1:=fp*f((x-wb)/wa)
end {f1};
begin
  st:=0;
  if n1<1
    then st:=1
    else if x2=x1
           then st:=2;
  if st=0
    then begin
           n2:=(n1+1) div 2;
           p[1,1]:=1;
           if n1>1
             then begin
                    p[2,1]:=1;
                    for i:=3 to n1 do
                      begin
                        b2:=1/(i-1);
                        b1:=2-b2;
                        b2:=b2-1;
                        if odd(i)
                          then begin
                                 p[i,1]:=p[i-2,1]*b2;
                                 ip:=(i-1) div 2;
                                 for j:=2 to ip do
                                   p[i,j]:=p[i-1,j-1]*b1+p[i-2,j]*b2;
                                 p[i,ip+1]:=p[i-1,ip]*b1
                               end
                          else begin
                                 ip:=i div 2;
                                 for j:=1 to ip-1 do
                                   p[i,j]:=p[i-1,j]*b1+p[i-2,j]*b2;
                                 p[i,ip]:=p[i-1,ip]*b1
                               end
                      end
                  end;
           wa:=2/(x2-x1);
           wb:=1-wa*x2;
           for ii:=1 to n1 do
             begin
               epsp:=eps;
               m1:=m;
               ak:=-1;
               bk:=1;
               j:=1;
               ba4i:=0.25*(bk-ak);
               ba4[1]:=ba4i;
               faj:=f1(ak);
               fa[1]:=faj;
               famj:=f1(ak+ba4i);
               fam[1]:=famj;
               fmj:=f1(ak+ba4i+ba4i);
               fm[1]:=fmj;
               fmbj:=f1(bk-ba4i);
               fmb[1]:=fmbj;
               fbj:=f1(bk);
               fb[1]:=fbj;
               epsp:=36*epsp*ba4i*(abs(faj)+abs(famj)+abs(fmj)+abs(fmbj)
                     +abs(fbj));
               le[1]:=ak;
               faj:=faj+fbj;
               famj:=4*(famj+fmbj);
               d4[1]:=ba4i*(faj-famj+6*fmj);
               ak:=ba4i*(faj+fmj+fmj+famj);
               repeat
                 faj:=0;
                 bk:=-1;
                 for k:=j downto 1 do
                   begin
                     fmj:=abs(d4[k]);
                     faj:=faj+fmj;
                     if fmj>bk
                       then begin
                              bk:=fmj;
                              i:=k
                            end
                   end;
                 cond:=true;
                 if faj<=epsp
                   then m1:=j
                   else if j<m1
                          then begin
                                 j:=j+1;
                                 fbj:=fb[i];
                                 fb[j]:=fbj;
                                 fmj:=fmb[i];
                                 fm[j]:=fmj;
                                 faj:=fm[i];
                                 fa[j]:=faj;
                                 fb[i]:=faj;
                                 ba4i:=ba4[i];
                                 lei:=le[i];
                                 lej:=lei+ba4i+ba4i;
                                 le[j]:=lej;
                                 ba4i:=0.5*ba4i;
                                 ba4[i]:=ba4i;
                                 ba4[j]:=ba4i;
                                 famj:=f1(lej+ba4i);
                                 fam[j]:=famj;
                                 fmbj:=f1(lej+3*ba4i);
                                 fmb[j]:=fmbj;
                                 fbj:=ba4i*(faj+fbj-4*(famj+fmbj)+6*fmj);
                                 d4[j]:=fbj;
                                 fmj:=fam[i];
                                 fm[i]:=fmj;
                                 famj:=f1(lei+ba4i);
                                 fam[i]:=famj;
                                 fmbj:=f1(lej-ba4i);
                                 fmb[i]:=fmbj;
                                 faj:=ba4i*(fa[i]+faj-4*(famj+fmbj)+6*fmj);
                                 d4[i]:=faj;
                                 ak:=ak-fbj-faj;
                                 cond:=false
                               end
                          else st:=3
               until cond;
               bk:=0;
               for k:=j downto 1 do
                 bk:=bk+d4[k];
               a[ii]:=(ak/3-bk/45)*(ii-0.5)
             end;
           for i:=1 to n1 do
             begin
               ip:=(i+1) div 2;
               a[i]:=a[i]*p[i,ip];
               j:=i+2;
               while j<=n1 do
                 begin
                   a[i]:=a[i]+a[j]*p[j,ip];
                   j:=j+2
                 end
             end;
           jp:=n1-1;
           for i:=jp downto 1 do
             begin
               a[i]:=a[i+1]*wb+a[i];
               for j:=i+1 to jp do
                 a[j]:=a[j]*wa+a[j+1]*wb;
               a[n1]:=a[n1]*wa
             end
         end
end;