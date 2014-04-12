function linearintpol (var a,b  : Extended;
                       f        : fx;
                       var fatx : Extended) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function linearintpol finds an approximate value of the root of the  }
{  equation f(x)=0 lying in the interval [a,b] or near this interval by     }
{  linear interpolation.                                                    }
{  Data:                                                                    }
{    a,b - the ends of the interval which contains the root (changed on     }
{          exit),                                                           }
{    f   - a Turbo Pascal function which for the given value x calculates   }
{          f(x).                                                            }
{  Results:                                                                 }
{    linearintpol(a,b,f,fatx) - approximate value of the root,              }
{    fatx                     - the value of the function f(x) at the       }
{                               approximate root.                           }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Notes: 1) The function linearintpol does not contain any status          }
{            variable.                                                      }
{         2) A function passed as a parameter should be declared with a far }
{            directive or compiled in the $F+ state.                        }
{                                                                           }
{---------------------------------------------------------------------------}
var fa,fb,h,x : Extended;
    cond      : Boolean;
begin
  cond:=true;
  h:=0.179372*(b-a);
  a:=a+h;
  b:=b-h;
  fa:=f(a);
  fb:=f(b);
  if abs(fa)<abs(fb)
    then begin
           h:=a;
           a:=b;
           b:=h;
           h:=fa;
           fa:=fb;
           fb:=h
         end;
  repeat
    x:=fa-fb;
    if x=0
      then begin
             linearintpol:=b;
             fatx:=fb;
             cond:=false
           end
      else begin
             h:=b-a;
             x:=b+fb*h/x;
             if x=a
               then begin
                      fatx:=fa;
                      cond:=false
                    end
               else if x=b
                      then begin
                             fatx:=fb;
                             cond:=false
                           end
                      else begin
                             fatx:=f(x);
                             if fatx=0
                               then cond:=false
                           end;
             if not cond
               then linearintpol:=x
               else begin
                      fa:=fb;
                      fb:=fatx;
                      a:=b;
                      b:=x
                    end
           end
  until not cond;
end;