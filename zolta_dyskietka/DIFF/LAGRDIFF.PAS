function Lagrangediff (n       : Integer;
                       var x,y : vector;
                       xx      : Extended;
                       var st  : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Lagrangediff calculates an approximate value of derivative  }
{  f'(x) of a function f(x) given by its values at n+1 nodes using          }
{  Lagrange's interpolating formula.                                        }
{  Data:                                                                    }
{    n  - number of nodes minus 1 (the nodes are numbered from 0 to n),     }
{    x  - an array of interpolation nodes (the element x[i] should contain  }
{         the value of the i-th node; i=0,1,...,n),                         }
{    y  - an array containing the values of function at nodes (the element  }
{         y[i] should contain the value of the function at x[i];            }
{         i=0,1,...,n),                                                     }
{    xx - the point at which the derivative should be calculated.           }
{  Result:                                                                  }
{    Lagrangediff(n,x,y,xx,st) - approximate value of the derivative at xx. }
{  Other parameters:                                                        }
{    st - a variable which within the function Lagrangediff is assigned the }
{         value of:                                                         }
{           1, if n<1,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such that }
{              x[i]=x[j],                                                   }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then Lagrangediff(n,x,y,xx,st) is not      }
{               calculated.                                                 }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k      : Integer;
    dp,den,p,s : Extended;
    r          : vector;
begin
  st:=0;
  if n<1
    then st:=1
    else begin
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
           for i:=0 to n do
             r[i]:=xx-x[i];
           dp:=0;
           for i:=0 to n do
             begin
               s:=0;
               den:=1;
               for j:=0 to n do
                 if j<>i
                   then begin
                          den:=den*(x[i]-x[j]);
                          p:=1;
                          for k:=0 to n do
                            if (k<>j) and (k<>i)
                              then p:=p*r[k];
                          s:=s+p
                        end;
               dp:=dp+s*y[i]/den
             end;
           Lagrangediff:=dp
         end
end;