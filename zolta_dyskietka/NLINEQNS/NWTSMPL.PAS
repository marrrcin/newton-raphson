procedure Newtonsimple (n         : Integer;
                        var x     : vector;
                        f,df      : fx;
                        omega,eps : Extended;
                        mit       : Integer;
                        var it,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Newtonsimple solves a system of n nonlinear equations of   }
{  the form f[i](x[1],x[2],...,x[n])=0 (i=1,2,...,n) by Newton's simplified }
{  method.                                                                  }
{  Data:                                                                    }
{    n     - number of equations,                                           }
{    x     - an array the elements x[i] (i=1,2,...,n ) of which contain     }
{            initial approximations to n components of the solution         }
{            (changed on exit),                                             }
{    f     - a Turbo Pascal function which calculates the value of function }
{            f[i],                                                          }
{    df    - a Turbo Pascal function which calculates the value of          }
{            derivative df[i]/dx[i],                                        }
{    omega - a parameter of iteration process,                              }
{    mit   - maximum number of iterations in the method,                    }
{    eps   - absolute accuracy of the solution.                             }
{  Results:                                                                 }
{    x  - an array containing the solution,                                 }
{    it - number of iterations.                                             }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Newtonsimple is assigned    }
{         the value of:                                                     }
{           1, if n<1 or mit<1,                                             }
{           2, if during the calculations at least one derivative in        }
{              iteration process is equal to zero,                          }
{           3, if the number of iterations is greater than mit,             }
{           0, otherwise.                                                   }
{         Note: If st=1, then x is not changed on exit and the value of it  }
{               is not calculated. If st=2 or st=3, then the array x        }
{               contains the last approximation to the solution.            }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (i,n : Integer;                          }
{                                   x   : vector) : Extended;               }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i    : Integer;
    d,w  : Extended;
    cond : Boolean;
    x1   : vector;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           st:=0;
           it:=0;
           repeat
             it:=it+1;
             if it>mit
               then begin
                      st:=3;
                      it:=it-1
                    end
               else begin
                      i:=0;
                      repeat
                        i:=i+1;
                        d:=df(i,n,x);
                        if d=0
                          then st:=2
                          else begin
                                 w:=f(i,n,x);
                                 x1[i]:=x[i]-omega*w/d
                               end
                      until (i=n) or (st=2);
                      if st=0
                        then begin
                               cond:=true;
                               i:=0;
                               repeat
                                 i:=i+1;
                                 if abs(x[i]-x1[i])>=eps
                                   then cond:=false
                               until (i=n) or not cond;
                               for i:=1 to n do
                                 x[i]:=x1[i]
                             end
                    end
           until (st<>0) or cond
         end
end;