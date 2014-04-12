function Steffensen (x0        : Extended;
                     g         : fx;
                     mit       : Integer;
                     eps       : Extended;
                     var fatx  : Extended;
                     var it,st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Steffensen finds an approximate value of the root of the    }
{  equation x=g(x) by the Steffensen algorithm.                             }
{  Data:                                                                    }
{    x0  - an initial approximation to the root,                            }
{    g   - a Turbo Pascal function which for the given value x calculates   }
{          g(x),                                                            }
{    mit - maximum number of iterations,                                    }
{    eps - absolute accuracy of the solution.                               }
{  Results:                                                                 }
{    Steffensen(x0,g,mit,eps,fatx,it,st) - approximate value of the root,   }
{    fatx                                - the value of the function        }
{                                          f(x)=x-g(x) at the approximate   }
{                                          root,                            }
{    it                                  - number of iterations.            }
{  Other parameters:                                                        }
{    st - a variable which within the function Steffensen is assigned the   }
{         value of:                                                         }
{           1, if mit<1,                                                    }
{           2, if the given accuracy is not achieved in mit iteration       }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1, then Steffensen(x0,g,mit,eps,fatx,it,st) is not    }
{               calculated, and if st=2, then                               }
{               Steffensen(x0,g,mit,eps,fatx,it,st) yields the last         }
{               approximation found.                                        }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var x,x1,x2,xfin : Extended;
begin
  if mit<1
    then st:=1
    else begin
           st:=2;
           it:=0;
           repeat
             it:=it+1;
             x1:=g(x0);
             x2:=g(x1);
             x:=x2-2*x1+x0;
             if x<>0
               then begin
                      x:=x0-Sqr(x1-x0)/x;
                      if Abs(x-x0)<eps
                        then st:=0
                        else begin
                               x0:=x;
                               xfin:=x
                             end
                    end
               else begin
                      st:=0;
                      x:=xfin
                    end
           until (it=mit) or (st<>2)
         end;
  if (st=0) or (st=2)
    then begin
           Steffensen:=x;
           fatx:=x-g(x)
         end
end;