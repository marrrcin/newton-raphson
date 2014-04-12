function Hyman (n       : Integer;
                var b   : matrix;
                lambda0 : Extended;
                it      : Integer;
                eps     : Extended;
                var st  : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Hyman calculates one eigenvalue of the Hessenberg matrix by }
{  Hyman's method.                                                          }
{  Data:                                                                    }
{    n       - number of rows (column) of the given Hessenberg matrix,      }
{    b       - an array containing the values of the elements of the given  }
{              Hessenberg matrix,                                           }
{    lambda0 - an initial approximation to the eigenvalue,                  }
{    it      - maximum number of iterations to find the eigenvalue,         }
{    eps     - absolute accuracy for finding the eigenvalue.                }
{  Result:                                                                  }
{    Hyman(n,b,lambda0,it,eps,st) - the eigenvalue of the given Hessenberg  }
{                                   matrix.                                 }
{  Other parameters:                                                        }
{    st   - a variable which within the function Hyman is assigned the      }
{           value of:                                                       }
{             1, if n<1,                                                    }
{             2, if there exists b[l,l-1] equal to 0 (l=2,3,...,n),         }
{             3, if division by zero occurs in the iteration process used,  }
{             4, if the given accuracy is not achieved in it iterations,    }
{             0, otherwise.                                                 }
{           Note: If st=1, 2 or 3, then Hyman(n,b,lambda0,it,eps,st) is not }
{                 calculated, and if st=4, then the function Hyman yields   }
{                 the last approximation to the eigenvalue.                 }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ip,j,count : Integer;
    l,lp,m,s     : Extended;
    x            : vector;
begin
  st:=0;
  if n<1
    then st:=1
    else begin
           i:=2;
           while (i<=n) and (st=0) do
             begin
               if b[i,i-1]=0
                 then st:=2;
               i:=i+1
             end
         end;
  if st=0
    then begin
           count:=0;
           repeat
             count:=count+1;
             m:=lambda0;
             if count>it
               then begin
                      Hyman:=m;
                      st:=4
                    end
               else begin
                      x[n]:=1;
                      for i:=n-1 downto 1 do
                        begin
                          ip:=i+1;
                          s:=0;
                          for j:=i+2 to n do
                            s:=s-b[ip,j]*x[j];
                          x[i]:=(s-(b[ip,ip]-m)*x[ip])/b[ip,i]
                        end;
                      l:=(b[1,1]-m)*x[1];
                      for i:=2 to n do
                        l:=l+b[1,i]*x[i];
                      x[n]:=1/b[n,n-1];
                      for i:=n-1 downto 2 do
                        begin
                          s:=0;
                          for j:=i+1 to n-1 do
                            s:=s-b[i,j]*x[j+1];
                          x[i]:=(x[i]+s-(b[i,i]-m)*x[i+1])/b[i,i-1]
                        end;
                      lp:=(b[1,1]-m)*x[2]-x[1];
                      for i:=2 to n-1 do
                        lp:=lp+b[1,i]*x[i+1];
                      if lp=0
                        then st:=3
                        else lambda0:=m-l/lp
                    end
           until (abs(lambda0-m)<=eps) or (st<>0);
           if st=0
             then Hyman:=lambda0
         end
end;