procedure Gram (n       : Integer;
                x1,h    : Extended;
                var f   : vector;
                m       : Integer;
                xx      : Extended;
                var g   : vector1;
                var y   : Extended;
                var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Gram finds a polynomial g[1]+g[2]*x+...+g[m+1]*x^m, which  }
{  approximates a function given by its values f[i] at points x[i]=x1+ih    }
{  (i=1,2,...,n; m<n), and calculates the value of this polynomial at a     }
{  given point xx.                                                          }
{  Data:                                                                    }
{    n  - number of nodes,                                                  }
{    x1 - the value of the first node,                                      }
{    h  - the distance between succeeding nodes,                            }
{    f  - an array containing the values of function at nodes,              }
{    m  - the degree of polynomial which should be found,                   }
{    xx - the point at which the value of polynomial should be calculated.  }
{  Results:                                                                 }
{    g - an array of coefficients of the polynomial,                        }
{    y - the value of polynomial at xx.                                     }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure Gram is assigned the      }
{           value of:                                                       }
{             1, if m<1                                                     }
{             2, if m>=n,                                                   }
{             3, if h<=0,                                                   }
{             0, otherwise.                                                 }
{           Note: If st<>0, then y and the elements of array g are not      }
{                 calculated.                                               }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qm1], where q1<=1   }
{              and qm1>=m+1.                                                }
{                                                                           }
{---------------------------------------------------------------------------}
var cz,i,j,k,l       : Integer;
    g1,q,q1,wc,ws,xp : Extended;
    w                : vector1;
function fk (q : Extended) : Extended;
var l,zn  : Integer;
    s,sum : Extended;
begin
  sum:=1;
  zn:=1;
  s:=1;
  for l:=1 to k do
    begin
      s:=s*(k-l+1)*(k+l)*(q-l+1)/(l*l*(n-l));
      zn:=-zn;
      sum:=sum+zn*s
    end;
  fk:=sum
end {fk};
begin
  st:=0;
  if m<1
    then st:=1
    else if m>=n
           then st:=2
           else if h<=0
                  then st:=3;
  if st=0
    then begin
           for i:=1 to m+1 do
             begin
               g[i]:=0;
               w[i]:=0
             end;
           y:=0;
           q1:=(xx-x1)/h;
           for k:=0 to m do
             begin
               ws:=0;
               wc:=0;
               for i:=1 to n do
                 begin
                   q:=i-1;
                   g1:=fk(q);
                   ws:=ws+g1*g1;
                   wc:=wc+f[i]*g1
                 end;
               g[1]:=g[1]+wc/ws;
               if k<>0
                 then begin
                        cz:=1;
                        for l:=1 to k do
                          begin
                            w[1]:=-x1/h;
                            w[2]:=1/h;
                            for i:=1 to l-1 do
                              begin
                                xp:=x1+i*h;
                                w[i+2]:=w[i+1]/h;
                                for j:=i+1 downto 2 do
                                  w[j]:=(w[j-1]-w[j]*xp)/h;
                                w[1]:=-w[1]*xp/h
                              end;
                            cz:=-cz;
                            g1:=1;
                            for i:=1 to l do
                              g1:=g1*(k-i+1)*(k+i)/(i*i*(n-i));
                            g1:=g1*cz*wc/ws;
                            for i:=1 to l+1 do
                              begin
                                w[i]:=w[i]*g1;
                                g[i]:=g[i]+w[i]
                              end
                          end;
                        g1:=fk(q1)
                      end;
               y:=y+wc*g1/ws
             end
         end
end;