procedure Givens (n        : Integer;
                  var d,e  : vector;
                  m1,m2    : Integer;
                  eps1     : Extended;
                  var x    : vector;
                  var eps2 : Extended;
                  var st   : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Givens calculates the eigenvalues of a symmetric           }
{  tridiagonal matrix B by Givens' method.                                  }
{  Data:                                                                    }
{    n     - number of rows (columns) of matrix B,                          }
{    d     - an array containing the values of the diagonal elements of     }
{            matrix B,                                                      }
{    e     - an array the elements e[i] (i=2,3,...,n) of which contain the  }
{            values of the elements below (above) the main diagonal of      }
{            matrix B (e[1] must be equal to 0),                            }
{    m1,m2 - the ordered numbers of the smallest and the largest eigenvalue }
{            which should be calculated (fulfilling the condition           }
{            1<=m1<=m2<=n),                                                 }
{    eps1  - a number which influences the accuracy of calculations of the  }
{            eigenvalues (it can be a number of order max(abs(a),           }
{            abs(b))*2^-63, where [a,b] is an interval containing all       }
{            eigenvalues.                                                   }
{  Results:                                                                 }
{    x    - an array the elements x[m1],x[m1+1],...,x[m2] of which contain  }
{           the eigenvalues of matrix B ordered from the smallest,          }
{    eps2 - relative error of the eigenvalues found.                        }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Givens is assigned the      }
{         value of:                                                         }
{           1, if the condition 1<=m1<=m2<=n is not fulfilled,              }
{           2, if e[1]<>0;                                                  }
{           0, otherwise.                                                   }
{         Note: If st=1 or 2, then x and eps2 are not determined on exit.   }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n.                                                        }
{                                                                           }
{---------------------------------------------------------------------------}
var i,k,s                  : Integer;
    h,q,xl,xm,xmax,xmin,xu : Extended;
    cond                   : Boolean;
    lb                     : vector;
begin
  if (1<=m1) and (m1<=m2) and (m2<=n) and (e[1]=0)
    then begin
           st:=0;
           xl:=d[n];
           xm:=abs(e[n]);
           xmin:=xl-xm;
           xmax:=xl+xm;
           for i:=n-1 downto 1 do
             begin
               xu:=abs(e[i]);
               h:=xm+xu;
               xm:=xu;
               xl:=d[i];
               xu:=xl-h;
               if xu<xmin
                 then xmin:=xu;
               xu:=xl+h;
               if xu>xmax
                 then xmax:=xu
             end;
           if xmin+xmax>0
             then eps2:=xmax
             else eps2:=-xmin;
           eps2:=0.5*eps1+1.02e-15*eps2;
           for i:=m1 to m2 do
             begin
               lb[i]:=xmin;
               x[i]:=xmax
             end;
           xu:=xmax;
           for k:=m2 downto m1 do
             begin
               xl:=xmin;
               i:=k;
               repeat
                 cond:=true;
                 q:=lb[i];
                 if xl<q
                   then xl:=q
                   else begin
                          i:=i-1;
                          if i>=m1
                            then cond:=false
                        end
               until cond;
               q:=x[k];
               if xu>q
                 then xu:=q;
               while xu-xl>2.91e-16*(abs(xl)+abs(xu))+eps1 do
                 begin
                   s:=0;
                   q:=1;
                   xm:=0.5*(xl+xu);
                   for i:=1 to n do
                     begin
                       if q=0
                         then q:=abs(6.87e15*e[i])
                         else q:=e[i]*e[i]/q;
                       q:=d[i]-xm-q;
                       if q<0
                         then s:=s+1
                     end;
                   if s<m1
                     then begin
                            xl:=xm;
                            lb[m1]:=xl
                          end
                     else if s<k
                            then begin
                                   xl:=xm;
                                   lb[s+1]:=xl;
                                   if x[s]>xm
                                     then x[s]:=xm
                                 end
                            else xu:=xm
                 end;
               x[k]:=0.5*(xl+xu)
             end
         end
    else if e[1]<>0
           then st:=2
           else st:=1
end;