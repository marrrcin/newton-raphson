procedure invsymmatrix (n      : Integer;
                        var a  : matrix;
                        var st : integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure invsymmatrix inverts a symmetric matrix.                   }
{  Data:                                                                    }
{    n - number of rows = number of columns of a given matrix,              }
{    a - an array containing the elements of the given matrix (changed on   }
{        exit).                                                             }
{  Result:                                                                  }
{    a - two-dimensional array containing the elements of the lower         }
{        triangle of the inverse matrix (the element a[i+1,j] for           }
{        i=1,2,...,n and j=1,2,...,i contains the value of b[i,j], where    }
{        b[i,j] denotes the adequate element of the inverse matrix).        }
{  Other parameters:                                                        }
{    st - a variable which within the procedure invsymmatrix is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           2, if the given matrix is not symmetric,                        }
{           3, if at least one determinant of the form                      }
{                  | a[1,1] a[1,2] ... a[1,i] |                             }
{                  | a[2,1] a[2,2] ... a[2,i] |                             }
{                  | ........................ |                             }
{                  | a[i,1] a[i,2] ... a[i,i] |                             }
{              (i=1,2,...,n) is equal to zero,                              }
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
    u,v,z       : Extended;
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
             for j:=1 to i do
               begin
                 jh:=j+1;
                 z:=a[j,i];
                 if i=j
                   then begin
                          for k:=j-1 downto 1 do
                            begin
                              u:=a[ih,k];
                              v:=u*a[k+1,k];
                              a[ih,k]:=v;
                              z:=z-u*v
                            end;
                          if z=0
                            then st:=3
                            else a[ih,i]:=1/z
                        end
                   else begin
                          for k:=j-1 downto 1 do
                            z:=z-a[ih,k]*a[jh,k];
                          a[ih,j]:=z
                        end
               end
           until (i=n) or (st=3);
           if st=0
             then begin
                    for i:=2 to n do
                      begin
                        ih:=i+1;
                        for j:=2 to i do
                          begin
                            jh:=j-1;
                            z:=-a[ih,jh];
                            for k:=i-1 downto j do
                              z:=z-a[ih,k]*a[k+1,jh];
                            a[ih,jh]:=z
                          end
                      end;
                    for j:=1 to n do
                      for i:=j to n do
                        begin
                          ih:=i+1;
                          z:=a[ih,j];
                          if i=j
                            then for k:=ih to n do
                                   begin
                                     u:=a[k+1,j];
                                     v:=a[k+1,k]*u;
                                     a[k+1,j]:=v;
                                     z:=z+u*v
                                   end
                            else for k:=ih to n do
                                   z:=z+a[k+1,i]*a[k+1,j];
                          a[ih,j]:=z
                        end
                  end
         end
end;