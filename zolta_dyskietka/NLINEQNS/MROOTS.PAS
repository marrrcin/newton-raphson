procedure Mullerroots (n          : Integer;
                       a          : vector;
                       x0         : complex;
                       mit        : Integer;
                       tol        : Extended;
                       var x,watx : complex;
                       var it,st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Mullerroots finds an approximate value of the complex root }
{  of the polynomial a[n]x^n+a[n-1]x^(n-1)+...+a[1]x+a[0] by Muller's       }
{  method.                                                                  }
{  Data:                                                                    }
{    n   - the degree of polynomial,                                        }
{    a   - an array containing coefficients of the polynomial (the element  }
{          a[i] should contain the value of coefficient before x^i;         }
{          i=0,1,...,n),                                                    }
{    x0  - initial approximation to the root (the elements x0.re should     }
{          contain the real part of the approximation, and the element      }
{          x0.im - imaginary part),                                         }
{    mit - maximum number of iterations,                                    }
{    tol - tolerance for the solution.                                      }
{  Results:                                                                 }
{    x    - approximate value of the root (the element x.re contains the    }
{           real part of the approximation, and the element x.im            }
{           - imaginary part),                                              }
{    watx - the value of the function f(x) (the element fatx.re contains    }
{           the real part of f(x), and the element fatx.im - imaginary      }
{           part),                                                          }
{    it   - number of iterations.                                           }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Mullerroots is assigned the }
{         value of:                                                         }
{           1, if mit<1,                                                    }
{           2, if the given tolerance is not achieved in mit iteration      }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1, then the value of x is not calculated, and if      }
{               st=2, then x contains the last approximation found.         }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qn], where q1<=1    }
{              and qn>=n,                                                   }
{    complex - a type identifier defined as follows:                        }
{                type complex = record                                      }
{                                 re,im : Extended                          }
{                               end;                                        }
{                                                                           }
{---------------------------------------------------------------------------}
procedure polvalue (n         : Integer;
                    a         : vector;
                    x         : complex;
                    var value : complex);
var i         : Integer;
    rho,phi,w : Extended;
begin
  rho:=Sqrt(Sqr(x.re)+Sqr(x.im));
  if rho>0
    then with x do
           if re>0
             then if im>=0
                    then phi:=ArcTan(im/re)
                    else phi:=2*Pi+ArcTan(im/re)
             else if re=0
                    then if im>0
                           then phi:=Pi/2
                           else phi:=3*Pi/2
                    else phi:=Pi+ArcTan(im/re);
  with value do
    begin
      re:=a[0];
      im:=0;
      if rho>0
        then begin
               w:=1;
               for i:=1 to n do
                 begin
                   w:=w*rho;
                   re:=re+w*Cos(i*phi)*a[i];
                   im:=im+w*Sin(i*phi)*a[i]
                 end
             end
    end
end {polvalue};
procedure cplxdiv (a,b   : complex;
                   var c : complex);
var s : Extended;
begin
  s:=Sqr(b.re)+Sqr(b.im);
  c.re:=(a.re*b.re+a.im*b.im)/s;
  c.im:=(b.re*a.im-a.re*b.im)/s
end {cplxdiv};
var s                     : Extended;
    aa,delta,e,f0,f1,f2,h : complex;
    ap                    : vector;
begin
  if mit<1
    then st:=1
    else begin
           st:=2;
           it:=1;
           repeat
             it:=it+1;
             polvalue (n,a,x0,f0);
             for i:=0 to n-1 do
               ap[i]:=(i+1)*a[i+1];
             polvalue (n-1,ap,x0,f1);
             for i:=0 to n-2 do
               ap[i]:=(i+1)*(i+2)*a[i+2];
             polvalue (n-2,ap,x0,f2);
             with aa do
               begin
                 re:=2*(f0.re*f2.re-f0.im*f2.im);
                 im:=2*(f0.re*f2.im+f0.im*f2.re);
                 re:=Sqr(f1.re)-Sqr(f1.im)-re;
                 im:=2*f1.re*f1.im-im;
                 s:=Sqrt(Sqr(re)+Sqr(im))
               end;
             with delta do
               begin
                 im:=Sqrt((s-aa.re)/2);
                 re:=Sqrt((s+aa.re)/2);
                 if aa.im<0
                   then re:=-re
               end;
             if Sqrt(Sqr(f1.re-delta.re)+Sqr(f1.im-delta.im))
                 <Sqrt(Sqr(f1.re+delta.re)+Sqr(f1.im+delta.im))
               then with e do
                      begin
                        re:=f1.re+delta.re;
                        im:=f1.im+delta.im
                      end
               else with e do
                      begin
                        re:=f1.re-delta.re;
                        im:=f1.im-delta.im
                      end;
             aa.re:=-2*f0.re;
             aa.im:=-2*f0.im;
             cplxdiv (aa,e,h);
             x.re:=x0.re+h.re;
             x.im:=x0.im+h.im;
             if Sqrt(Sqr(h.re)+Sqr(h.im))<tol
               then st:=0
               else begin
                      x0.re:=x.re;
                      x0.im:=x.im
                    end
           until (it=mit) or (st<>2)
         end;
  if (st=0) or (st=2)
    then polvalue (n,a,x,watx)
end;