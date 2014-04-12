procedure HessenbergQR (n          : Integer;
                        var h      : matrix;
                        it         : Integer;
                        eps        : extended;
                        var lambda : vector;
                        var st     : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure HessenbergQR finds the eigenvalues of the Hessenberg       }
{  matrix by the QR algorithm.                                              }
{  Data:                                                                    }
{    n   - number of rows (columns) of the Hessenberg matrix,               }
{    h   - an array containing the values of elements of the Hessenberg     }
{          matrix,                                                          }
{    it  - maximum number of iterations for finding each eigenvalue,        }
{    eps - absolute accuracy for finding eigenvalues.                       }
{  Result:                                                                  }
{    lambda - an array of eigenvalues.                                      }
{  Other parameters:                                                        }
{    st   - a variable which within the procedure HessenbergQR is assigned  }
{           the value of:                                                   }
{             1, if n<1,                                                    }
{             2, if during the decomposition the first column of a matrix   }
{                to be decomposed is the zero-column,                       }
{             3, if the given accuracy eps is not achieved under it         }
{                iterations (when finding any of the eigenvalue),           }
{             0, otherwise.                                                 }
{           Note: If st=1, then the elements of array lambda are not        }
{                 calculated. If st=2 or st=3, then the eigenvalues found   }
{                 occupies the end of array lambda, and the remaining       }
{                 elements of this array are equal to 0. If st=3, then it   }
{                 is possible that the given Hessenberg matrix has complex  }
{                 eigenvalues.                                              }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q1..qn], where q1<=1 and }
{             qn>=n,                                                        }
{    matrix - a type identifier of extended array [q1..qn,q1..qn], where    }
{             q1<=1 and qn>=n.                                              }
{                                                                           }
{---------------------------------------------------------------------------}
var i,j,k,count,n1 : Integer;
    ap,hl,s,wk     : Extended;
    q,r            : matrix;
begin
  if n<1
    then st:=1
    else begin
           n1:=n;
           for i:=1 to n do
           lambda[i]:=0;
           st:=0;
           repeat
             count:=0;
             repeat
               count:=count+1;
               if count>it
                 then st:=3
                 else begin
                        wk:=h[n1,n1];
                        hl:=wk;
                        for i:=1 to n1 do
                          h[i,i]:=h[i,i]-wk;
                        s:=0;
                        for j:=1 to n1 do
                          begin
                            ap:=h[j,1];
                            s:=s+ap*ap
                          end;
                        s:=sqrt(s);
                        if s=0
                          then st:=2
                          else begin
                                 r[1,1]:=s;
                                 for j:=1 to n1 do
                                   q[j,1]:=h[j,1]/s;
                                 for i:=2 to n1 do
                                   begin
                                     for k:=1 to i-1 do
                                       begin
                                         s:=0;
                                         for j:=1 to n1 do
                                           s:=s+q[j,k]*h[j,i];
                                         r[k,i]:=s
                                       end;
                                     for j:=1 to n1 do
                                       begin
                                         s:=0;
                                         for k:=1 to i-1 do
                                           s:=s+q[j,k]*r[k,i];
                                         q[j,i]:=h[j,i]-s
                                       end;
                                     s:=0;
                                     for j:=1 to n1 do
                                       s:=s+q[j,i]*q[j,i];
                                     s:=sqrt(s);
                                     if s=0
                                       then for j:=1 to n1 do
                                              q[j,i]:=0
                                       else for j:=1 to n1 do
                                              q[j,i]:=q[j,i]/s;
                                     for j:=1 to i-1 do
                                       r[i,j]:=0;
                                     r[i,i]:=s
                                   end;
                                 for i:=1 to n1 do
                                   begin
                                     for j:=1 to n1 do
                                       begin
                                         s:=0;
                                         for k:=1 to n1 do
                                           s:=s+r[i,k]*q[k,j];
                                         h[i,j]:=s
                                       end;
                                     h[i,i]:=h[i,i]+wk
                                   end
                               end
                      end
             until (abs(h[n1,n1]-hl)<=eps) and (h[n1,n1-1]=0)
                   or (st<>0);
             if st=0
               then begin
                      lambda[n1]:=h[n1,n1];
                      n1:=n1-1
                    end
           until (n1=1) or (st<>0);
           if st=0
             then lambda[1]:=h[1,1]
         end
end;