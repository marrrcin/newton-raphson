function Newtonroots (n         : Integer;
                      a         : vector;
                      var x     : Extended;
                      mit       : Integer;
                      eps       : Extended;
                      var w     : Extended;
                      var it,st : integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Newtonroots finds an approximate value of a root of the     }
{  polynomial a[n]x^n+a[n-1]x^(n-1)+...+a[1]x+a[0] by Newton's method.      }
{  Data:                                                                    }
{    n   - the degree of polynomial,                                        }
{    a   - an array containing coefficients of the polynomial (the element  }
{          a[i] should contain the value of coefficient before x^i;         }
{          i=0,1,...,n),                                                    }
{    x   - initial approximation to the root (changed on exit),             }
{    mit - maximum number of iterations in Newton's method,                 }
{    eps - relative accuracy of the solution.                               }
{  Results:                                                                 }
{    Newtonroots(n,a,x,mit,eps,w,it,st) - approximate value of the root,    }
{    w                                  - the value of polynomial at the    }
{                                         approximate root,                 }
{    it                                 - number of iterations.             }
{  Other parameters:                                                        }
{    st - a variable which within the function Newtonroots is assigned the  }
{         value of:                                                         }
{           1, if n<1 or mit<1,                                             }
{           2, if during the calculations the derivative of polynomial with }
{              respect to x at a point x is equal to zero,                  }
{           3, if the given accuracy eps is not achieved in mit iteration   }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then Newtonroots(n,a,x,mit,eps,w,it,st),   }
{               w and it are not calculated. If st=3, then                  }
{               Newtonroots(n,a,x,mit,eps,w,it,st) yields the last          }
{               approximation to the root.                                  }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i         : Integer;
    dw,u,v,xh : Extended;
begin
  if (n<1) or (mit<1)
    then st:=1
    else begin
           w:=a[n];
           for i:=n-1 downto 0 do
             w:=w*x+a[i];
           it:=0;
           if w=0
             then st:=0
             else begin
                    st:=3;
                    repeat
                      it:=it+1;
                      w:=a[n];
                      dw:=w;
                      for i:=n-1 downto 1 do
                        begin
                          w:=w*x+a[i];
                          dw:=dw*x+w
                        end;
                      w:=w*x+a[0];
                      if dw=0
                        then st:=2
                        else begin
                               xh:=x;
                               u:=abs(xh);
                               x:=x-w/dw;
                               v:=abs(x);
                               if v<u
                                 then v:=u;
                               if v=0
                                 then st:=0
                                 else if abs(x-xh)/v<=eps
                                        then st:=0
                             end
                    until (it=mit) or (st<>3);
                  end
         end;
  if (st=0) or (st=3)
    then begin
           Newtonroots:=x;
           w:=a[n];
           for i:=n-1 downto 0 do
             w:=w*x+a[i]
         end
end;