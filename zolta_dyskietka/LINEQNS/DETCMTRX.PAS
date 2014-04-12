procedure detcomplexmatrix (n       : Integer;
                            var a   : cplxmatrix;
                            var det : complex;
                            var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure detcomplexmatrix calculates the determinant of a complex   }
{  matrix.                                                                  }
{  Data:                                                                    }
{    n - number of rows = number of columns of a given matrix,              }
{    a - an array of records containing the elements of the matrix, which   }
{        determinant should be found (the elements a[i,j].re should contain }
{        the real parts of the elements, and the elements a[i,j].im - the   }
{        imaginary parts of the elements; the elements of array a are       }
{        changed on exit).                                                  }
{  Result:                                                                  }
{    det - the record containing the real and imaginary part of the         }
{          determinant.                                                     }
{          Note: The value of the determinant is equal to                   }
{                  det.re+i*det.im,                                         }
{                where i denotes the imaginary unit.                        }
{  Other parameters:                                                        }
{    st - a variable which within the procedure detcomplexmatrix is         }
{         assigned the value of:                                            }
{           1, if n<1,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then det.re and det.im are not calculated.         }
{  Unlocal identifiers:                                                     }
{    complex    - a type identifier of the form:                            }
{                   record                                                  }
{                     re,im : Extended                                      }
{                   end;                                                    }
{    cplxmatrix - a type identifier of the form:                            }
{                   array [q1..qn,q1..qn] of complex;                       }
{                 where q1<=1 and qn>=n.                                    }
{                                                                           }
{---------------------------------------------------------------------------}
var i,ih,j,k : Integer;
    aa,b,c   : complex;
    alb,cond : Boolean;
begin
  if n<1
    then st:=1
    else begin
           st:=0;
           det.re:=1;
           det.im:=0;
           k:=0;
           cond:=true;
           repeat
             k:=k+1;
             aa.re:=0;
             for i:=k to n do
               begin
                 b.re:=abs(a[i,k].re)+abs(a[i,k].im);
                 if b.re>aa.re
                   then begin
                          aa.re:=b.re;
                          ih:=i
                        end
               end;
             aa:=a[ih,k];
             b.re:=det.re*aa.re-det.im*aa.im;
             det.im:=det.re*aa.im+det.im*aa.re;
             det.re:=b.re;
             if abs(det.re)+abs(det.im)=0
               then cond:=false
               else if k<n
                      then begin
                             if ih<>k
                               then begin
                                      det.re:=-det.re;
                                      det.im:=-det.im
                                    end;
                             alb:=abs(aa.re)<abs(aa.im);
                             if alb
                               then begin
                                      b.re:=aa.re;
                                      aa.re:=aa.im;
                                      aa.im:=b.re
                                    end;
                             b.re:=aa.im/aa.re;
                             aa.im:=1/(b.re*aa.im+aa.re);
                             aa.re:=aa.im*b.re;
                             if not alb
                               then begin
                                      b.re:=aa.re;
                                      aa.re:=aa.im;
                                      aa.im:=b.re
                                    end;
                             a[ih,k]:=a[k,k];
                             for j:=k+1 to n do
                               begin
                                 c:=a[ih,j];
                                 a[ih,j]:=a[k,j];
                                 b.re:=c.im*aa.im+c.re*aa.re;
                                 b.im:=c.im*aa.re-c.re*aa.im;
                                 for i:=k+1 to n do
                                   begin
                                     c:=a[i,k];
                                     a[i,j].re:=a[i,j].re-c.re*b.re
                                                +c.im*b.im;
                                     a[i,j].im:=a[i,j].im-c.re*b.im
                                                -c.im*b.re
                                   end
                               end
                           end
           until (k=n) or not cond
         end
end;