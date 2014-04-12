function regulafalsi (var a,b  : Extended;
                      f        : fx;
                      var fatx : Extended;
                      var st   : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function regulafalsi finds an approximate value of the root of the   }
{  equation f(x)=0 lying in the interval [a,b] by regula falsi.             }
{  Data:                                                                    }
{    a,b - the ends of the interval which contains the root (changed on     }
{          exit),                                                           }
{    f   - a Turbo Pascal function which for the given value x calculates   }
{          f(x).                                                            }
{  Results:                                                                 }
{    regulafalsi(a,b,f,fatx,st) - approximate value of the root,            }
{    fatx                       - the value of the function f(x) at the     }
{                                 approximate root.                         }
{  Other parameters:                                                        }
{    st - a variable which within the function regulafalsi is assigned the  }
{         value of:                                                         }
{           1, if a>=b,                                                     }
{           2, if f(a)*f(b)>0,                                              }
{           0, otherwise.                                                   }
{         Note: If st=1 or st=2, then regulafalsi(a,b,f,fatx,st) is not     }
{               calculated.                                                 }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var sfa,sv    : Integer;
    fa,fb,v,x : Extended;
begin
  if a>=b
    then st:=1
    else begin
           fa:=f(a);
           if fa<0
             then sfa:=-1
             else if fa=0
                    then sfa:=0
                    else sfa:=1;
           fb:=f(b);
           if sfa*fb>0
             then st:=2
             else begin
                    st:=0;
                    x:=b-fb*(b-a)/(fb-fa);
                    while (a<x) and (x<b) do
                      begin
                        v:=f(x);
                        if v<0
                          then sv:=-1
                          else if v=0
                                 then sv:=0
                                 else sv:=1;
                        if sfa=sv
                          then begin
                                 a:=x;
                                 fa:=v
                               end
                          else begin
                                 b:=x;
                                 fb:=v
                               end;
                        x:=b-fb*(b-a)/(fb-fa)
                      end;
                    regulafalsi:=x;
                    fatx:=f(x)
                  end
         end
end;