function periodsplinevalue (n      : Integer;
                            x,f    : vector;
                            xx     : Extended;
                            var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function periodsplinevalue calculates the value of the periodic      }
{  cubic spline interpolant for a function given by its values at nodes.    }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the nodes are numbered     }
{         from 0 to n),                                                     }
{    x  - an array containing the values of nodes,                          }
{    f  - an array containing the values of function (the value of f[0]     }
{         should be equal to the value of f[n]),                            }
{    xx - the point at which the value of interpolating spline should       }
{         be calculated.                                                    }
{  Result:                                                                  }
{    periodsplinevalue(n,x,f,xx,st) - the value of periodic spline at xx.   }
{  Other parameters:                                                        }
{    st - a variable which within the function periodsplinevalue is         }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           3, if f[0]<>f[n],                                               }
{           4, if xx<x[0] or xx>x[n],                                       }
{           0, otherwise.                                                   }
{         Note: If st<>0, then periodicsplinevalue(n,x,f,xx,st) is not      }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector2 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n-1,                                                }
{    vector3 - a type identifier of extended array [q2..qn], where q2<=2    }
{              and qn>=n.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k   : Integer;
    v,y,z : Extended;
    found : Boolean;
    a     : array [0..3] of Extended;
    u     : vector;
    b,c,d : vector1;
    p     : vector2;
    q     : vector3;
begin
  if n<1
    then st:=1
    else if f[0]<>f[n]
           then st:=3
           else if (xx<x[0]) or (xx>x[n])
                  then st:=4
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
           if n>1
             then begin
                    v:=x[1]-x[0];
                    z:=x[n]-x[n-1];
                    b[n]:=v/(z+v);
                    c[n]:=1-b[n];
                    y:=f[n];
                    d[n]:=6*((f[1]-y)/v-(y-f[n-1])/z)/(z+v);
                    for i:=1 to n-1 do
                      begin
                        z:=x[i];
                        y:=x[i+1]-z;
                        z:=z-x[i-1];
                        v:=f[i];
                        b[i]:=y/(y+z);
                        c[i]:=1-b[i];
                        d[i]:=6*((f[i+1]-v)/y-(v-f[i-1])/z)/(y+z)
                      end;
                    if n>2
                      then begin
                             u[1]:=2;
                             c[2]:=c[2]/2;
                             q[2]:=-b[n]/2;
                             for i:=2 to n-2 do
                               begin
                                 v:=2-b[i-1]*c[i];
                                 c[i+1]:=c[i+1]/v;
                                 q[i+1]:=-q[i]*b[i-1]/v;
                                 u[i]:=v
                               end;
                             v:=2-c[n-1]*b[n-2];
                             q[n]:=(c[n]-q[n-1]*b[n-2])/v;
                             u[n-1]:=v;
                             p[1]:=c[1];
                             for i:=2 to n-2 do
                               p[i]:=-c[i]*p[i-1];
                             p[n-1]:=b[n-1]-c[n-1]*p[n-2];
                             v:=2-c[1]*p[2];
                             for i:=2 to n-2 do
                               v:=v-p[i]*p[i+1];
                             u[n]:=v-p[n-1]*q[n];
                             for i:=2 to n-1 do
                               d[i]:=d[i]-c[i]*d[i-1];
                             v:=d[n];
                             for i:=2 to n do
                               v:=v-q[i]*d[i-1];
                             d[n]:=v;
                             u[n]:=d[n]/u[n];
                             u[n-1]:=(d[n-1]-p[n-1]*u[n])/u[n-1];
                             for i:=n-2 downto 1 do
                               u[i]:=(d[i]-b[i]*u[i+1]-p[i]*u[n])/u[i]
                           end
                      else begin
                             y:=d[1];
                             z:=d[2];
                             v:=4-c[2]*b[1];
                             u[1]:=(2*y-b[1]*z)/v;
                             u[2]:=(2*z-c[2]*y)/v;
                           end
                  end
             else u[1]:=0;
           u[0]:=u[n];
           found:=False;
           i:=-1;
           repeat
             i:=i+1;
             if (xx>=x[i]) and (xx<=x[i+1])
               then found:=True
           until found;
           y:=x[i+1]-x[i];
           z:=u[i+1];
           v:=u[i];
           a[0]:=f[i];
           a[1]:=(f[i+1]-f[i])/y-(2*v+z)*y/6;
           a[2]:=v/2;
           a[3]:=(z-v)/(6*y);
           y:=a[3];
           z:=xx-x[i];
           for i:=2 downto 0 do
             y:=y*z+a[i];
           periodsplinevalue:=y
         end
end;