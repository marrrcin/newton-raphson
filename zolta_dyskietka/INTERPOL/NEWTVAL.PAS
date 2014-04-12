function Newtonvalue (n      : Integer;
                      x      : vector1;
                      f      : vector;
                      xx     : Extended;
                      var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Newtonvalue calculates the value of a polynomial given by   }
{  Newton's interpolatory divided-difference formula.                       }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the degree of polynomial   }
{         is at most n),                                                    }
{    x  - an array containing the values of nodes,                          }
{    f  - an array of divided differences (the element f[i] should contain  }
{         the value of (x[i],x[i+1],...,x[n];f); i=0,1,...,n).              }
{    xx - the point at which the value of interpolating polynomial should   }
{         be calculated.                                                    }
{  Result:                                                                  }
{    Newtonvalue(n,x,f,xx,st) - the value of polynomial at xx.              }
{  Other parameters:                                                        }
{    st - a variable which within the function Newtonvalue is assigned the  }
{         value of:                                                         }
{           1, if n<0,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then Newtonvalue(n,x,f,xx,st) is not calculated.   }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i : Integer;
    v : Extended;
begin
  if n<0
    then st:=1
    else begin
           st:=0;
           v:=f[0];
           for i:=1 to n do
             v:=v*(xx-x[i])+f[i];
           Newtonvalue:=v
         end
end;