function GaussJacobi (f          : fx;
                      n          : Integer;
                      alpha,beta : Extended;
                      var x      : vector;
                      var st     : Integer) : Extended;
{---------------------------------------------------------------------------}
{                                                                           }
{  The function GaussJacobi calculates an approximate value of the integral }
{  from (1-x)^alpha*(1+x)^beta*f(x) in the interval [-1,1] by the Gauss-    }
{  -Jacobi quadrature formula.                                              }
{  Data:                                                                    }
{    f          - a Turbo Pascal function which for the given x calculates  }
{                 the value of f(x) occurring in the integrand,             }
{    n          - number of nodes minus 1 (the nodes are numbered from 0    }
{                 to n),                                                    }
{    alpha,beta - coefficients of the integral,                             }
{    x          - an array containing roots of the Jacobi polynomial of the }
{                 degree n+1 (the element x[k] should contain the value of  }
{                 the k-th root; k=0,1,...,n).                              }
{  Result:                                                                  }
{    GaussJacobi(f,n,alpha,beta,x,st) - approximate value of the integral.  }
{  Other parameters:                                                        }
{    st - a variable which within the function GaussJacobi is assigned the  }
{         value of:                                                         }
{           1, if n<1 or alpha<=-1 or beta<=-1,                             }
{           0, otherwise.                                                   }
{         Note: If st=1, then GaussJacobi(f,n,alpha,beta,x,st) is not       }
{               calculated.                                                 }
{  Unlocal identifiers:                                                     }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             qn>=n,                                                        }
{    fx     - a procedural-type identifier defined as follows               }
{               type fx = function (x : Extended) : Extended;               }
{  Note: A function passed as a parameter should be declared with a far     }
{        directive or compiled in the $F+ state.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var k,m,m1,m2           : Integer;
    ab,ar,j0,j1,j2,s,x1 : Extended;
function gamma (x : Extended) : Extended;
var f,w1,w2,z : Extended;
begin
  if x<7.0
    then begin
           f:=1;
           z:=x;
           while z<7.0 do
             begin
               x:=z;
               f:=f*z;
               z:=z+1
             end;
           x:=x+1;
           f:=-ln(f)
         end
    else f:=0;
  z:=1/(x*x);
  w1:=(8.40336134453781512e-4*z-5.95238095238095238e-4)*z;
  w1:=(w1+7.93650793650793651e-4*z)*z;
  w1:=(w1-2.77777777777777778e-3)*z+8.33333333333333333e-2;
  w2:=(x-0.5)*ln(x);
  w2:=f+w2-x+9.18938533204672742e-1;
  gamma:=exp(w2+w1/x)
end {gamma};
begin
  if (n>0) and (alpha>-1) and (beta>-1)
    then begin
           st:=0;
           s:=0;
           ab:=alpha+beta;
           for k:=0 to n do
             begin
               j0:=1;
               x1:=x[k];
               j1:=0.5*((ab+2)*x1+alpha-beta);
               for m:=1 to n-1 do
                 begin
                   m1:=m+1;
                   m2:=2*m;
                   ar:=((m2+ab+2)*(m2+ab+1)*x1/((m2+2)*(m1+ab))+(alpha-beta)
                       *ab*(ab+m2+1)/((ab+m1)*(m2+2)*(ab+m2)))*j1;
                   j2:=ar-(m2+ab+2)*(m+alpha)*(m+beta)*j0/(m1*(ab+m1)
                       *(m2+ab));
                   j0:=j1;
                   j1:=j2
                 end;
               j0:=-(2*n+ab+4)*(n+alpha+1)*(n+beta+1)*j1/((n+2)*(n+ab+2)
                   *(2*n+ab+2));
               j1:=-2*(n+alpha+1)*(n+beta+1)*j1/((2*n+ab+2)*(x1*x1-1));
               s:=s+f(x1)/(j0*j1)
             end;
           ar:=1;
           for k:=2 to n+2 do
             ar:=ar*k;
           GaussJacobi:=-(2*n+ab+4)*gamma(n+alpha+2)*gamma(n+beta+2)
                        *exp(ab*ln(2.0))*s/((n+ab+2)*gamma(n+ab+2)*ar)
         end
    else st:=1
end;