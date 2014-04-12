procedure GaussJordan (n      : Integer;
                       oneeqn : coefficients;
                       var x  : vector;
                       var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure GaussJordan solves a system of n linear equations of the   }
{  form a[i,1]x[1] + a[i,2]x[2] +...+ a[i,n]x[n] = a[i,n+1] (i=1,2,...,n)   }
{  by the Gauss-Jordan elimination method with complete pivoting.           }
{  Data:                                                                    }
{    n       - number of equations,                                         }
{    oneeqn  - a Turbo Pascal procedure which for the given i calculates    }
{              the elements of the i-th row of the matrix of system.        }
{  Result:                                                                  }
{    x - an array containing the solution (the element x[i] contains the    }
{        i-th component of the solution; i=1,2,...,n).                      }
{  Other parameters:                                                        }
{    st - a variable which within the procedure GaussJordan is assigned the }
{         value of:                                                         }
{           1, if n<1,                                                      }
{           2, if the matrix of the system is singular,                     }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array x are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector       - a type identifier of extended array [q1..gn2], where    }
{                   q1<=1 and qn2>=(n+2)(n+2)/4,                            }
{    vector1      - a type identifier of extended array [q1..qn1], where    }
{                   q1<=1 and qn1>=n+1,                                     }
{    vector2      - a type identifier of integer array [q1..qn1], where     }
{                   qn1>=n+1,                                               }
{    coefficients - a procedural-type identifier defined as follows         }
{                     type coefficients = procedure (i,n   : Integer;       }
{                                                    var a : vector1);      }
{                   (on exit the element a[j] should contain the value of   }
{                   the coefficient a[i,j] of the system; j=1,2,...,n+1).   }
{  Note: A procedure passed as a parameter should be declared with a far    }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,jh,k,kh,l,lh,n1,p,q,rh : Integer;
    max,s                      : Extended;
    a,b                        : vector1;
    r                          : vector2;
begin
  st:=0;
  if n<1
    then st:=1;
  if st=0
    then begin
           n1:=n+1;
           p:=n1;
           for i:=1 to n1 do
             r[i]:=0;
           k:=0;
           repeat
             k:=k+1;
             oneeqn (k,n1,a);
             for i:=1 to n do
               begin
                 rh:=r[i];
                 if rh<>0
                   then b[rh]:=a[i]
               end;
             kh:=k-1;
             l:=0;
             max:=0;
             for j:=1 to n1 do
               if r[j]=0
                 then begin
                        s:=a[j];
                        l:=l+1;
                        q:=l;
                        for i:=1 to kh do
                          begin
                            s:=s-b[i]*x[q];
                            q:=q+p
                          end;
                        a[l]:=s;
                        s:=abs(s);
                        if (j<n1) and (s>max)
                          then begin
                                 max:=s;
                                 jh:=j;
                                 lh:=l
                               end
                      end;
             if max=0
               then st:=2
               else begin
                      max:=1/a[lh];
                      r[jh]:=k;
                      for i:=1 to p do
                        a[i]:=max*a[i];
                      jh:=0;
                      q:=0;
                      for j:=1 to kh do
                        begin
                          s:=x[q+lh];
                          for i:=1 to p do
                            if i<>lh
                              then begin
                                     jh:=jh+1;
                                     x[jh]:=x[q+i]-s*a[i]
                                   end;
                          q:=q+p
                        end;
                      for i:=1 to p do
                        if i<>lh
                          then begin
                                 jh:=jh+1;
                                 x[jh]:=a[i]
                               end;
                      p:=p-1
                    end
           until (k=n) or (st=2);
           if st=0
             then for k:=1 to n do
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
         end
end;