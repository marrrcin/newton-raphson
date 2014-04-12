procedure linfinitediff (m      : Integer;
                         at     : atithrow;
                         ft     : ftcomponent;
                         b,c    : matrix;
                         g      : vector;
                         n      : Integer;
                         t      : vector0;
                         alpha  : vector1;
                         var u  : matrix0;
                         var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure linfinitediff calculates approximate values u[i,l] (i=1,2, }
{  ...,m; l=0,1,...,n) of the solutions of the linear boundary value        }
{  problem dy[i](t)/dt + A[i,1](t)y[1](t) +...+ A[i,m](t)y[m](t) +          }
{  + f[i](t) = 0 with the conditions By(t[0]) + Cy(t[n]) + g = 0, where B,  }
{  C denote given matrices, and g is a given vector, by finite differences. }
{  The solutions are calculated at the points t[0], t[1], ..., t[n].        }
{  Data:                                                                    }
{    m     - number of equations,                                           }
{    at    - a Turbo Pascal procedure which for the given value t           }
{            calculates the elements of the i-th row of matrix A occurring  }
{            in the differential equations,                                 }
{    ft    - a Turbo Pascal function which for the given value t calculates }
{            the i-th component of function f occurring in the differential }
{            equations,                                                     }
{    b,c   - arrays containing elements of the given matrices B and C       }
{            respectively,                                                  }
{    g     - an array containing elements of the given vector g,            }
{    n     - number of points minus one at which the solutions should be    }
{            found,                                                         }
{    t     - an array which contains the points t[l] (l=0,1,...n),          }
{    alpha - an array of coefficients of the difference method.             }
{  Result:                                                                  }
{    u - an array containing the solutions (the element u[i,l] contains the }
{        i-th component of the solution at the point t[l]; i=1,2,...,m;     }
{        l=0,1,...,n).                                                      }
{  Other parameters:                                                        }
{    st - a variable which within the procedure linfinitediff is assigned   }
{         the value of:                                                     }
{           1, if m<1 or n<1,                                               }
{           2, if the condition t[l]<t[l+1] is not fulfilled for at least   }
{              one l=0,1,...,n-1,                                           }
{           3, if the matrix of the adequate linear system of equations is  }
{              singular,                                                    }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array u are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q1..qm], where      }
{                  q1<=1 and qm>=m,                                         }
{    vector0     - a type identifier of extended array [q0..qn], where      }
{                  q0<=0 and qn>=n,                                         }
{    vector1     - a type identifier of extended array [q1..qn], where      }
{                  q1<=1 and qn>=n,                                         }
{    vector2     - a type identifier of extended array [q1..qnm], where     }
{                  q1<=1 and qnm>=(n+1)*m,                                  }
{    vector3     - a type identifier of integer array [q1..qnm], where      }
{                  q1<=1 and qnm>=(n+1)*m,                                  }
{    vector4     - a type identifier of extended array [q1..qnmm], where    }
{                  q1<=1 and qnmm>=(n*m+m+2)*(n*m+m+2)/4,                   }
{    matrix      - a type identifier of extended array [q1..qm,q1..qm],     }
{                  where q1<=1 and qm>=m,                                   }
{    matrix0     - a type identifier of extended array [q1..qm,q0..qn],     }
{                  where q1<=1, qm>=m, q0<=0 and qn>=n,                     }
{    atithrow    - a procedural-type identifier defined as follows          }
{                    type atithrow = procedure (i     : Integer;            }
{                                               t     : Extended;           }
{                                               m     : Integer;            }
{                                               var a : vector);            }
{    ftcomponent - a procedural-type identifier defined as follows          }
{                    type ftcomponent = function (i : Integer;              }
{                                                 t : Extended) : Extended; }
{  Notes: 1) A procedure and a function passed as parameters should be      }
{            declared with a far directive or compiled in the $F+ state.    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,jh,k,kh,l,lh,nm,n1,n2,p,q,rh : Integer;
    ai,al,max,s,s1,t0,t1             : Extended;
    a                                : vector;
    a1,b1                            : vector2;
    r                                : vector3;
    x                                : vector4;
begin
  if (m<1) or (n<1)
    then st:=1
    else st:=0;
  i:=0;
  repeat
    if t[i]>=t[i+1]
      then st:=2;
    i:=i+1;
  until (i=n) or (st=2);
  if st=0
    then begin
           nm:=n*m;
           n2:=nm+m+1;
           p:=n2;
           n1:=n2-1;
           for i:=1 to n2 do
             r[i]:=0;
           k:=0;
           repeat
             k:=k+1;
             if k<=m
               then begin
                      for i:=1 to m do
                        a1[i]:=b[k,i];
                      for i:=m+1 to nm do
                        a1[i]:=0;
                      for i:=nm+1 to nm+m do
                        a1[i]:=c[k,i-nm];
                      a1[n2]:=-g[k]
                    end
               else begin
                      l:=trunc((k-1)/m);
                      j:=l*m;
                      for i:=1 to j-m do
                        a1[i]:=0;
                      kh:=k-j;
                      al:=alpha[l];
                      t0:=t[l-1];
                      t1:=t[l];
                      s:=t1-t0;
                      s1:=s*(1-al);
                      s:=s*al;
                      at (kh,t0,m,a);
                      for i:=j-m+1 to j do
                        begin
                          lh:=i-j+m;
                          ai:=s*a[lh];
                          if kh=lh then ai:=ai-1;
                          a1[i]:=ai
                        end;
                      at (kh,t1,m,a);
                      for i:=j+1 to j+m do
                        begin
                          lh:=i-j;
                          ai:=s1*a[lh];
                          if kh=lh
                            then ai:=ai+1;
                          a1[i]:=ai
                        end;
                      for i:=j+m+1 to n2-1 do
                        a1[i]:=0;
                      a1[n2]:=-s*ft(kh,t0)-s1*ft(kh,t1)
                    end;
             for i:=1 to n1 do
               begin
                 rh:=r[i];
                 if rh<>0
                   then b1[rh]:=a1[i]
               end;
             kh:=k-1;
             l:=0;
             max:=0;
             for j:=1 to n2 do
               if r[j]=0
                 then begin
                        s:=a1[j];
                        l:=l+1;
                        q:=l;
                        for i:=1 to kh do
                          begin
                            s:=s-b1[i]*x[q];
                            q:=q+p
                          end;
                        a1[l]:=s;
                        s:=abs(s);
                        if (j<n2) and (s>max)
                          then begin
                                 max:=s;
                                 jh:=j;
                                 lh:=l
                               end
                      end;
             if max=0
               then st:=3
               else begin
                      max:=1/a1[lh];
                      r[jh]:=k;
                      for i:=1 to p do
                        a1[i]:=max*a1[i];
                      jh:=0;
                      q:=0;
                      for j:=1 to kh do
                        begin
                          s:=x[q+lh];
                          for i:=1 to p do
                            if i<>lh
                              then begin
                                     jh:=jh+1;
                                     x[jh]:=x[q+i]-s*a1[i]
                                   end;
                          q:=q+p
                        end;
                      for i:=1 to p do
                        if i<>lh
                          then begin
                                 jh:=jh+1;
                                 x[jh]:=a1[i]
                               end;
                      p:=p-1
                    end
           until (k=n1) or (st=3);
           if st=0
             then for k:=1 to n1 do
                    begin
                      rh:=r[k];
                      if rh<>k
                        then begin
                               s:=x[k];
                               x[k]:=x[rh];
                               i:=r[rh];
                               while i<>k do
                                 begin
                                   x[rh]:=x[i];
                                   r[rh]:=rh;
                                   rh:=i;
                                   i:=r[rh]
                                 end;
                               x[rh]:=s;
                               r[rh]:=rh
                             end
                    end
         end;
  if st=0
    then begin
           i:=0;
           for k:=1 to n1 do
             begin
               i:=i+1;
               j:=trunc((k-1)/m);
               u[i,j]:=x[k];
               if i=m
                 then i:=0
             end
         end
end;