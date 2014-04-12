procedure divdifferences (n      : Integer;
                          x      : vector;
                          var f  : vector;
                          var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure diffquotients calculates the divided differences           }
{  (x[k],x[k+1],...,x[n];f) of the values f(x[k]) for a given function f    }
{  (k=0,1,...,n).                                                           }
{  Data:                                                                    }
{    n - number of nodes minus 1,                                           }
{    x - an array containing the values of nodes,                           }
{    f - an array containing the values of function (changed on exit).      }
{  Result:                                                                  }
{    f - an array of divided differences (the element f[i] contains the     }
{        value of (x[i],x[i+1],...,x[n];f); i=0,1,...,n).                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure divdifferences is assigned  }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,n) such that }
{              x[i]=x[j],                                                   }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then the divided differences are not       }
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
             then for k:=1 to n do
                    for i:=0 to n-k do
                      f[i]:=(f[i+1]-f[i])/(x[i+k]-x[i])
         end
end;