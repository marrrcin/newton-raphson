procedure complexcoeffns (p        : Integer;
                          f        : cplxvector;
                          var beta : cplxvector1;
                          var st   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure complexcoeffns calculates complex coefficients beta[j]     }
{  (j=0,1,...,n-1) of the trigonometric polynomial beta[0] + beta[1]exp(ix) }
{  + ... + beta[n-1]exp((n-1)ix), where i denotes the imaginary unit, by    }
{  the fast Fourier transforms.                                             }
{  Data:                                                                    }
{    p - a positive integer such that n=2^p,                                }
{    f - an array of records containing the complex values of the           }
{        polynomial at the points 2*k*pi/n (the element f[k].re should      }
{        contain the real part, and the element f[k].im - the imaginary     }
{        part of the adequate value; k=0,1,...,n-1).                        }
{  Result:                                                                  }
{    beta - an array of records containing complex coefficients of the      }
{           polynomial (the element beta[j].re contains the real part, and  }
{           the element beta[j].im - the imaginary part of the adequate     }
{           coefficient; j=0,1,...,n-1).                                    }
{           Note: The elements b[j] for j=n,n+1,..,2n-1 are used internally }
{                 in the procedure.                                         }
{  Other parameters:                                                        }
{    st - a variable which within the procedure complexcoeffns is assigned  }
{         the value of:                                                     }
{           1, if p<1 or p>14,                                              }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array beta are not            }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    cplxvector  - a type identifier of the form:                           }
{                    array [q0..qn1] of complex;                            }
{                  where q0<=0 and qn1>=n-1=2^p-1,                          }
{    cplxvector1 - a type identifier of the form:                           }
{                    array [q0..q2n1] of complex;                           }
{                  where q0<=0 and q2n1>=2n-1=2^(p+1)-1.                    }
{                  In both definitions of types 'complex' denotes a type    }
{                  identifier of the form:                                  }
{                    record                                                 }
{                      re,im : Extended                                     }
{                    end;                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var j,k,k1,k2,ki,kik,l,n,n1       : Integer;
    a,bre,uim,ure,vim,vre,xim,xre : Extended;
begin
  if (p<1) or (p>14)
    then st:=1
    else begin
           st:=0;
           n:=1 shl p;
           n1:=n-1;
           for i:=0 to 2*n1+1 do
             begin
               beta[i].re:=0;
               beta[i].im:=0
             end;
           for k:=0 to n1 do
             begin
               k1:=0;
               k2:=0;
               for i:=0 to p-1 do
                 begin
                   k1:=k1+((k-k2) shr (p-1-i)) shl i;
                   k2:=(k shr (p-1-i)) shl (p-1-i)
                 end;
               beta[k1].re:=f[k].re;
               beta[k1].im:=f[k].im
             end;
           for j:=1 to p do
             begin
               l:=(1 shl (j-1))-1;
               k1:=1 shl j;
               a:=2*pi/k1;
               for i:=0 to l do
                 begin
                   xim:=i*a;
                   xre:=cos(xim);
                   xim:=-sin(xim);
                   k2:=k1 shr 1;
                   k:=-k1;
                   repeat
                     k:=k+k1;
                     ki:=k+i;
                     kik:=ki+k2;
                     ure:=beta[ki].re;
                     uim:=beta[ki].im;
                     vim:=beta[kik].im;
                     bre:=beta[kik].re;
                     vre:=bre*xre-vim*xim;
                     vim:=bre*xim+vim*xre;
                     beta[ki].re:=ure+vre;
                     beta[ki].im:=uim+vim;
                     beta[kik].re:=ure-vre;
                     beta[kik].im:=uim-vim
                   until k+k1>n1
                 end
             end;
           for k:=0 to n1 do
             begin
               beta[k].re:=beta[k].re/n;
               beta[k].im:=beta[k].im/n
             end
         end
end;