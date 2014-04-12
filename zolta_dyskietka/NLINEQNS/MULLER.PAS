procedure Muller (x0,x1,x2   : complex;
                  f          : fxcplx;
                  mit        : Integer;
                  tol        : Extended;
                  var x,fatx : complex;
                  var it,st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Muller finds an approximate value of the complex root of   }
{  the equation f(x)=0 by the Muller algorithm.                             }
{  Data:                                                                    }
{    x0,x1,x2 - initial approximations to the root (the elements x0.re,     }
{               x1.re and x2.re should contain real parts of the            }
{               approximations, and the elements x0.im, x1.im and x2.im     }
{               - imaginary parts),                                         }
{    f        - a Turbo Pascal procedure which for the given value x        }
{               calculates f(x) (x and f(x) may be complex),                }
{    mit      - maximum number of iterations,                               }
{    tol      - tolerance for the solution.                                 }
{  Results:                                                                 }
{    x    - approximate value of the root (the element x.re contains the    }
{           real part of the approximation, and the element x.im            }
{           - imaginary part),                                              }
{    fatx - the value of the function f(x) (the element fatx.re contains    }
{           the real part of f(x), and the element fatx.im - imaginary      }
{           part),                                                          }
{    it   - number of iterations.                                           }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Muller is assigned the      }
{         value of:                                                         }
{           1, if mit<1,                                                    }
{           2, if x0=x1 or x2=x1,                                           }
{           3, if the given tolerance is not achieved in mit iteration      }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1 or 2, then the value of x is not calculated, and if }
{               st=3, then x contains the last approximation found.         }
{  Unlocal identifiers:                                                     }
{    complex - a type identifier defined as follows:                        }
{                type complex = record                                      }
{                                 re,im : Extended                          }
{                               end;                                        }
{    fxcplx  - a procedural-type identifier defined as follows:             }
{                type fxcplx = procedure (x      : complex;                 }
{                                         var fx : complex);                }
{  Note: Any procedure passed as a parameter should be declared with a far  }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
procedure cplxdiv (a,b   : complex;
                   var c : complex);
var s : Extended;
begin
  s:=Sqr(b.re)+Sqr(b.im);
  c.re:=(a.re*b.re+a.im*b.im)/s;
  c.im:=(b.re*a.im-a.re*b.im)/s
end {cplxdiv};
var s                  : Extended;
    a,b,d,delta,d1,d2,
    e,f0,f1,f2,h,h1,h2 : complex;
begin
  if mit<1
    then st:=1
    else if ((x1.re-x0.re=0) and (x1.im-x0.im=0))
             or ((x2.re-x1.re=0) and (x2.im-x1.im=0))
           then st:=2
           else begin
                  st:=3;
                  it:=1;
                  repeat
                    it:=it+1;
                    h1.re:=x1.re-x0.re;
                    h1.im:=x1.im-x0.im;
                    h2.re:=x2.re-x1.re;
                    h2.im:=x2.im-x1.im;
                    f(x0,f0);
                    f(x1,f1);
                    f(x2,f2);
                    a.re:=f1.re-f0.re;
                    a.im:=f1.im-f0.im;
                    cplxdiv (a,h1,d1);
                    a.re:=f2.re-f1.re;
                    a.im:=f2.im-f1.im;
                    cplxdiv (a,h2,d2);
                    a.re:=d2.re-d1.re;
                    a.im:=d2.im-d1.im;
                    b.re:=h2.re+h1.re;
                    b.im:=h2.im+h1.im;
                    cplxdiv (a,b,d);
                    a.re:=h2.re*d.re-h2.im*d.im;
                    a.im:=h2.re*d.im+h2.im*d.re;
                    b.re:=d2.re+a.re;
                    b.im:=d2.im+a.im;
                    a.re:=4*(f2.re*d.re-f2.im*d.im);
                    a.im:=4*(f2.re*d.im+f2.im*d.re);
                    a.re:=Sqr(b.re)-Sqr(b.im)-a.re;
                    a.im:=2*b.re*b.im-a.im;
                    s:=Sqrt(Sqr(a.re)+Sqr(a.im));
                    with delta do
                      begin
                        im:=Sqrt((s-a.re)/2);
                        re:=Sqrt((s+a.re)/2);
                        if a.im<0
                          then re:=-re
                      end;
                    if Sqrt(Sqr(b.re-delta.re)+Sqr(b.im-delta.im))
                        <Sqrt(Sqr(b.re+delta.re)+Sqr(b.im+delta.im))
                      then with e do
                             begin
                               re:=b.re+delta.re;
                               im:=b.im+delta.im
                             end
                      else with e do
                             begin
                               re:=b.re-delta.re;
                               im:=b.im-delta.im
                             end;
                    a.re:=-2*f2.re;
                    a.im:=-2*f2.im;
                    cplxdiv (a,e,h);
                    x.re:=x2.re+h.re;
                    x.im:=x2.im+h.im;
                    if Sqrt(Sqr(h.re)+Sqr(h.im))<tol
                      then st:=0
                      else begin
                             x0.re:=x1.re;
                             x0.im:=x1.im;
                             x1.re:=x2.re;
                             x1.im:=x2.im;
                             x2.re:=x.re;
                             x2.im:=x.im
                           end
                  until (it=mit) or (st<>3)
                end;
  if (st=0) or (st=3)
    then f (x,fatx)
end;