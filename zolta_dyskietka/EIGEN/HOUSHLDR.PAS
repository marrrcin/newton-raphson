procedure Householder (n       : Integer;
                       var a   : matrix;
                       var d,e : vector;
                       var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure Householder converts a symmetric matrix A into a symmetric }
{  tridiagonal matrix B and finds the vectors u[j]=(u[j,1],u[j,2],...,      }
{  u[j,j-1],0,...,0) such that A=P[n]*...*P[3]*B*P[3]*...*P[n] and          }
{  P[j]=I+u[j]*v[j]/(e[j]*u[j,j-1]), where I denotes the identity matrix,   }
{  v[j] - the transposition of u[j], and e[j] are elements below (above)    }
{  the main diagonal of B (j=2,3,...,n).                                    }
{  Data:                                                                    }
{    n - number of rows (columns) of matrix A,                              }
{    a - an array containing the values of the elements of matrix A.        }
{        Note: Within the procedure Householder it is used the lower        }
{              triangle of array a, i.e. the elements a[j,k] for k<j are    }
{              changed on exit.                                             }
{  Results:                                                                 }
{    d - an array of the diagonal elements of matrix B,                     }
{    e - an array in which e[1]=0 and the elements e[i] (i=2,3,...,n)       }
{        contain the values below (and above) the main diagonal of matrix B,}
{    a - an array the elements a[j,k] of which contain the values of        }
{        u[j,k], where j=3,4,...,n and k=1,2,...,j-1.                       }
{        Note: The elements a[j,k] for j<=k are not changed on exit.        }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure Householder is assigned   }
{           the value of:                                                   }
{             1, if n<1,                                                    }
{             2, if the given matrix is not symmetric,                      }
{             0, otherwise.                                                 }
{           Note: If st=1 or st=2, then the elements of arrays d and e are  }
{                 not calculated and the elements of a are not changed on   }
{                 exit.                                                     }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var j,k,l,l1 : Integer;
    g,h,s    : Extended;
begin
  st:=0;
  if n<1
    then st:=1;
  for j:=2 to n do
    for k:=1 to j-1 do
      if a[j,k]<>a[k,j]
        then st:=2;
  if st=0
    then begin
           for l:=1 to n do
             d[l]:=a[l,l];
           for l:=n downto 2 do
             begin
               s:=0;
               for k:=l-2 downto 1 do
                 begin
                   h:=a[l,k];
                   s:=s+h*h
                 end;
               l1:=l-1;
               h:=a[l,l1];
               if s=0
                 then begin
                        e[l]:=h;
                        a[l,l1]:=0
                      end
                 else begin
                        s:=s+h*h;
                        g:=sqrt(s);
                        if h>=0
                          then g:=-g;
                        e[l]:=g;
                        s:=1/(s-h*g);
                        a[l,l1]:=h-g;
                        h:=0;
                        for j:=1 to l1 do
                          begin
                            g:=0;
                            for k:=1 to j do
                              g:=g+a[j,k]*a[l,k];
                            for k:=j+1 to l1 do
                              g:=g+a[k,j]*a[l,k];
                            g:=g*s;
                            e[j]:=g;
                            h:=h+a[l,j]*g
                          end;
                        h:=0.5*h*s;
                        for j:=1 to l1 do
                          begin
                            s:=a[l,j];
                            g:=e[j]-h*s;
                            e[j]:=g;
                            for k:=1 to j do
                              a[j,k]:=a[j,k]-s*e[k]-a[l,k]*g
                          end
                      end;
               h:=d[l];
               d[l]:=a[l,l];
               a[l,l]:=h
             end;
           h:=d[1];
           d[1]:=a[1,1];
           a[1,1]:=h;
           e[1]:=0
         end
end;