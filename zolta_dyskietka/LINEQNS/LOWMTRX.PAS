procedure lowertrimatrix (n      : Integer;
                          a      : matrix;
                          b      : vector;
                          var x  : vector;
                          var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure lowertrimatrix solves a system of linear equations with a  }
{  lower triangular matrix.                                                 }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - two-dimensional array containing elements of the matrix of the     }
{        system,                                                            }
{    b - one-dimensional array containing free terms of the system.         }
{  Result:                                                                  }
{    x - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure lowertrimatrix is assigned  }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           2, if the matrix of the system is not a lower triangular matrix,}
{           3, if at least one matrix element lying on the main diagonal    }
{              is equal to zero,                                            }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array x are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k : Integer;
    s   : Extended;
begin
  st:=0;
  if n<1
    then st:=1;
  for i:=1 to n-1 do
    for k:=i+1 to n do
      if a[i,k]<>0
        then st:=2;
  if st=0
    then begin
           i:=0;
           repeat
             i:=i+1;
             if a[i,i]=0
               then st:=3
           until (i=n) or (st=3);
           if st=0
             then begin
                    x[1]:=b[1]/a[1,1];
                    for i:=2 to n do
                      begin
                        s:=b[i];
                        for k:=1 to i-1 do
                          s:=s-a[i,k]*x[k];
                        x[i]:=s/a[i,i]
                      end
                  end
         end
end;