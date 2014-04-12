function bisection (n              : Integer;
                    a              : vector;
                    var alpha,beta : Extended;
                    mit            : Integer;
                    eps            : Extended;
                    var w          : Extended;
                    var it,st      : integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function bisection finds an approximate value of a root of the       }
{  polynomial p(x)=a[n]x^n+a[n-1]x^(n-1)+...+a[1]x+a[0], lying in a given   }
{  interval [a,b], by bisection method.                                     }
{  Data:                                                                    }
{    n          - the degree of polynomial,                                 }
{    a          - an array of coefficients of the polynomial (the element   }
{                 a[i] should contain the value of coefficient before x^i;  }
{                 i=0,1,...,n),                                             }
{    alpha,beta - the ends of the interval which includes the root (changed }
{                 on exit),                                                 }
{    mit        - maximum number of iterations,                             }
{    eps        - relative accuracy of the solution.                        }
{  Results:                                                                 }
{    bisection(n,a,alpha,beta,mit,eps,w,it,st) - approximate value of the   }
{                                                root,                      }
{    alpha,beta                                - the ends of the last       }
{                                                subinterval considered     }
{                                                within the function        }
{                                                bisection,                 }
{    w                                         - the value of polynomial at }
{                                                the approximate root,      }
{    it                                        - number of iterations.      }
{  Other parameters:                                                        }
{    st - a variable which within the function bisection is assigned the    }
{         value of:                                                         }
{           1, if n<1 or mit<1 or alpha>=beta,                              }
{           2, if p(alpha)p(beta)>=0,                                       }
{           3, if the given accuracy eps is not achieved in mit iteration   }
{              steps,                                                       }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then                                       }
{               bisection(n,a,alpha,beta,mit,eps,w,it,st),                  }
{               w and it are not calculated. If st=3, then                  }
{               bisection(n,a,alpha,beta,mit,eps,w,it,st) yields the last   }
{               approximation to the root.                                  }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i                    : Integer;
    gamma,pa,pb,pg,w1,w2 : Extended;
function polvalue (n : Integer;
                   a : vector;
                   x : Extended) : Extended;
var i : Integer;
    p : Extended;
begin
  p:=a[n];
  for i:=n-1 downto 0 do
    p:=p*x+a[i];
  polvalue:=p
end {polvalue};
begin
  if (n<1) or (mit<1) or (alpha>=beta)
    then st:=1
    else begin
           pa:=polvalue(n,a,alpha);
           pb:=polvalue(n,a,beta);
           if pa*pb>=0
             then st:=2
             else begin
                    st:=3;
                    it:=0;
                    repeat
                      it:=it+1;
                      gamma:=(alpha+beta)/2;
                      w1:=abs(beta);
                      w2:=abs(alpha);
                      if w1<w2
                        then w1:=w2;
                      if w1=0
                        then st:=0
                        else if (beta-alpha)/w1<eps
                               then st:=0
                               else begin
                                      pg:=polvalue(n,a,gamma);
                                      if pg=0
                                        then st:=0
                                        else begin
                                               if pa*pg<0
                                                 then beta:=gamma
                                                 else alpha:=gamma;
                                               pa:=polvalue(n,a,alpha);
                                               pb:=polvalue(n,a,beta)
                                             end
                                    end
                    until (it=mit) or (st=0)
                  end
         end;
  if (st=0) or (st=3)
    then begin
           bisection:=gamma;
           w:=pg
         end
end;