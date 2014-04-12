procedure Hessenberg (n      : Integer;
                      var a  : matrix;
                      var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Hessenberg transforms a square matrix of the degree n to   }
{  the Hessenberg form.                                                     }
{  Data:                                                                    }
{    n - number of rows (columns) of the given matrix,                      }
{    a - an array containing the values of the elements of the given matrix }
{        (changed on exit).                                                 }
{  Result:                                                                  }
{    a - an array containing the values of the elements of the Hessenberg   }
{        matrix.                                                            }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure Hessenberg is assigned    }
{           the value of:                                                   }
{             1, if n<1,                                                    }
{             0, otherwise.                                                 }
{           Note: If st=1, then the elements of array a are not changed on  }
{                 exit.                                                     }
{  Unlocal identifier:                                                      }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,im,i1,j,k : Integer;
    m,s         : Extended;
begin
  if n<1
    then st:=1
    else begin
           st:=0;
           for i:=1 to n-2 do
             begin
               i1:=i+1;
               im:=i1;
               m:=abs(a[im,i]);
               for j:=i+2 to n do
                 begin
                   s:=abs(a[j,i]);
                   if s>m
                     then begin
                            im:=j;
                            m:=s
                          end
                 end;
               if m>0
                 then begin
                        if im>i1
                          then begin
                                 for j:=1 to n do
                                   begin
                                     m:=a[i1,j];
                                     a[i1,j]:=a[im,j];
                                     a[im,j]:=m
                                   end;
                                 for j:=1 to n do
                                   begin
                                     m:=a[j,i1];
                                     a[j,i1]:=a[j,im];
                                     a[j,im]:=m
                                   end
                               end;
                        for j:=i+2 to n do
                          begin
                            m:=a[j,i]/a[i1,i];
                            for k:=1 to n do
                              a[j,k]:=a[j,k]-m*a[i1,k];
                            for k:=1 to n do
                              a[k,i1]:=a[k,i1]+m*a[k,j]
                          end
                      end
             end
         end
end;