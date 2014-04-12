function GReinschvalue (n      : Integer;
                        f      : vector;
                        x      : Extended;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GReinschvalue calculates the value of the trigonometric     }
{  polynomial a[0]/2 + a[1]cos(x) + b[1]sin(x) +...+ a[m]cos(mx) +          }
{  + b[m]sin(mx) + a[m+1]cos((m+1)x)/2, where a[m+1]=0 and m=n/2 for n      }
{  even, and a[m+1]<>0 and m=(n-1)/2 for n odd. The polynomial interpolates }
{  a function f given by its values at the points 2i(pi)/(n+1).             }
{  Data:                                                                    }
{    n - number of nodes minus 1,                                           }
{    f - an array of values of function f at the points 2i(pi)/(n+1)        }
{        (i=0,1,...,n),                                                     }
{    x - the point at which the value of polynomial should be calculated.   }
{  Result:                                                                  }
{    GReinschvalue(n,f,x,st) - the value of trigonometric polynomial at x.  }
{  Other parameters:                                                        }
{    st - a variable which within the function GReinschvalue is assigned    }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then GReinschvalue(n,f,x,st) is not calculated.    }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k,m                 : Integer;
    a,b,d,du,fx,p,pin,u,z : Extended;
begin
  if n<0
    then st:=1
    else begin
           st:=0;
           fx:=0;
           for i:=0 to n do
             fx:=fx+f[i];
           fx:=fx/(n+1);
           m:=n div 2;
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
               a:=d*(du-p*u/2);
               b:=d*u*sin(z);
               p:=k*x;
               fx:=fx+a*cos(p)+b*sin(p)
             end;
           if odd(n)
             then begin
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
                    a:=(du-p*u/2)/(n+1);
                    fx:=fx+a*cos((m+1)*x)
                  end;
           GReinschvalue:=fx
         end
end;