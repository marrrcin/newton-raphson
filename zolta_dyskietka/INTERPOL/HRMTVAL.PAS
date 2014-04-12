function Hermitevalue (n, k   : Integer;
                       x      : vector2;
                       m      : vector3;
                       f      : vector;
                       xx     : Extended;
                       var st : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function Hermitevalue calculates the value of a polynomial given by  }
{  Hermite's interpolation formula.                                         }
{  Data:                                                                    }
{    n  - the degree of polynomial (the degree is at most n),               }
{    k  - number of nodes minus 1 (the nodes are numbered from 0 to k),     }
{    x  - an array containing the values of nodes,                          }
{    m  - an array containing the positive integers associated with nodes   }
{         (m[i] is the multiplicity of the node x[i]; the elements of m     }
{         should satisfy the condition m[0]+m[1]+...+m[k]=n+1),             }
{    f  - an array containing the values of function and its derivatives at }
{         succeeding nodes (the element f[0] should contain the value of    }
{         f(x[0]), f[1] - the value of f'(x[0]), ..., f[m[0]-1] - the value }
{         of (m[0]-1) derivative of f at x[0], ..., the element             }
{         f[m[0]+m[1]+...m[k-1]] should contain the value of f(x[k]), ...,  }
{         and the element f[m[0]+m[1]+...+m[k-1]+m[k]-1] - the value of     }
{         (m[k]-1) derivative of f at x[k]),                                }
{    xx - the point at which the value of interpolating polynomial should   }
{         be calculated.                                                    }
{  Result:                                                                  }
{    Hermitevalue(n,k,x,m,f,xx,st) - the value of polynomial at xx.         }
{  Other parameters:                                                        }
{    st - a variable which within the function Hermitevalue is assigned the }
{         value of:                                                         }
{           1, if n<0 or k<0,                                               }
{           2, if there exist x[i] and x[j] (i<>j; i,j=0,1,...,k) such      }
{              that x[i]=x[j],                                              }
{           3, if m[i]<1 or m[i]>8 for at least one i,                      }
{           4, if m[0]+m[1]+...+m[k] is not equal to n+1,                   }
{           0, otherwise.                                                   }
{         Note: If st<>0, then Hermitevalue(n,k,x,m,f,xx,st) is not         }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q0..qn], where q0<=0    }
{              and qn>=n,                                                   }
{    vector2 - a type identifier of extended array [q0..qk], where q0<=0    }
{              and qk>=k,                                                   }
{    vector3 - a type identifier of integer array [q0..qk], where q0<=0     }
{              and qk>=k.                                                   }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,l,p,q,sum : Integer;
    diff,xii,xp   : Extended;
    d,xi          : vector;
    equal         : Boolean;
begin
  st:=0;
  if (n<0) or (k<0)
    then st:=1
    else begin
           if k>0
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      for j:=i+1 to k do
                        if x[i]=x[j]
                          then st:=2
                    until (i=k-1) or (st=2)
                  end;
           if st<>2
             then begin
                    i:=-1;
                    repeat
                      i:=i+1;
                      if (m[i]<1) or (m[i]>8)
                        then st:=3
                    until (i=k) or (st=3);
                    if st<>3
                      then begin
                             sum:=0;
                             for i:=0 to k do
                               sum:=sum+m[i];
                             if sum<>n+1
                               then st:=4
                           end
                  end
         end;
  if st=0
    then begin
           for i:=0 to k do
             begin
               if i=0
                 then l:=0
                 else l:=l+m[i-1];
               for j:=l to l+m[i]-1 do
                 begin
                   xi[j]:=x[i];
                   d[j]:=f[l]
                 end
             end;
             for q:=1 to n do
               begin
                 l:=k;
                 equal:=False;
                 for i:=n downto q do
                   begin
                     xii:=xi[i];
                     if (q<8) and (xi[i-q]=xii)
                       then begin
                              sum:=1;
                              for j:=1 to q do
                                sum:=sum*j;
                              if not equal
                                then begin
                                       p:=0;
                                       for j:=k downto l do
                                         p:=p+m[j];
                                       p:=n+1-p+q;
                                       equal:=True
                                     end;
                              d[i]:=f[p]/sum
                            end
                       else begin
                              diff:=xii-xi[i-q];
                              if (q=1) or (xii<>xi[i-1])
                                then begin
                                       l:=l-1;
                                       equal:=False
                                     end;
                              d[i]:=(d[i]-d[i-1])/diff
                            end
                   end
               end;
           diff:=0;
           for i:=0 to k do
             begin
               if i=0
                 then sum:=0
                 else begin
                        sum:=m[0];
                        for p:=1 to i-1 do
                          sum:=sum+m[p]
                      end;
               xii:=1;
               for p:=0 to i-1 do
                 begin
                   xp:=x[p];
                   for q:=1 to m[p] do
                     xii:=xii*(xx-xp)
                 end;
               for j:=0 to m[i]-1 do
                 begin
                   xp:=x[i];
                   for p:=1 to j do
                     xii:=xii*(xx-xp);
                   diff:=diff+d[sum+j]*xii
                 end
             end;
           Hermitevalue:=diff
         end
end;