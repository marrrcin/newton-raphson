function Romberg (a,b    : Extended;
                  f      : fx;
                  eps    : Extended;
                  r      : Integer;
                  var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Romberg calculates an approximate value of the integral     }
{  from a function f(x) in a finite interval [a,b] by Romberg's method.     }
{  Data:                                                                    }
{    a,b - the ends of the intergration interval,                           }
{    f   - a Turbo Pascal function which for the given x calculates the     }
{          value of integrand f(x),                                         }
{    eps - accuracy for calculating the integral,                           }
{    r   - number of steps in Romberg's method.                             }
{          Note: It should be fulfilled the condition 2<=r<=15.             }
{  Result:                                                                  }
{    Romberg(a,b,f,eps,r,st) - approximate value of the integral.           }
{  Other parameters:                                                        }
{    st - a variable which within the function Romberg is assigned the      }
{         value of:                                                         }
{           1, if after r steps the given accuracy is not achieved,         }
{           2, if r<2 or r>15,                                              }
{           0, otherwise.                                                   }
{         Note: If st=1, then Romberg(a,b,f,eps,r,st) yields the last       }
{               approximation found, and if st=2 then the value of the      }
{               function Romberg is not calculated.                         }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qr], where q1<=1 and }
{             qr>=r,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var j,k,l        : Integer;
    h,h1,I,q,s,x : Extended;
    kon          : Boolean;
    t            : vector;
begin
  if (r>=2) and (r<=15)
    then begin
           t[1]:=0.5*(f(a)+f(b));
           h:=b-a;
           h1:=h;
           l:=1;
           k:=1;
           repeat
             k:=k+1;
             I:=t[1];
             s:=0;
             x:=a+0.5*h1;
             while x<b do
               begin
                 s:=s+f(x);
                 x:=x+h1
               end;
             h1:=0.5*h1;
             t[k]:=0.5*(t[k-1]+s/l);
             q:=1;
             for j:=k-1 downto 1 do
               begin
                 q:=4*q;
                 t[j]:=t[j+1]+(t[j+1]-t[j])/(q-1)
               end;
             kon:=abs(I-t[1])*h<=eps;
             if not kon
               then l:=2*l
           until kon or (k>=r);
           if kon
             then st:=0
             else st:=1;
           Romberg:=h*t[1]
         end
    else st:=2
end;