procedure invcomplexmatrix (n      : Integer;
                            var a  : cplxmatrix;
                            var b  : cplxmatrix;
                            var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure invcomplexmatrix inverts a complex matrix.                 }
{  Data:                                                                    }
{    n - number of rows = number of columns of a given matrix,              }
{    a - an array of records containing the elements of the matrix, for     }
{        which the inverse matrix should be found (the elements a[i,j].re   }
{        should contain the real parts of the elements, and the elements    }
{        a[i,j].im - the imaginary parts of the elements; the elements of   }
{        array a are changed on exit).                                      }
{  Result:                                                                  }
{    b - an array of records representing the inverse matrix.               }
{        Note: Each element of the inverse matrix is equal to               }
{                b[k,j].re+i*b[k,j].im,                                     }
{              where k,j=1,2,...,n and i denotes the imaginary unit.        }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure invcomplexmatrix is       }
{           assigned the value of:                                          }
{             1, if n<1,                                                    }
{             2, if the given matrix is singular or almost singular,        }
{             0, otherwise.                                                 }
{           Note: If st<>0, then the elements of array b are not            }
{                 calculated.                                               }
{  Unlocal identifiers:                                                     }
{    complex    - a type identifier of the form:                            }
{                   record                                                  }
{                     re,im : Extended                                      }
{                   end;                                                    }
{    vector     - a type identifier of integer array [q1..qn], where q1<=1  }
{                 and qn>=n,                                                }
{    cplxmatrix - a type identifier of the form:                            }
{                   array [q1..qn,q1..qn] of complex;                       }
{                 where q1<=1 and qn>=n.                                    }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,k  : Integer;
    aa,bb,c,d : complex;
    cond      : Boolean;
    w         : vector;
procedure inver (aa     : complex;
                 var bb : complex);
var alb : Boolean;
begin
  alb:=abs(aa.re)<abs(aa.im);
  if alb
    then begin
           bb.re:=aa.re;
           aa.re:=aa.im;
           aa.im:=bb.re
         end;
  bb.re:=aa.im/aa.re;
  bb.im:=1/(bb.re*aa.im+aa.re);
  bb.re:=bb.im*bb.re;
  if not alb
    then begin
           aa.re:=bb.re;
           bb.re:=bb.im;
           bb.im:=aa.re
         end
end {inver};
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
             aa.re:=0;
             ih:=k;
             for i:=k to n do
               begin
                 bb.re:=abs(a[i,k].re)+abs(a[i,k].im);
                 if bb.re>aa.re
                   then begin
                          aa.re:=bb.re;
                          ih:=i
                        end
               end;
             if aa.re=0
               then cond:=false
               else begin
                      if ih<>k
                        then begin
                               j:=w[k];
                               w[k]:=w[ih];
                               w[ih]:=j;
                               for j:=1 to n do
                                 begin
                                   aa:=a[k,j];
                                   a[k,j]:=a[ih,j];
                                   a[ih,j]:=aa
                                 end
                             end;
                      inver (a[k,k],aa);
                      for i:=k+1 to n do
                        begin
                          c:=a[i,k];
                          bb.re:=c.im*aa.im+c.re*aa.re;
                          bb.im:=c.im*aa.re-c.re*aa.im;
                          a[i,k]:=bb;
                          for j:=k+1 to n do
                            begin
                              c:=a[k,j];
                              a[i,j].re:=a[i,j].re-c.re*bb.re+c.im*bb.im;
                              a[i,j].im:=a[i,j].im-c.re*bb.im-c.im*bb.re
                            end
                        end
                    end
           until (k=n-1) or not cond;
           bb.re:=abs(a[n,n].re)+abs(a[n,n].im);
           if not cond or (bb.re=0)
             then st:=2
             else begin
                    st:=0;
                    for j:=1 to n-1 do
                      begin
                        b[j+1,j].re:=-a[j+1,j].re;
                        b[j+1,j].im:=-a[j+1,j].im;
                        for i:=j+2 to n do
                          begin
                            aa.re:=-a[i,j].re;
                            aa.im:=-a[i,j].im;
                            for k:=j+1 to i-1 do
                              begin
                                bb:=a[i,k];
                                c:=b[k,j];
                                aa.re:=aa.re-bb.re*c.re+bb.im*c.im;
                                aa.im:=aa.im-bb.re*c.im-bb.im*c.re
                              end;
                            b[i,j]:=aa
                          end
                      end;
                    for j:=1 to n do
                      begin
                        inver (a[j,j],aa);
                        b[j,j].re:=aa.re;
                        b[j,j].im:=-aa.im;
                        for i:=j-1 downto 1 do
                          begin
                            d.re:=0;
                            d.im:=0;
                            for k:=i+1 to j do
                              begin
                                bb:=a[i,k];
                                c:=b[k,j];
                                d.re:=d.re-bb.re*c.re+bb.im*c.im;
                                d.im:=d.im-bb.re*c.im-bb.im*c.re
                              end;
                            inver (a[i,i],aa);
                            b[i,j].re:=d.im*aa.im+d.re*aa.re;
                            b[i,j].im:=d.im*aa.re-d.re*aa.im
                          end
                      end;
                    for i:=1 to n do
                      for j:=1 to n do
                        if i>j
                          then begin
                                 aa.re:=0;
                                 aa.im:=0;
                                 for k:=i to n do
                                   begin
                                     bb:=b[i,k];
                                     c:=b[k,j];
                                     aa.re:=aa.re+bb.re*c.re-bb.im*c.im;
                                     aa.im:=aa.im+bb.re*c.im+bb.im*c.re
                                   end;
                                 a[i,j]:=aa
                               end
                          else begin
                                 aa:=b[i,j];
                                 for k:=j+1 to n do
                                   begin
                                     bb:=b[i,k];
                                     c:=b[k,j];
                                     aa.re:=aa.re+bb.re*c.re-bb.im*c.im;
                                     aa.im:=aa.im+bb.re*c.im+bb.im*c.re
                                   end;
                                 a[i,j]:=aa
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