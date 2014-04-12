procedure realvalues (p      : Integer;
                      a,b    : vector2;
                      var y  : vector1;
                      var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure realvalues calculates at the points k*pi/n                 }
{  (k=0,1,...,2n-1) the values of the trigonometric polynomial a[0]/2 +     }
{  + a[1]cos(x) + b[1]sin(x) +...+ a[n-1]cos((n-1)x) + b[n-1]sin((n-1)x) +  }
{  + a[n]cos(nx)/2 by the Cooley-Tukey algorithm.                           }
{  Data:                                                                    }
{    p - a positive integer such that n=2^p,                                }
{    a,b - arrays containing coefficients of the polynomial (the element    }
{          a[j] should contain the value of coefficient before cos(jx);     }
{          j=0,1,...,n; and the element b[j] - before sin(jx);              }
{          j=1,2,...,n-1; moreover, it should be b[0]=b[n]=0).              }
{  Results:                                                                 }
{    y - an array containing the values of the polynomial at the points     }
{        k*pi/n (k=0,1,...,2n-1).                                           }
{  Other parameters:                                                        }
{    st - a variable which within the procedure realcoeffns is assigned the }
{         value of:                                                         }
{           1, if p<1 or p>14,                                              }
{           2, if b[0]<>0 or b[n]<>0,                                       }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array y are not calculated.  }
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
  st:=0;
  if (p<1) or (p>14)
    then st:=1
    else begin
           n:=1 shl p;
           if (b[0]<>0) or (b[n]<>0)
             then st:=2
         end;
  if st=0
    then begin
           n1:=n-1;
           n2:=n shr 1;
           an:=pi/n;
           for j:=1 to n2-1 do
             begin
               ure:=a[j]+a[n-j];
               uim:=b[n-j]-b[j];
               xre:=b[j]+b[n-j];
               xim:=a[j]-a[n-j];
               bre:=cos(j*an);
               vim:=sin(j*an);
               vre:=xre*bre-xim*vim;
               vim:=xre*vim+xim*bre;
               betare[j]:=(ure+vre)/2;
               betaim[j]:=(uim+vim)/2;
               betare[n-j]:=(ure-vre)/2;
               betaim[n-j]:=(vim-uim)/2
             end;
           betare[n2]:=a[n2];
           betaim[n2]:=b[n2];
           ure:=a[0];
           uim:=a[n];
           betare[0]:=(ure+uim)/2;
           betaim[0]:=(ure-uim)/2;
           for k:=0 to n1 do
             begin
               betare[k]:=n*betare[k];
               betaim[k]:=n*betaim[k];
               betare[n+k]:=0;
               betaim[n+k]:=0
             end;
           for j:=p downto 1 do
             begin
               l:=(1 shl (j-1))-1;
               k1:=1 shl j;
               an:=2*pi/k1;
               for i:=0 to l do
                 begin
                   xim:=i*an;
                   xre:=cos(xim);
                   xim:=sin(xim);
                   k2:=k1 shr 1;
                   k:=-k1;
                   repeat
                     k:=k+k1;
                     ki:=k+i;
                     kik:=ki+k2;
                     ure:=betare[ki];
                     uim:=betaim[ki];
                     vre:=betare[kik];
                     vim:=betaim[kik];
                     betare[ki]:=(ure+vre)/2;
                     betaim[ki]:=(uim+vim)/2;
                     ure:=ure-vre;
                     uim:=uim-vim;
                     betare[kik]:=(xre*ure-xim*uim)/2;
                     betaim[kik]:=(xre*uim+xim*ure)/2
                   until k+k1>n1
                 end
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
               y[k2]:=betare[k1];
               y[k2+1]:=betaim[k1]
             end
         end
end;