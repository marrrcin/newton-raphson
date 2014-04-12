function Simpson (a,b    : Extended;
                  f      : fx;
                  eps    : Extended;
                  n      : Integer;
                  var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Simpson finds an approximate value of the integral from a   }
{  composite integrand f(x) in a finite interval [a,b] by Simpson's method. }
{  Data:                                                                    }
{    a,b - the ends of the integration interval,                            }
{    f   - a Turbo Pascal function which for the given x calculates the     }
{          value of integrand f(x),                                         }
{    eps - relative error for calculating the integral,                     }
{    n   - a positive integer which limits the calculations (the            }
{          calculations are finished if the given accuracy eps is not       }
{          achieved after 4n+1 evaluations of the integrand).               }
{  Result:                                                                  }
{    Simpson(a,b,f,eps,n,st) - approximate value of the integral.           }
{  Other parameters:                                                        }
{    st - a variable which within the function Simpson is assigned the      }
{         value of:                                                         }
{           1, if the given accuracy eps is not achieved after 4n+1         }
{              evaluations of the integrand,                                }
{           0, otherwise.                                                   }
{         Note: If st=1, then Simpson(a,b,f,eps,n,st) yields the last       }
{               approximation found.                                        }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k                              : Integer;
    ba4i,faj,famj,fbj,fmbj,fmj,lei,lej : Extended;
    cond                               : Boolean;
    ba4,d4,fa,fam,fb,fm,fmb,le         : vector;
begin
  st:=0;
  j:=1;
  ba4i:=0.25*(b-a);
  ba4[1]:=ba4i;
  faj:=f(a);
  fa[1]:=faj;
  famj:=f(a+ba4i);
  fam[1]:=famj;
  fmj:=f(a+ba4i+ba4i);
  fm[1]:=fmj;
  fmbj:=f(b-ba4i);
  fmb[1]:=fmbj;
  fbj:=f(b);
  fb[1]:=fbj;
  eps:=36*eps*ba4i*(abs(faj)+abs(famj)+abs(fmj)+abs(fmbj)+abs(fbj));
  le[1]:=a;
  faj:=faj+fbj;
  famj:=4*(famj+fmbj);
  d4[1]:=ba4i*(faj-famj+6*fmj);
  a:=ba4i*(faj+fmj+fmj+famj);
  repeat
    faj:=0;
    b:=-1;
    for k:=j downto 1 do
      begin
        fmj:=abs(d4[k]);
        faj:=faj+fmj;
        if fmj>b
          then begin
                 b:=fmj;
                 i:=k
               end
      end;
    cond:=true;
    if faj>eps
      then if j<n
             then begin
                    j:=j+1;
                    fbj:=fb[i];
                    fb[j]:=fbj;
                    fmj:=fmb[i];
                    fm[j]:=fmj;
                    faj:=fm[i];
                    fa[j]:=faj;
                    fb[i]:=faj;
                    ba4i:=ba4[i];
                    lei:=le[i];
                    lej:=lei+ba4i+ba4i;
                    le[j]:=lej;
                    ba4i:=0.5*ba4i;
                    ba4[i]:=ba4i;
                    ba4[j]:=ba4i;
                    famj:=f(lej+ba4i);
                    fam[j]:=famj;
                    fmbj:=f(lej+3*ba4i);
                    fmb[j]:=fmbj;
                    fbj:=ba4i*(faj+fbj-4*(famj+fmbj)+6*fmj);
                    d4[j]:=fbj;
                    fmj:=fam[i];
                    fm[i]:=fmj;
                    famj:=f(lei+ba4i);
                    fam[i]:=famj;
                    fmbj:=f(lej-ba4i);
                    fmb[i]:=fmbj;
                    faj:=ba4i*(fa[i]+faj-4*(famj+fmbj)+6*fmj);
                    d4[i]:=faj;
                    a:=a-fbj-faj;
                    cond:=false
                  end
             else st:=1
  until cond;
  b:=0;
  for k:=j downto 1 do
    b:=b+d4[k];
  Simpson:=a/3-b/45
end;