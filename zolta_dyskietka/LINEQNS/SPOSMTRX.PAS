procedure symposmatrix (n      : Integer;
                        var a  : matrix;
                        b      : vector;
                        var x  : vector;
                        var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure symposmatrix solves a system of linear equations with a    }
{  symmetric and positive definite matrix.                                  }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - two-dimensional array containing elements of the matrix of the     }
{        system (the elements a[i,j] for i>=j are changed on exit),         }
{    b - one-dimensional array containing free terms of the system.         }
{  Result:                                                                  }
{    x - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure symposmatrix is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           2, if the matrix of the system is not symmetric,                }
{           3, if the matrix of the system is not positive definite,        }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array x are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k : Integer;
    z     : Extended;
begin
  st:=0;
  if n<1
    then st:=1;
  for i:=2 to n do
    for j:=1 to i-1 do
      if a[i,j]<>a[j,i]
        then st:=2;
  if st=0
    then begin
           i:=0;
           repeat
             i:=i+1;
             for j:=i to n do
               begin
                 z:=a[i,j];
                 for k:=i-1 downto 1 do
                   z:=z-a[j,k]*a[i,k];
                 if i=j
                   then if z>0
                          then a[i,i]:=1/sqrt(z)
                          else st:=3
                   else a[j,i]:=z*a[i,i]
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=1 to n do
                      begin
                        z:=b[i];
                        for j:=i-1 downto 1 do
                          z:=z-a[i,j]*x[j];
                        x[i]:=z*a[i,i]
                      end;
                    for i:=n downto 1 do
                      begin
                        z:=x[i];
                        for j:=i+1 to n do
                          z:=z-a[j,i]*x[j];
                        x[i]:=z*a[i,i]
                      end
                  end
         end
end;