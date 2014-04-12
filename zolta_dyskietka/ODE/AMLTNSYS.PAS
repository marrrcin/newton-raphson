procedure AdamsMoultonsystem (var x0    : Extended;
                              k         : Integer;
                              h         : Extended;
                              n         : Integer;
                              var y     : matrix;
                              fun,dfun  : fxysys;
                              beta      : vector;
                              rho,eps   : Extended;
                              mit       : Integer;
                              iny       : Boolean;
                              var yk    : vector1;
                              var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure AdamsMoultonsystem calculates approximate values           }
{  y[1](x0+kh), y[2](x0+kh), ..., y[n](x0+kh) of the solution of the system }
{  of differential equations y'[i]=f[i](x,y[1],y[2],...,y[n]) with the      }
{  initial conditions y[i](x0)=y0[i] by the k-step Adams-Moulton method.    }
{  Data:                                                                    }
{    x0   - the argument occurring at the initial conditions (changed on    }
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
{    dfun - a Turbo Pascal procedure which calculates df[i]/dy[i]           }
{           (i=1,2,...,n) for functions f[i] occurring in the differential  }
{           equations,                                                      }
{    beta - an array of coefficients of the k-step method,                  }
{    rho  - a normalizing coefficient of the k-step method,                 }
{    eps  - relative accuracy in the iterative process,                     }
{    mit  - maximum admissible number of iterations.                        }
{  Results:                                                                 }
{    x0 - the given value x0 plus h,                                        }
{    y  - a matrix containing the components of the solutions at the points }
{         x0+h, x0+2h, ..., x0+kh (the elements y[i,k-1], i=1,2,...,n,      }
{         contain the components of the solution calculated in the          }
{         procedure),                                                       }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    iny - a Boolean variable which should be assigned the value of true,   }
{          if in the iterative process the given values y[i,k-1] should be  }
{          taken as initial approximations to the components of solution at }
{          x0+kh, and the value of false otherwise,                         }
{    yk  - an array containing the initial approximations to the components }
{          of the solution at x0+kh (only if iny=false; changed on exit),   }
{    st  - a variable which within the procedure AdamsMoultonsystem is      }
{          assigned the value of:                                           }
{            1, if k<1 or n<1 or mit<1,                                     }
{            2, if in the iterative process the desired accuracy is not     }
{               achieved in mit iteration steps,                            }
{            0, otherwise.                                                  }
{          Note: If st<>0, then the elements of y are not changed on exit.  }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k,                                                   }
{    vector1 - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    matrix  - a type identifier of extended array [q1..qn,q0..qk1], where  }
{              q1<=1, qn>=n, q0<=0 and qk1>=k-1,                            }
{    fxysys  - a procedural-type identifier defined as follows              }
{                type fxysys = procedure (x     : Extended;                 }
{                                         n     : Integer;                  }
{                                         ya    : vector1;                  }
{                                         var f : vector1);                 }
{  Note: Any procedure passed as a parameter should be declared with a far  }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,i1,j,k1,l   : Integer;
    hb,sum,v,w,xk : Extended;
    cond          : Boolean;
    df,f,ya,yk1,z : vector1;
begin
  k1:=k-1;
  if (k1<0) or (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           if iny
             then for i:=1 to n do
                    yk[i]:=y[i,k1];
           for i:=1 to n do
             begin
               sum:=0;
               for j:=0 to k1 do
                 begin
                   l:=k1-j;
                   for i1:=1 to n do
                     ya[i1]:=y[i1,l];
                   fun (x0+l*h,n,ya,f);
                   sum:=sum+beta[j+1]*f[i]
                 end;
               z[i]:=y[i,k1]+h*sum/rho
             end;
           hb:=h*beta[0]/rho;
           xk:=x0+k*h;
           it:=0;
           repeat
             cond:=true;
             for i:=1 to n do
               begin
                 fun (xk,n,yk,f);
                 dfun (xk,n,yk,df);
                 yk1[i]:=yk[i]-(yk[i]-z[i]-hb*f[i])/(1-hb*df[i]);
                 v:=abs(yk1[i]);
                 w:=abs(yk[i]);
                 if v<w
                   then v:=w;
                 if v<>0
                   then if abs(yk1[i]-yk[i])/v>=eps
                          then cond:=false;
                 yk[i]:=yk1[i]
               end;
             it:=it+1
           until (it=mit) or cond;
           if it=mit
             then st:=2
             else begin
                    x0:=x0+h;
                    for i:=1 to n do
                      begin
                        for j:=0 to k1-1 do
                          y[i,j]:=y[i,j+1];
                        y[i,k1]:=yk[i]
                      end
                  end
         end
end;