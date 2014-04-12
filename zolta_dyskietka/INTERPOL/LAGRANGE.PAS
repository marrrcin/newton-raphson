function Lagrange (n       : Integer;
                   var x,f : vector;
                   xx      : Extended;
                   var st  : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Lagrange calculates the value of a polynomial given by      }
{  Lagrange's interpolation formula.                                        }
{  Data:                                                                    }
{    n  - number of interpolation nodes minus 1 (the degree of polynomial   }
{         is at most n,                                                     }
{    x  - an array containing the values of interpolation nodes,            }
{    f  - an array containing the values of function,                       }
{    xx - the point at which the value of the Lagrange interpolating        }
{         polynomial should be calculated.                                  }
{  Result:                                                                  }
{    Lagrange(n,x,f,xx,st) - the value of the Lagrange interpolating        }
{                            polynomial at xx.                              }
{  Other parameters:                                                        }
{    st - a variable which within the function Lagrange is assigned the     }
{         value of:                                                         }
{           1, if n<0,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such      }
{              that x[i]=x[j],                                              }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then Lagrange(n,x,f,xx,st) is not          }
{               calculated.                                                 }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k  : Integer;
    fx,p : Extended;
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
                    fx:=0;
                    for i:=0 to n do
                      begin
                        p:=1;
                        for k:=0 to n do
                          if k<>i
                            then p:=p*(xx-x[k])/(x[i]-x[k]);
                        fx:=fx+f[i]*p
                      end;
                    Lagrange:=fx
                  end
         end
end;