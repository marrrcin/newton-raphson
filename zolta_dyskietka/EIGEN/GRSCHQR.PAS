procedure GramSchmidtQR (m,n     : Integer;
                         var a,q : matrix;
                         var r   : matrix1;
                         var st  : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure GramSchmidtQR decomposes a given matrix to the QR product  }
{  (Q - orthogonal matrix, R - upper triangular matrix) by the Gram-Schmidt }
{  orthogonalization method.                                                }
{  Data:                                                                    }
{    m - number of rows of the matrix to be decomposed,                     }
{    n - number of columns of this matrix (n<=m),                           }
{    a - an array containing the values of the elements of the matrix to be }
{        decomposed.                                                        }
{  Results:                                                                 }
{    q - an array containing the values of the elements of orthogonal       }
{        matrix Q,                                                          }
{    r - an array containing the values of the elements of upper triangular }
{        matrix R.                                                          }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure GramSchmidtQR is assigned }
{           the value of:                                                   }
{             1, if n<1 or m<n,                                             }
{             2, if the first column of the given matrix is the             }
{                zero-vector,                                               }
{             0, otherwise.                                                 }
{           Note: If st=1, then the elements of array q and r are           }
{                 calculated, and if st=2, then q[i,j]=0 (i=1,2,...,m;      }
{                 j=1,2,...,n) and r[i,j]=0 (i,j=1,2,...,n).                }
{  Unlocal identifiers:                                                     }
{    vector  - a type identifier of extended array [q1..qm], where q1<=1    }
{              and qm>=m,                                                   }
{    matrix  - a type identifier of extended array [q1..qm,q1..qn], where   }
{              q1<=1, qm>=m and qn>=n,                                      }
{    matrix1 - a type identifier of extended array [q1..qn,q1..qn], where   }
{              q1<=1 and qn>=n.                                             }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k : Integer;
    ap,s  : Extended;
    p     : vector;
begin
  if (n<1) or (m<n)
    then st:=1
    else begin
           for j:=1 to n do
             begin
               for i:=1 to m do
                 q[i,j]:=0;
               for i:=1 to n do
                 r[i,j]:=0
             end;
           s:=0;
           for j:=1 to m do
             begin
               ap:=a[j,1];
               s:=s+ap*ap
             end;
           s:=sqrt(s);
           if s=0
             then st:=2
             else begin
                    st:=0;
                    r[1,1]:=s;
                    for j:=1 to m do
                      q[j,1]:=a[j,1]/s;
                    for i:=2 to n do
                      begin
                        for k:=1 to i-1 do
                          begin
                            s:=0;
                            for j:=1 to m do
                              s:=s+q[j,k]*a[j,i];
                            r[k,i]:=s
                          end;
                        for j:=1 to m do
                          begin
                            s:=0;
                            for k:=1 to i-1 do
                              s:=s+q[j,k]*r[k,i];
                            p[j]:=a[j,i]-s
                          end;
                        for k:=1 to i-1 do
                          begin
                            s:=0;
                            for j:=1 to m do
                              s:=s+q[j,k]*p[j];
                            for j:=1 to m do
                              p[j]:=p[j]-q[j,k]*s;
                            r[k,i]:=r[k,i]+s
                          end;
                        s:=0;
                        for j:=1 to m do
                          s:=s+p[j]*p[j];
                        s:=sqrt(s);
                        if s=0
                          then for j:=1 to m do
                                 q[j,i]:=0
                          else for j:=1 to m do
                                 q[j,i]:=p[j]/s;
                        for j:=1 to i-1 do
                          r[i,j]:=0;
                        r[i,i]:=s
                      end
                  end
         end
end;