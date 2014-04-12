function clampedsplinevalue (n            : Integer;
                             x,f          : vector;
                             f1x0,f1xn,xx : Extended;
                             var st       : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function clampedsplinevalue calculates the value of the clamped      }
{  cubic spline interpolant for a function given by its values at nodes and }
{  values of its derivative at the ends of interval.                        }
{  Data:                                                                    }
{    n    - number of interpolation nodes minus 1 (the nodes are numbered   }
{           from 0 to n),                                                   }
{    x    - an array containing the values of nodes,                        }
{    f    - an array containing the values of function,                     }
{    f1x0 - a value of derivative at x[0],                                  }
{    f1xn - a value of derivative at x[n],                                  }
{    xx   - the point at which the value of interpolating spline should     }
{           be calculated.                                                  }
{  Result:                                                                  }
{    clampedsplinevalue(n,x,f,f1x0,f1xn,xx,st) - the value of clamped       }
{                                                spline at xx.              }
{  Other parameters:                                                        }
{    st - a variable which within the function clampedsplinevalue is        }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           3, if xx<x[0] or xx>x[n],                                       }
{           0, otherwise.                                                   }
{         Note: If st<>0, then clampedsplinevalue(n,x,f,xx,st) is not       }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q0..qn1], where q0<=0   }
{              and qn1>=n-1,                                                }
{    vector2 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k   : Integer;
    u,y,z : Extended;
    found : Boolean;
    a     : array [0..3] of Extended;
    d     : vector;
    b     : vector1;
    c     : vector2;
begin
  if n<1
    then st:=1
    else if (xx<x[0]) or (xx>x[n])
           then st:=3
           else begin
                  st:=0;
                  i:=-1;
                  repeat
                    i:=i+1;
                    for k:=i+1 to n do
                      if x[i]=x[k]
                        then st:=2
                  until (i=n-1) or (st=2)
                end;
  if st=0
    then begin
           b[0]:=1;
           u:=x[1]-x[0];
           d[0]:=6*((f[1]-f[0])/u-f1x0)/u;
           c[n]:=1;
           u:=x[n]-x[n-1];
           d[n]:=6*(f1xn-(f[n]-f[n-1])/u)/u;
           for i:=1 to n-1 do
             begin
               z:=x[i];
               y:=x[i+1]-z;
               z:=z-x[i-1];
               u:=f[i];
               b[i]:=y/(y+z);
               c[i]:=1-b[i];
               d[i]:=6*((f[i+1]-u)/y-(u-f[i-1])/z)/(y+z)
             end;
           u:=2;
           i:=-1;
           y:=d[0]/u;
           d[0]:=y;
           repeat
             i:=i+1;
             z:=b[i]/u;
             b[i]:=z;
             u:=2-z*c[i+1];
             y:=(d[i+1]-y*c[i+1])/u;
             d[i+1]:=y
           until i=n-1;
           u:=d[n];
           for i:=n-1 downto 0 do
             begin
               u:=d[i]-u*b[i];
               d[i]:=u
             end;
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (xx>=x[i]) and (xx<=x[i+1])
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=d[i+1];
           u:=d[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*u+z)*y/6;
           a[2]:=u/2;
           a[3]:=(z-u)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           clampedsplinevalue:=y
         end
end;