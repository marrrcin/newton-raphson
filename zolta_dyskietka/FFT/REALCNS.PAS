procedure realcoeffns (p       : Integer;
                       y       : vector1;
                       var a,b : vector2;
                       var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure realcoeffns calculates real coefficients of the            }
{  trigonometric polynomial a[0]/2 + a[1]cos(x) + b[1]sin(x) + ... +        }
{  + a[n-1]cos((n-1)x) + b[n-1]sin((n-1)x) + a[n]cos(nx)/2 by the Cooley-   }
{  -Tukey algorithm.                                                        }
{  Data:                                                                    }
{    p - a positive integer such that n=2^p,                                }
{    y - an array containing the values of the polynomial at the points     }
{        k*pi/n (k=0,1,...,2n-1).                                           }
{  Results:                                                                 }
{    a,b - arrays containing coefficients of the polynomial (the element    }
{          a[j] contains the value of coefficient before cos(jx);           }
{          j=0,1,...,n; and the element b[j] - before sin(jx);              }
{          j=1,2,...,n-1; moreover, b[0]=b[n]=0).                           }
{  Other parameters:                                                        }
{    st - a variable which within the procedure realcoeffns is assigned the }
{         value of:                                                         }
{           1, if p<1 or p>14,                                              }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of arrays a and b are not        }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector1 - a type identifier of extended array [q0..q2n1], where q0<=0  }
{              q2n1>=2n-1=2^(p+1)-1,                                        }
{    vector2 - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n=2^p.                                               }
{                                                                           }
{---------------------------------------------------------------------------}
var j,k,k1,k2,ki,kik,l,n,n1,n2     : Integer;
    an,bre,uim,ure,vim,vre,xim,xre : Extended;
    betare,betaim                  : vector1;
begin
  if (p<1) or (p>14)
    then st:=1
    else begin
           st:=0;
           n:=1 shl p;
           n1:=n-1;
           for i:=0 to 2*n1+1 do
             begin
               betare[i]:=0;
               betaim[i]:=0
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
               k2:=2*k;
               betare[k1]:=y[k2];
               betaim[k1]:=y[k2+1]
             end;
           for j:=1 to p do
             begin
               l:=(1 shl (j-1))-1;
               k1:=1 shl j;
               an:=2*pi/k1;
               for i:=0 to l do
                 begin
                   xim:=i*an;
                   xre:=cos(xim);
                   xim:=-sin(xim);
                   k2:=k1 shr 1;
                   k:=-k1;
                   repeat
                     k:=k+k1;
                     ki:=k+i;
                     kik:=ki+k2;
                     ure:=betare[ki];
                     uim:=betaim[ki];
                     vim:=betaim[kik];
                     bre:=betare[kik];
                     vre:=bre*xre-vim*xim;
                     vim:=bre*xim+vim*xre;
                     betare[ki]:=ure+vre;
                     betaim[ki]:=uim+vim;
                     betare[kik]:=ure-vre;
                     betaim[kik]:=uim-vim
                   until k+k1>n1
                 end
             end;
           for k:=0 to n1 do
             begin
               betare[k]:=betare[k]/n;
               betaim[k]:=betaim[k]/n
             end;
           n2:=n shr 1;
           an:=pi/n;
           for j:=1 to n2-1 do
             begin
               xre:=betare[j];
               xim:=betaim[j];
               vre:=betare[n-j];
               vim:=betaim[n-j];
               ure:=xre+vre;
               uim:=xim-vim;
               vre:=xre-vre;
               vim:=xim+vim;
               bre:=cos(j*an);
               xim:=sin(j*an);
               xre:=vre*bre+vim*xim;
               xim:=vim*bre-vre*xim;
               a[j]:=(ure+xim)/2;
               a[n-j]:=(ure-xim)/2;
               b[j]:=(xre-uim)/2;
               b[n-j]:=(uim+xre)/2
             end;
           a[n2]:=betare[n2];
           b[n2]:=betaim[n2];
           ure:=betare[0];
           xim:=betaim[0];
           a[0]:=ure+xim;
           a[n]:=ure-xim;
           b[0]:=0;
           b[n]:=0
         end
end;