procedure Gauss (n       : Integer;
                 var a   : matrix;
                 var b,x : vector;
                 var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Gauss solves a system of linear equations by Gaussian      }
{  elimination with partial pivoting.                                       }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - two-dimensional array containing elements of the matrix of the     }
{        system (changed on exit),                                          }
{    b - one-dimensional array containing free terms of the system (changed }
{        on exit).                                                          }
{  Result:                                                                  }
{    x - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Gauss is assigned the value }
{         of:                                                               }
{           1, if n<1,                                                      }
{           2, if the matrix is singular,                                   }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array x are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,k : Integer;
    max,s    : Extended;
    cond     : Boolean;
begin
  if n<1
    then st:=1
    else begin
           cond:=true;
           k:=0;
           repeat
             k:=k+1;
             max:=abs(a[k,k]);
             ih:=k;
             for i:=k+1 to n do
               begin
                 s:=abs(a[i,k]);
                 if s>max
                   then begin
                          max:=s;
                          ih:=i
                        end
               end;
             if max=0
               then cond:=false
               else begin
                      if ih<>k
                        then begin
                               max:=b[k];
                               b[k]:=b[ih];
                               b[ih]:=max;
                               for i:=k to n do
                                 begin
                                   max:=a[k,i];
                                   a[k,i]:=a[ih,i];
                                   a[ih,i]:=max
                                 end
                             end;
                      for i:=k+1 to n do
                        begin
                          max:=a[i,k]/a[k,k];
                          for j:=k+1 to n do
                            a[i,j]:=a[i,j]-max*a[k,j];
                          b[i]:=b[i]-max*b[k]
                        end
                    end
           until (k=n-1) or not cond;
           if not cond or (a[n,n]=0)
             then st:=2
             else begin
                    st:=0;
                    x[n]:=b[n]/a[n,n];
                    for i:=n-1 downto 1 do
                      begin
                        s:=b[i];
                        for k:=i+1 to n do
                          s:=s-a[i,k]*x[k];
                        x[i]:=s/a[i,i]
                      end
                  end
         end
end;