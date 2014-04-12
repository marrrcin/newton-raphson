procedure AdamsBashforthsystem (var x0 : Extended;
                                k      : Integer;
                                h      : Extended;
                                n      : Integer;
                                var y  : matrix;
                                fun    : fxysys;
                                beta   : vector;
                                rho    : Extended;
                                var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure AdamsBashforthsystem calculates approximate values         }
{  y[1](x0+kh), y[2](x0+kh), ..., y[n](x0+kh) of the solution of the system }
{  of differential equations y'[i]=f[i](x,y[1],y[2],...,y[n]) with the      }
{  initial conditions y[i](x0)=y0[i] (i=1,2,...,n) by the k-step Adams-     }
{  -Bashforth method.                                                       }
{  Data:                                                                    }
{    x0   - the argument occurring at the initial condition (changed on     }
{           exit),                                                          }
{    k    - number of steps of the method,                                  }
{    h    - step size,                                                      }
{    n    - number of equations,                                            }
{    y    - a matrix which contains the components of the solutions at the  }
{           points x0, x0+h, x0+2h, ..., x0+(k-1)h (the element y[i,l]      }
{           should contain the value of y[i] at the point x0+lh for         }
{           i=1,2,...,n and l=0,1,...,k-1; the matrix is changed on exit),  }
{    fun  - a Turbo Pascal procedure which calculates the values of         }
{           functions occurring in the differential equations,              }
{    beta - an array of coefficients of the k-step method,                  }
{    rho  - a normalizing coefficient of the k-step method.                 }
{  Results:                                                                 }
{    x0 - the given value x0 plus h,                                        }
{    y  - a matrix containing the components of solutions at the points     }
{         x0+h, x0+2h, ..., x0+kh (the elements y[i,k-1] for i=1,2,...,n    }
{         contain the components of solution calculated in the procedure).  }
{  Other parameters:                                                        }
{    st - a variable which within the procedure AdamsBashforthsystem is     }
{         assigned the value of:                                            }
{           1, if k<1 or n<1,                                               }
{           0, otherwise.                                                   }
{         Note: If st=1, then the elements of matrix y are not changed on   }
{               exit.                                                       }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qk1], where q0<=0   }
{              and qk1>=k-1,                                                }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [q1..qn,q0..qk1], where  }
{              q1<=1, qn>=n, q0<=0 and qk1>=k-1.                            }
{    fxysys  - a procedural-type identifier defined as follows              }
{                type fxysys = procedure (x     : Extended;                 }
{                                         n     : Integer;                  }
{                                         ya    : vector1;                  }
{                                         var f : vector1);                 }
{  Note: A procedure passed as a parameter should be declared with a far    }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k1,l : Integer;
    z        : vector;
    f,ya     : vector1;
begin
  k1:=k-1;
  if (k1<0) or (n<1)
    then st:=1
    else begin
           st:=0;
           for i:=1 to n do
             z[i]:=0;
           for j:=0 to k1 do
             begin
               l:=k1-j;
               for i:=1 to n do
                 ya[i]:=y[i,l];
               fun (x0+l*h,n,ya,f);
               for i:=1 to n do
                 z[i]:=z[i]+beta[j]*f[i]
             end;
           for i:=1 to n do
             z[i]:=y[i,k1]+h*z[i]/rho;
           x0:=x0+h;
           for i:=1 to n do
             for j:=0 to k1-1 do
               y[i,j]:=y[i,j+1];
           for i:=1 to n do
             y[i,k1]:=z[i]
         end
end;