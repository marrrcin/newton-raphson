procedure trimatrix (n      : Integer;
                     a      : vector;
                     var b  : vector1;
                     c      : vector2;
                     var d  : vector;
                     var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure trimatrix solves a system of linear equations with a       }
{  tridiagonal matrix by Crout's method.                                    }
{  Data:                                                                    }
{    n - number of equations = number of unknowns,                          }
{    a - an array containing elements lying on the main diagonal of the     }
{        matrix,                                                            }
{    b - an array containing elements lying above the main diagonal of the  }
{        matrix (changed on exit),                                          }
{    c - an array containing elements lying below the main diagonal of the  }
{        matrix,                                                            }
{    d - an array containing free terms of the system (changed on exit).    }
{  Result:                                                                  }
{    d - an array containing the solution.                                  }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure trimatrix is assigned the }
{           value of:                                                       }
{             1, if n<1,                                                    }
{             2, if the matrix is singular or the Crout method fails,       }
{             0, otherwise.                                                 }
{           Note: If st<>0, then the solution is not calculated (if st=2    }
{                 the elements of arrays b and d may be changed on exit).   }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    vector1 - a type identifier of extended array [q1..qn1], where q1<=1   }
{              and qn1>=n-1,                                                }
{    vector2 - a type identifier of extended array [q2..qn], where q2<=2    }
{              and qn>=n,                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i     : Integer;
    x,y,z : Extended;
begin
  if n<1
    then st:=1
    else begin
           st:=0;
           x:=a[1];
           if x=0
             then st:=2
             else begin
                    i:=0;
                    y:=d[1]/x;
                    d[1]:=y;
                    repeat
                      i:=i+1;
                      z:=b[i]/x;
                      b[i]:=z;
                      x:=a[i+1]-z*c[i+1];
                      if x=0
                        then st:=2
                        else begin
                               y:=(d[i+1]-y*c[i+1])/x;
                               d[i+1]:=y
                             end
                    until (i=n-1) or (st=2)
                  end;
           if st=0
             then begin
                    x:=d[n];
                    for i:=n-1 downto 1 do
                      begin
                        x:=d[i]-x*b[i];
                        d[i]:=x
                      end
                  end
         end
end;