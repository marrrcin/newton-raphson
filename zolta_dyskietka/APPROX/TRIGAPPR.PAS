procedure trigpolapprox (n       : Integer;
                         var f   : vector;
                         k       : Integer;
                         var a,b : vector0;
                         var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure trigpolapprox calculates the Euler-Fourier coefficients of }
{  trigonometric polynomial which approximates a periodic function given by }
{  its values f[i] at the nodes 2*(i-1)*pi/n (i=1,2,...,n).                 }
{  Data:                                                                    }
{    n - number of nodes,                                                   }
{    f - an array containing the values of function at nodes,               }
{    k - the degree of the trigonometric polynomial.                        }
{  Results:                                                                 }
{    a,b - arrays of coefficients of the trigonometric polynomial.          }
{  Other parameters:                                                        }
{    st - a variable which within the procedure trigpolapprox is assigned   }
{         the value of:                                                     }
{           1, if k<0 or 2*k>=n-1,                                          }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of array a and b are not         }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector0 - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j            : Integer;
    p,pp,s1,s2,x,y : Extended;
begin
  if (k<0) or (2*k>=n-1)
    then st:=1
    else begin
           st:=0;
           pp:=0;
           for j:=1 to n do
             pp:=pp+f[j];
           a[0]:=pp/n;
           x:=2*pi/n;
           y:=2/n;
           for i:=1 to k do
             begin
               s1:=0;
               s2:=0;
               for j:=1 to n do
                 begin
                   pp:=f[j];
                   p:=x*i*(j-1);
                   s1:=s1+pp*cos(p);
                   s2:=s2+pp*sin(p)
                 end;
               a[i]:=y*s1;
               b[i]:=y*s2
             end
         end
end;