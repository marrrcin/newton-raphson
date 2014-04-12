function Rombergdiff (x      : Extended;
                      f      : fx;
                      var h0 : Extended;
                      m      : Integer;
                      eps    : Extended;
                      var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Rombergdiff calculates an approximate value of derivative   }
{  f'(x) of a function f(x) by Romberg's method.                            }
{  Data:                                                                    }
{    x   - the point at which the derivative should be calculated,          }
{    f   - a Turbo Pascal function which for the given x calculates the     }
{          value of the function which derivative should be found,          }
{    h0  - the initial step size of calculations (may be changed on exit),  }
{    m   - a positive integer which determines how many times the initial   }
{          step h0 may be halved,                                           }
{    eps - relative accuracy of calculations (cannot exceed s*10^(-16),     }
{          where s is an approximation to f'(x)).                           }
{  Result:                                                                  }
{    Rombergdiff(x,h0,m,eps,st) - approximate value of the derivative at x. }
{  Other parameters:                                                        }
{    st - a variable which within the function Rombergdiff is assigned the  }
{         value of:                                                         }
{           1, if m<1,                                                      }
{           2, if after m steps the given accuracy eps is not achieved,     }
{           0, otherwise.                                                   }
{         Note: If st=1, then Rombergdiff(x,h0,m,eps,st) is not calculated, }
{               and if st=2, then Rombergdiff(x,h0,m,eps,st) is equal to    }
{               the last approximation found.                               }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..q6], where q0<=0 and }
{             q6>=6,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,n        : Integer;
    h,q,s,tj,tj1 : Extended;
    t            : vector;
begin
  st:=1;
  if m>=1
    then begin
           n:=1;
           repeat
             h:=h0;
             q:=f(x+h);
             s:=f(x-h);
             t[0]:=(q-s)/(2*h);
             i:=1;
             repeat
               h:=h/2;
               q:=f(x+h);
               s:=f(x-h);
               t[i]:=(q-s)/(2*h);
               q:=1;
               j:=i-1;
               repeat
                 q:=4*q;
                 tj:=t[j];
                 tj1:=t[j+1];
                 s:=tj1+(tj1-tj)/(q-1);
                 if (j=0) and (abs(s-t[0])<eps)
                   then st:=0
                   else t[j]:=s;
                 j:=j-1
               until (st=0) or (j=-1);
               i:=i+1
             until (st=0) or (i=7);
             n:=n+1;
             h0:=h0/2
           until (st=0) or (n>m);
           if n>m
             then st:=2;
           Rombergdiff:=s
         end
end;