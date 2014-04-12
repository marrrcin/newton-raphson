procedure Newtoncoeffns (n      : Integer;
                         x      : vector1;
                         var f  : vector;
                         var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Newtoncoeffns calculates coefficients of a polynomial      }
{  given by Newton's interpolatory divided-difference formula.              }
{  Data:                                                                    }
{    n - number of nodes minus 1 (the degree of polynomial is at most n),   }
{    x - an array containing the values of nodes,                           }
{    f - an array of divided differences (the element f[i] should contain   }
{        the value of (x[i],x[i+1],...,x[n];f); i=0,1,...,n; the array is   }
{        changed on exit).                                                  }
{  Result:                                                                  }
{    f - an array of coefficients of polynomial (the element f[i] contains  }
{        the value of coefficient before x^(n-i); i=0,1,...,n).             }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Newtoncoeffns is assigned   }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1 or n=0, then f is not changed on exit.              }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=0    }
{              and qn>=n.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j : Integer;
    xi  : Extended;
begin
  if n<0
    then st:=1
    else begin
           st:=0;
           for i:=1 to n do
             begin
               xi:=x[i];
               for j:=i downto 1 do
                 f[j]:=f[j]-f[j-1]*xi
             end
         end
end;