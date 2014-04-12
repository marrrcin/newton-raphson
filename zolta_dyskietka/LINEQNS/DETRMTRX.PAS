function detrealmatrix (n      : Integer;
                        var a  : matrix;
                        var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function detrealmatrix calculates the determinant of a real matrix.  }
{  Data:                                                                    }
{    n - number of rows = number of columns of the given matrix,            }
{    a - an array containing the elements of the matrix (changed on exit).  }
{  Result:                                                                  }
{    detrealmatrix(n,a,st) - the value of the determinant.                  }
{  Other parameters:                                                        }
{    st - a variable which within the function detrealmatrix is assigned    }
{         the value of:                                                     }
{           1, if n<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then detrealmatrix(n,a,st) is not calculated.      }
{  Unlocal identifier:                                                      }
{    matrix - a type identifier of extended matrix [q1..qn,q1..qn], where   }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,jh,k,sd : Integer;
    m,max          : Extended;
    cond           : Boolean;
begin
  if n<1
    then st:=1
    else begin
           st:=0;
           k:=0;
           sd:=1;
           cond:=true;
           repeat
             k:=k+1;
             max:=abs(a[k,k]);
             ih:=k;
             jh:=k;
             for i:=k to n do
               for j:=k to n do
                 begin
                   m:=abs(a[i,j]);
                   if m>max
                     then begin
                            max:=m;
                            ih:=i;
                            jh:=j
                          end
                 end;
             if max=0
               then cond:=false
               else begin
                      if ih<>k
                        then begin
                               sd:=-sd;
                               for j:=k to n do
                                 begin
                                   m:=a[k,j];
                                   a[k,j]:=a[ih,j];
                                   a[ih,j]:=m
                                 end
                             end;
                      if jh<>k
                        then begin
                               sd:=-sd;
                               for i:=k to n do
                                 begin
                                   m:=a[i,k];
                                   a[i,k]:=a[i,jh];
                                   a[i,jh]:=m
                                 end
                             end;
                      for i:=k+1 to n do
                        begin
                          m:=a[i,k]/a[k,k];
                          for j:=k+1 to n do
                            a[i,j]:=a[i,j]-m*a[k,j]
                        end
                    end
           until (k=n-1) or not cond;
           if not cond or (a[n,n]=0)
             then detrealmatrix:=0
             else begin
                    m:=1;
                    for k:=1 to n do
                      m:=m*a[k,k];
                    detrealmatrix:=sd*m
                  end
         end
end;