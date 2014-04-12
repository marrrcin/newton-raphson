function binarysearch (var a,b   : Extended;
                       f         : fx;
                       mit       : Integer;
                       tol       : Extended;
                       var fatx  : Extended;
                       var it,st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function binarysearch finds an approximate value of the root of the  }
{  equation f(x)=0 lying in the interval [a,b] by the bisection algorithm.  }
{  Data:                                                                    }
{    a,b - the ends of the interval which contains the root (changed on     }
{          exit),                                                           }
{    f   - a Turbo Pascal function which for the given value x calculates   }
{          f(x),                                                            }
{    mit - maximum number of iterations,                                    }
{    tol - tolerance for the solution.                                      }
{  Results:                                                                 }
{    binarysearch(a,b,f,mit,eps,fatx,it,st) - approximate value of the      }
{                                             root,                         }
{    fatx                                   - the value of the function     }
{                                             f(x) at the approximate root, }
{    it                                     - number of iterations.         }
{  Other parameters:                                                        }
{    st - a variable which within the function binarysearch is assigned the }
{         value of:                                                         }
{           1, if mit<1,                                                    }
{           2, f(a)*f(b)>=0,                                                }
{           3, if the given tolerance is not achieved in mit iteration      }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then                                       }
{               binarysearch(a,b,f,mit,tol,fatx,it,st) is not calculated,   }
{               and if st=3, then binarysearch(a,b,f,mit,tol,fatx,it,st)    }
{               yields the last approximation found.                        }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var fa,fb,x : Extended;
begin
  if mit<1
    then st:=1
    else begin
           fa:=f(a);
           fb:=f(b);
           if fa*fb>=0
             then st:=2
             else begin
                    st:=3;
                    it:=0;
                    repeat
                      it:=it+1;
                      x:=a+(b-a)/2;
                      fa:=f(x);
                      if (fa=0) or ((b-a)/2<tol)
                        then st:=0
                        else begin
                               fa:=f(a);
                               fb:=f(x);
                               if fa*fb>0
                                 then a:=x
                                 else b:=x
                             end
                    until (it=mit) or (st<>3)
                  end
         end;
  if (st=0) or (st=3)
    then begin
           binarysearch:=x;
           fatx:=f(x)
         end
end;