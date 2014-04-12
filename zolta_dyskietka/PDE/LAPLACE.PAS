procedure Laplace (n,m,nu : Integer;
                   x,y    : vector;
                   eln    : matrix;
                   nuxy   : vector1;
                   uxy    : vector2;
                   var u  : vector3;
                   var st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Laplace solves the Laplace equation by the finite element  }
{  method.                                                                  }
{  Data:                                                                    }
{    n    - number of nodes,                                                }
{    m    - number of elements,                                             }
{    nu   - number of nodes where the values of boundary function are known,}
{    x    - an array whose i-th element contains the x coordinate of the    }
{           i-th node (i=1,2,...,n),                                        }
{    y    - an array whose i-th element contains the y coordinate of the    }
{           i-th node (i=1,2,...,n),                                        }
{    eln  - an array of nodes corresponding to each element (the element    }
{           els[k,j] should contain the number of the j-th node of the k-th }
{           element; k=1,2,...,m; j=1,2,3),                                 }
{    nuxy - an array of node numbers of nodes where the values of boundary  }
{           function are known (the element nuxy[l] should contain the node }
{           number of the l-th such a node; l=1,2,...,nu),                  }
{    uxy  - an array of the values of boundary function in some nodes (the  }
{           element uxy[l] should contain the value of boundary function at }
{           the node nuxy[l]; l=1,2,...,nu).                                }
{  Result:                                                                  }
{    u - an array containing the solution at each node (the element u[i]    }
{        contains the solution at the i-th node; i=1,2,...,n).              }
{        Note: Within the procedure the elements u[i] for i>n are used as   }
{              work area.                                                   }
{  Other parameters:                                                        }
{    st - a variable which within the procedure Laplace is assigned the     }
{         value of:                                                         }
{           1, if n<3 or m<1 or nu<0,                                       }
{           2, if the matrix of a linear system occuring in the algorithm   }
{              is singular,                                                 }
{           3, if an error in element node numbering is detected,           }
{           0, otherwise.                                                   }
{         Note: If st<>0, then the elements of array u are not calculated.  }
{  Unlocal identifiers:                                                     }
{    vector     - a type identifier of extended array [q1..qn], where q1<=1 }
{                 and qn>=n,                                                }
{    vector1    - a type identifier of integer array [q1..qnu], where q1<=1 }
{                 and qnu>=nu,                                              }
{    vector2    - a type identifier of extended array [q1..qnu], where      }
{                 q1<=1 and qnu>=nu,                                        }
{    vector3    - a type identifier of extended array [q1..qn2], where      }
{                 q1<=1 and qn2>=(n+2)*(n+2)/4,                             }
{    vector4    - a type identifier of extended array [q1..q3], where q1<=1 }
{                 and q3>=3,                                                }
{    vector5    - a type identifier of integer array [q1..qn1], where q1<=1 }
{                 and qn1>=n+1,                                             }
{    vector6    - a type identifier of extended array [q1..qn1], where      }
{                 q1<=1 and qn1>=n+1,                                       }
{    matrix     - a type identifier of integer array [q1..qm,q1..q3], where }
{                 q1<=1, qm>=m and q3>=3,                                   }
{    matrix1    - a type identifier of integer array [q1..qn,q1..q7], where }
{                 q1<=1, qn>=n and q7>=7,                                   }
{    matrix3dim - a type identifier of extended array                       }
{                 [q1..qm,q1..qm,q1..q3], where q1<=1, qm>=m and q3>=3.     }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,j1,j2,jh,k,kh,l,lh,n1,p,q,q1,rh  : Integer;
    delta,max,s                          : Extended;
    nep,neq                              : Boolean;
    xx,yy,a,b,c                          : vector4;
    r                                    : vector5;
    av,bv                                : vector6;
    nsr                                  : matrix1;
    ste                                  : matrix3dim;
begin
  st:=0;
  if (n<3) or (m<1) or (nu<0)
    then st:=1
    else begin
           n1:=n+1;
           for i:=1 to n do
             nsr[i,1]:=0;
           for i:=1 to m do
             for j:=1 to 3 do
               begin
                 p:=eln[i,j];
                 nsr[p,1]:=nsr[p,1]+1;
                 l:=nsr[p,1]+1;
                 nsr[p,l]:=i
               end;
           for i:=1 to m do
             begin
               for j:=1 to 3 do
                 begin
                   p:=eln[i,j];
                   xx[j]:=x[p];
                   yy[j]:=y[p]
                 end;
               for j:=1 to 3 do
                 begin
                   p:=j+1;
                   l:=j+2;
                   if p=3
                     then l:=1
                     else if p>3
                            then begin
                                   p:=1;
                                   l:=2
                                 end;
                   b[j]:=yy[p]-yy[l];
                   c[j]:=xx[l]-xx[p]
                 end;
               s:=c[3]*b[2];
               delta:=(s-c[2]*b[3])/2;
               for kh:=1 to 3 do
                 for jh:=1 to 3 do
                   begin
                     s:=b[kh]*b[jh];
                     s:=s+c[kh]*c[jh];
                     ste[i,kh,jh]:=s/(4*delta)
                   end
             end;
           for i:=1 to n1 do
             r[i]:=0;
           p:=n1;
           k:=0;
           repeat
             k:=k+1;
             for j:=1 to n1 do
               av[j]:=0;
             neq:=true;
             i:=1;
             while (i<=nu) and neq do
               if k=nuxy[i]
                 then begin
                        av[k]:=1;
                        av[n1]:=uxy[i];
                        neq:=false
                      end
                 else i:=i+1;
             while neq do
               begin
                 j:=1;
                 repeat
                   j:=j+1;
                   q1:=nsr[k,j];
                   nep:=true;
                   i:=1;
                   while (i<=3) and nep do
                     if eln[q1,i]=k
                       then for j2:=1 to 3 do
                              begin
                                j1:=eln[q1,j2];
                                av[j1]:=av[j1]+ste[q1,i,j2];
                                nep:=false
                              end
                       else i:=i+1;
                   if nep
                     then st:=3
                 until (j=nsr[k,1]+1) or (st=3);
                 neq:=false
               end;
             if st=0
               then begin
                      for i:=1 to n do
                        begin
                          rh:=r[i];
                          if rh<>0
                            then bv[rh]:=av[i]
                        end;
                      kh:=k-1;
                      l:=0;
                      max:=0;
                      for j:=1 to n1 do
                        if r[j]=0
                          then begin
                                 s:=av[j];
                                 l:=l+1;
                                 q:=l;
                                 for i:=1 to kh do
                                   begin
                                     s:=s-bv[i]*u[q];
                                     q:=q+p
                                   end;
                                 av[l]:=s;
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
                               max:=1/av[lh];
                               r[jh]:=k;
                               for i:=1 to p do
                                 av[i]:=max*av[i];
                               jh:=0;
                               q:=0;
                               for j:=1 to kh do
                                 begin
                                   s:=u[q+lh];
                                   for i:=1 to p do
                                     if i<>lh
                                       then begin
                                              jh:=jh+1;
                                              u[jh]:=u[q+i]-s*av[i]
                                            end;
                                   q:=q+p
                                 end;
                               for i:=1 to p do
                                 if i<>lh
                                   then begin
                                          jh:=jh+1;
                                          u[jh]:=av[i]
                                        end;
                               p:=p-1
                             end
                    end
           until (k=n) or (st=2) or (st=3);
           if st=0
             then for k:=1 to n do
                    begin
                      rh:=r[k];
                      if rh<>k
                        then begin
                               s:=u[k];
                               u[k]:=u[rh];
                               i:=r[rh];
                               while i<>k do
                                 begin
                                   u[rh]:=u[i];
                                   r[rh]:=rh;
                                   rh:=i;
                                   i:=r[rh]
                                 end;
                               u[rh]:=s;
                               r[rh]:=rh
                             end
                    end
         end
end;