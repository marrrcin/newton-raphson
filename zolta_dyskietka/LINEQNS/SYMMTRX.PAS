procedure symmatrix (n      : Integer;
                     var a  : matrix;
                     b      : vector;
                     var x  : vector;
                     var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure symmatrix solves a system of linear equations with a       }
{  symmetric matrix.                                                        }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - two-dimensional array containing elements of the matrix of the     }
{        system (the elements a[i,j] for i>=j are changed on exit),         }
{    b - one-dimensional array containing free terms of the system.         }
{  Result:                                                                  }
{    x - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure symmatrix is assigned the   }
{         value of:                                                         }
{           1, if n<1,                                                      }
{           2, if the matrix of the system is not symmetric,                }
{           3, if at least one determinant of the form                      }
{                  | a[1,1] a[1,2] ... a[1,i] |                             }
{                  | a[2,1] a[2,2] ... a[2,i] |                             }
{                  | ........................ |                             }
{                  | a[i,1] a[i,2] ... a[i,i] |                             }
{              (i=1,2,...,n) is equal to zero,                              }
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
    u,v,z : Extended;
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
             for j:=1 to i do
               begin
                 z:=a[j,i];
                 if i=j
                   then begin
                          for k:=j-1 downto 1 do
                            begin
                              u:=a[i,k];
                              v:=u*a[k,k];
                              a[i,k]:=v;
                              z:=z-u*v
                            end;
                          if z=0
                            then st:=3
                            else a[i,i]:=1/z
                        end
                   else begin
                          for k:=j-1 downto 1 do
                            z:=z-a[i,k]*a[j,k];
                          a[i,j]:=z
                        end
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=1 to n do
                      begin
                        z:=b[i];
                        for j:=i-1 downto 1 do
                          z:=z-a[i,j]*x[j];
                        x[i]:=z
                      end;
                    for i:=n downto 1 do
                      begin
                        z:=x[i]*a[i,i];
                        for j:=i+1 to n do
                          z:=z-a[j,i]*x[j];
                        x[i]:=z
                      end
                  end
         end
end;