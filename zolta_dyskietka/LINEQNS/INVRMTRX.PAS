procedure invrealmatrix (n        : Integer;
                         var a, b : matrix;
                         var st   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure invrealmatrix inverts a real matrix.                       }
{  Data:                                                                    }
{    n - number of rows = number of columns of a given matrix,              }
{    a - an array containing the elements of the matrix, for which the      }
{        inverse matrix should be found (changed on exit).                  }
{  Result:                                                                  }
{    b - an array representing the inverse matrix.                          }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure invrealmatrix is assigned }
{           the value of:                                                   }
{             1, if n<1,                                                    }
{             2, if the given matrix is sigular,                            }
{             0, otherwise.                                                 }
{           Note: If st<>0, then the elements of array b are not            }
{                 calculated.                                               }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of integer array [q1..qn], where q1<=1      }
{             and qn>=n,                                                    }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,k : Integer;
    m,max    : Extended;
    cond     : Boolean;
    w        : vector;
begin
  if n<1
    then st:=1
    else begin
           for i:=1 to n do
             w[i]:=i;
           cond:=true;
           k:=0;
           repeat
             k:=k+1;
             max:=abs(a[k,k]);
             ih:=k;
             for i:=k+1 to n do
               begin
                 m:=abs(a[i,k]);
                 if m>max
                   then begin
                          max:=m;
                          ih:=i
                        end
               end;
             if max=0
               then cond:=false
               else begin
                      if ih<>k
                        then begin
                               j:=w[k];
                               w[k]:=w[ih];
                               w[ih]:=j;
                               for j:=1 to n do
                                 begin
                                   m:=a[k,j];
                                   a[k,j]:=a[ih,j];
                                   a[ih,j]:=m
                                 end
                             end;
                      for i:=k+1 to n do
                        begin
                          m:=a[i,k]/a[k,k];
                          a[i,k]:=m;
                          for j:=k+1 to n do
                            a[i,j]:=a[i,j]-m*a[k,j]
                        end
                    end
           until (k=n-1) or not cond;
           if not cond or (a[n,n]=0)
             then st:=2
             else begin
                    st:=0;
                    for j:=1 to n-1 do
                      begin
                        b[j+1,j]:=-a[j+1,j];
                        for i:=j+2 to n do
                          begin
                            m:=-a[i,j];
                            for k:=j+1 to i-1 do
                              m:=m-a[i,k]*b[k,j];
                            b[i,j]:=m
                          end
                      end;
                    for j:=1 to n do
                      begin
                        b[j,j]:=1/a[j,j];
                        for i:=j-1 downto 1 do
                          begin
                            m:=0;
                            for k:=i+1 to j do
                              m:=m-a[i,k]*b[k,j];
                            b[i,j]:=m/a[i,i]
                          end
                      end;
                    for i:=1 to n do
                      for j:=1 to n do
                        if i>j
                          then begin
                                 m:=0;
                                 for k:=i to n do
                                   m:=m+b[i,k]*b[k,j];
                                 a[i,j]:=m
                               end
                          else begin
                                 m:=b[i,j];
                                 for k:=j+1 to n do
                                   m:=m+b[i,k]*b[k,j];
                                 a[i,j]:=m
                               end;
                    for k:=1 to n do
                      begin
                        j:=w[k];
                        if k=j
                          then for i:=1 to n do
                                 b[i,k]:=a[i,k]
                          else for i:=1 to n do
                                 b[i,j]:=a[i,k]
                      end
                  end
         end
end;