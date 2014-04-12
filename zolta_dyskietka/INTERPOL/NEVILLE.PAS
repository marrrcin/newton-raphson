function Neville (n      : Integer;
                  x      : vector;
                  xx     : Extended;
                  var f  : vector;
                  var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Neville calculates the value of interpolating polynomial by }
{  Neville's algorithm.                                                     }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the degree of polynomial   }
{         is at most n),                                                    }
{    x  - an array containing the values of interpolation nodes,            }
{    xx - the point at which the value of interpolating polynomial should   }
{         be calculated,                                                    }
{    f  - an array containing the values of function (changed on exit).     }
{  Result:                                                                  }
{    Neville(n,x,xx,f,st) - the value of interpolating polynomial at xx.    }
{  Other parameters:                                                        }
{    st - a variable which within the function Neville is assigned the      }
{         value of:                                                         }
{           1, if n<0,                                                      }
{           2, if there exist x[i] and x[j] (i<>j, i,j=0,1,...,n) such that }
{              x[i]=x[j],                                                   }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then Neville(n,x,xx,f,st) is not           }
{               calculated.                                                 }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k : Integer;
begin
  if n<0
    then st:=1
    else begin
           st:=0;
           if n>0
             then begin
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
                    for k:=1 to n do
                      for i:=n downto k do
                        f[i]:=((xx-x[i-k])*f[i]-(xx-x[i])*f[i-1])
                              /(x[i]-x[i-k]);
                    Neville:=f[n]
                  end
         end
end;