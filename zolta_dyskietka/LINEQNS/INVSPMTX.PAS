procedure invsymposmatrix (n      : Integer;
                           var a  : matrix;
                           var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure invsymposmatrix inverts a symmetric and positive definite  }
{  matrix.                                                                  }
{  Data:                                                                    }
{    n - number of rows = number of columns of a given matrix,              }
{    a - an array containing the elements of the given matrix (changed on   }
{        exit).                                                             }
{  Result:                                                                  }
{    a - a two-dimensional array containing the elements of the lower       }
{        triangle of the inverse matrix (the element a[i+1,j] for           }
{        i=1,2,...,n and j=1,2,...,i contains the value of b[i,j], where    }
{        b[i,j] denotes the adequate element of the inverse matrix).        }
{  Other parameters:                                                        }
{    st - a variable which within the procedure invsymposmatrix is assigned }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           2, if the given matrix is not symmetric,                        }
{           3, if the given matrix is not positive definite,                }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then the elements of array a are not       }
{               changed, but if st=3 these elements may be changed on       }
{               exit.                                                       }
{  Unlocal identifier:                                                      }
{    matrix - a type identifier of extended array [q1..qn1,q1..qn], where   }
{             q1<=1, qn1>=n+1 and qn>=n.                                    }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,jh,k : Integer;
    u,z         : Extended;
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
             ih:=i+1;
             for j:=i to n do
               begin
                 jh:=j+1;
                 z:=a[i,j];
                 for k:=i-1 downto 1 do
                   z:=z-a[jh,k]*a[ih,k];
                 if i=j
                   then if z>0
                          then begin
                                 u:=1/sqrt(z);
                                 a[ih,i]:=u
                               end
                          else st:=3
                   else a[jh,i]:=z*u
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=1 to n do
                      for j:=i+1 to n do
                        begin
                          z:=0;
                          jh:=j+1;
                          for k:=j-1 downto i do
                              z:=z-a[jh,k]*a[k+1,i];
                          a[jh,i]:=z*a[jh,j]
                        end;
                    for i:=1 to n do
                      for j:=i to n do
                        begin
                          z:=0;
                          jh:=n+1;
                          for k:=j+1 to jh do
                            z:=z+a[k,j]*a[k,i];
                          a[j+1,i]:=z
                        end
                  end
         end
end;