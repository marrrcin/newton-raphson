procedure clampedsplinecoeffns (n         : Integer;
                                x,f       : vector;
                                f1x0,f1xn : Extended;
                                var a     : matrix;
                                var st    : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure clampedsplinecoeffns calculates the coefficients of the    }
{  clamped cubic spline interpolant for a function given by its values at   }
{  nodes and values of its derivative at the ends of interval.              }
{  Data:                                                                    }
{    n    - number of interpolation nodes minus 1 (the nodes are numbered   }
{           from 0 to n),                                                   }
{    x    - an array containing the values of nodes,                        }
{    f    - an array containing the values of function,                     }
{    f1x0 - a value of derivative at x[0],                                  }
{    f1xn - a value of derivative at x[n].                                  }
{  Result:                                                                  }
{    a  - an array of spline coefficients (the element a[k,i] contains the  }
{         coefficient before x^k, where k=0,1,2,3, for the interval         }
{         <x[i], x[i+1]>; i=0,1,...,n-1).                                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure clampedsplinecoeffns is     }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array a are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q0..qn1], where q0<=0   }
{              and qn1>=n-1,                                                }
{    vector2 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [0..3, q0..qn1], where   }
{              q0<=0 and qn1>=n-1.                                          }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k        : Integer;
    u,v,y,z,xi : Extended;
    d          : vector;
    b          : vector1;
    c          : vector2;
begin
  if n<1
    then st:=1
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
           for i:=0 to n-1 do
             begin
               u:=f[i];
               xi:=x[i];
               z:=x[i+1]-xi;
               y:=d[i];
               v:=(f[i+1]-u)/z-(2*y+d[i+1])*z/6;
               z:=(d[i+1]-y)/(6*z);
               y:=y/2;
               a[0,i]:=((-z*xi+y)*xi-v)*xi+u;
               u:=3*z*xi;
               a[1,i]:=(u-2*y)*xi+v;
               a[2,i]:=y-u;
               a[3,i]:=z
             end
         end
end;