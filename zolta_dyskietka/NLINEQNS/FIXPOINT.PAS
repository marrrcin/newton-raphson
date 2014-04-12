function fixedpoint (x0        : Extended;
                     g         : fx;
                     mit       : Integer;
                     eps       : Extended;
                     var fatx  : Extended;
                     var it,st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function fixedpoint finds an approximate value of the root of the    }
{  equation x=g(x) by the fixed-point algorithm.                            }
{  Data:                                                                    }
{    x0  - an initial approximation to the root,                            }
{    g   - a Turbo Pascal function which for the given value x calculates   }
{          g(x),                                                            }
{    mit - maximum number of iterations,                                    }
{    eps - absolute accuracy of the solution.                               }
{  Results:                                                                 }
{    fixedpoint(x0,g,mit,eps,fatx,it,st) - approximate value of the root,   }
{    fatx                                - the value of the function        }
{                                          f(x)=x-g(x) at the approximate   }
{                                          root,                            }
{    it                                  - number of iterations.            }
{  Other parameters:                                                        }
{    st - a variable which within the function fixedpoint is assigned the   }
{         value of:                                                         }
{           1, if mit<1,                                                    }
{           2, if the given accuracy is not achieved in mit iteration       }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1, then fixedpoint(x0,g,mit,eps,fatx,it,st) is not    }
{               calculated, and if st=2, then                               }
{               fixedpoint(x0,g,mit,eps,fatx,it,st) yields the last         }
{               approximation found.                                        }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var x : Extended;
begin
  if mit<1
    then st:=1
    else begin
           st:=2;
           it:=0;
           repeat
             it:=it+1;
             x:=g(x0);
             if Abs(x-x0)<eps
               then st:=0
               else x0:=x
           until (it=mit) or (st<>2)
         end;
  if (st=0) or (st=2)
    then begin
           fixedpoint:=x;
           fatx:=x-g(x)
         end
end;