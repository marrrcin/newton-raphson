function Jarratt (var a,b  : Extended;
                  f,df     : fx;
                  var fatx : Extended;
                  var st   : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Jarratt finds an approximate value of the root of the       }
{  equation f(x)=0 lying in the interval [a,b] by Jarratt's method.         }
{  Data:                                                                    }
{    a,b - the ends of the interval which contains the root (changed on     }
{          exit),                                                           }
{    f   - a Turbo Pascal function which for the given value x evaluates    }
{          f(x),                                                            }
{    df  - a Turbo Pascal function which for the given value x evaluates    }
{          df(x)/dx.                                                        }
{  Results:                                                                 }
{    Jarratt(a,b,f,df,fatx,st) - approximate value of the root,             }
{    fatx                      - the value of the function f(x) at the      }
{                                approximate root.                          }
{  Other parameters:                                                        }
{    st - a variable which within the function Jarratt is assigned the      }
{         value of:                                                         }
{           1, if a>=b or f(a)*f(b)>0,                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then Jarratt(a,b,f,df,fatx,st) is not calculated.  }
{  Unlocal identifier:                                                      }
{    fx - a procedural-type identifier defined as follows                   }
{           type fx = function (x : Extended) : Extended;                   }
{  Note: Any function passed as a parameter should be declared with a far   }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var sfa                               : Integer;
    c,ca,cb,d,dfa,dfb,fa,fb,g,na,nb,x : Extended;
begin
  st:=1;
  fa:=f(a);
  dfa:=df(a);
  if fa<0
    then sfa:=-1
    else if fa=0
           then sfa:=0
           else sfa:=1;
  fb:=f(b);
  dfb:=df(b);
  if (sfa*fb<=0) and (a<b)
    then repeat
           g:=fb-fa;
           c:=b-a;
           ca:=c*fa;
           na:=fb*g-ca*dfb;
           cb:=c*fb;
           nb:=fa*g-cb*dfa;
           d:=fa*na+fb*nb;
           if d=0
             then x:=0.5*(a+b)
             else if abs(fa)<abs(fb)
                    then begin
                           d:=ca*na/d;
                           x:=a+d
                         end
                    else begin
                           d:=cb*nb/d;
                           x:=b-d
                         end;
           if (x<=a) or (x>=b)
             then x:=0.5*(a+b);
           fatx:=f(x);
           d:=df(x);
           if (x<=a) or (x>=b) or (fatx=0)
             then st:=0
             else if sfa*fatx>0
                    then begin
                           a:=x;
                           fa:=fatx;
                           dfa:=d
                         end
                    else begin
                           b:=x;
                           fb:=fatx;
                           dfb:=d
                         end
         until st=0;
  if st=0
    then Jarratt:=x
end;