procedure GReinschcoeffns (n,m        : Integer;
                           f          : vector;
                           var a0,am1 : Extended;
                           var a,b    : vector1;
                           var st     : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure GReinschcoeffns calculates coefficients a0, am1, a[i] and  }
{  b[i] of the trigonometric polynomial a0/2 + a[1]cos(x) + b[1]sin(x) +    }
{  + ... + a[m]cos(mx) + b[m]sin(mx) + am1*cos((m+1)x)/2, where am1=0 and   }
{  m=n/2 for n even, and am1<>0 and m=(n-1)/2 for n odd. The polynomial     }
{  interpolates at x the value of function f given by its values f[i] at    }
{  the points 2i(pi)/(n+1) (i=0,1,...,n).                                   }
{  Data:                                                                    }
{    n - number of nodes minus 1,                                           }
{    m - n/2 for n even or (n-1)/2 for n odd,                               }
{    f - an array containing the values of function at the points           }
{        2i(pi)/(n+1) (i=0,1,...,n).                                        }
{  Results:                                                                 }
{    a0  - the value of coefficient a0,                                     }
{    am1 - the value of coefficient am1,                                    }
{    a,b - arrays containing coefficients a[k] and b[k] respectively        }
{          (k=1,2,...,m).                                                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure GReinschcoeffns is assigned }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           2, if m<>n/2 for n even or m<>(n-1)/2 for n odd,                }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then a0, am1 and the elements of array a   }
{               and b are not calculated.                                   }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [0..p], where p>=n,      }
{    vector1 - a type identifier of extended array [1..q], where q>=m.      }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k            : Integer;
    d,du,p,pin,u,z : Extended;
begin
  st:=0;
  if n<0
    then st:=1
    else if m<>n div 2
           then st:=2
           else begin
                  d:=0;
                  for i:=0 to n do
                    d:=d+f[i];
                  a0:=2*d/(n+1);
                  d:=2/(n+1);
                  pin:=d*Pi;
                  for k:=1 to m do
                    begin
                      z:=k*pin;
                      u:=0;
                      du:=0;
                      if cos(z)>0
                        then begin
                               p:=-4*sqr(sin(z/2));
                               for i:=n downto 0 do
                                 begin
                                   u:=du+u;
                                   du:=p*u+du+f[i]
                                 end
                             end
                        else begin
                               p:=4*sqr(cos(z/2));
                               for i:=n downto 0 do
                                 begin
                                   u:=du-u;
                                   du:=p*u-du+f[i]
                                 end
                             end;
                      a[k]:=d*(du-p*u/2);
                      b[k]:=d*u*sin(z)
                    end;
                  if not odd(n)
                    then am1:=0
                    else begin
                           z:=(m+1)*pin;
                           u:=0;
                           du:=0;
                           if cos(z)>0
                             then begin
                                    p:=-4*sqr(sin(z/2));
                                    for i:=n downto 0 do
                                      begin
                                        u:=du+u;
                                        du:=p*u+du+f[i]
                                      end
                                  end
                             else begin
                                    p:=4*sqr(cos(z/2));
                                    for i:=n downto 0 do
                                      begin
                                        u:=du-u;
                                        du:=p*u-du+f[i]
                                      end
                                  end;
                           am1:=d*(du-p*u/2)
                         end
                end
end;