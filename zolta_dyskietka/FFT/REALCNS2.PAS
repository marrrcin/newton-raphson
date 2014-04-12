procedure realcoeffns2 (p       : Integer;
                        y       : vector1;
                        var a,b : vector2;
                        var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure realcoeffns2 calculates real coefficients of the           }
{  trigonometric polynomial a[0] + a[1]cos(x) + b[1]sin(x) + ... +          }
{  + a[m-1]cos((m-1)x) + b[m-1]sin((m-1)x) + a[m]cos(mx) by the Cooley-     }
{  -Tukey algorithm.                                                        }
{  Data:                                                                    }
{    p - a positive integer such that m=2^p,                                }
{    y - an array containing the values of the polynomial at the points     }
{        -pi+k*pi/m (k=0,1,...,2m-1).                                       }
{  Results:                                                                 }
{    a,b - arrays containing coefficients of the polynomial (the element    }
{          a[j] contains the value of coefficient before cos(jx);           }
{          j=0,1,...,m; and the element b[j] - before sin(jx);              }
{          j=1,2,...,m-1; moreover, b[0]=b[m]=0).                           }
{  Other parameters:                                                        }
{    st - a variable which within the procedure realcoeffns2 is assigned    }
{         the value of:                                                     }
{           1, if p<1 or p>14,                                              }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of arrays a and b are not        }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector1 - a type identifier of extended array [q0..q2m1], where q0<=0  }
{              q2m1>=2m-1,                                                  }
{    vector2 - a type identifier of extended array [q0..qm], where q0<=0    }
{              and qm>=m,                                                   }
{    vectorm - a type identifier of extended array [q0..q2m], where q0<=0   }
{              q2m>=2m.                                                     }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,l,k,k1,k2,k3,m,m2,mm,q : Integer;
    im,re,s,s1,s2              : Extended;
    betai,betar                : vector1;
    xi,xr                      : vectorm;
begin
  if (p<1) or (p>14)
    then st:=1
    else begin
           st:=0;
           m:=1 shl p;
           m2:=2*m;
           mm:=m;
           q:=p;
           betar:=y;
           for i:=1 to m2-1 do
             betai[i]:=0;
           s:=pi/m;
           for j:=1 to mm do
             begin
               im:=j*s;
               re:=cos(im);
               im:=sin(im);
               xr[j]:=re;
               xi[j]:=im;
               i:=j+mm;
               xr[i]:=-re;
               xi[i]:=-im
             end;
           k:=0;
           xr[0]:=1;
           xi[0]:=0;
           for l:=1 to p+1 do
             begin
               while k<m2-1 do
                 begin
                   for j:=1 to mm do
                     begin
                       k1:=k shr q;
                       k2:=0;
                       k3:=0;
                       for i:=q to p do
                         begin
                           k2:=k2+((k1-k3) shr (p-i)) shl i;
                           k3:=(k1 shr (p-i)) shl (p-i)
                         end;
                       s1:=betar[k+mm];
                       s2:=betai[k+mm];
                       s:=xr[k2];
                       im:=xi[k2];
                       re:=s1*s-s2*im;
                       im:=s1*im+s2*s;
                       s1:=betar[k];
                       s2:=betai[k];
                       betar[k+mm]:=s1-re;
                       betai[k+mm]:=s2-im;
                       betar[k]:=s1+re;
                       betai[k]:=s2+im;
                       k:=k+1
                     end;
                   k:=k+mm
                 end;
               k:=0;
               mm:=mm div 2;
               q:=q-1
             end;
           while k<m2-1 do
             begin
               j:=0;
               k1:=0;
               for i:=0 to p do
                 begin
                   j:=j+((k-k1) shr (p-i)) shl i;
                   k1:=(k shr (p-i)) shl (p-i)
                 end;
               if j>k
                 then begin
                        re:=betar[j];
                        im:=betai[j];
                        betar[j]:=betar[k];
                        betai[j]:=betai[k];
                        betar[k]:=re;
                        betai[k]:=im
                      end;
               k:=k+1
             end;
           a[0]:=betar[0]/(2*m);
           a[m]:=betar[m]/(2*m);
           b[0]:=0;
           b[m]:=0;
           for i:=1 to m-1 do
             begin
               a[i]:=betar[i]/m;
               b[i]:=betai[i]/m;
               if odd(i)
                 then begin
                        a[i]:=-a[i];
                        b[i]:=-b[i]
                      end
             end
         end
end;