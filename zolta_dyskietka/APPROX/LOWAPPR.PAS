procedure lowdegapprox (n        : Integer;
                        var a    : vector;
                        eps      : Extended;
                        var p,st : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure lowdegapprox approximates the polynomial a[0]+a[1]*x+...   }
{  ...+a[n]*x^n by a polynomial of a lower degree with the maximum error    }
{  not greater than eps in the interval [-1,1].                             }
{  Data:                                                                    }
{    n   - the degree of the polynomial which will be approximated,         }
{    a   - an array of coefficients of the polynomial which will be         }
{          approximated (changed on exit),                                  }
{    eps - desired accuracy of approximation.                               }
{  Results:                                                                 }
{    p - the degree of the approximation polynomial (p<=n),                 }
{    a - an array of coefficients of the approximation polynomial (the      }
{        elements a[0], a[1], ..., a[p] contain the required values of      }
{        coefficients of the approximation polynomial, and the elements     }
{        a[p+1], a[p+2], ..., a[n] contain the values of coefficients of    }
{        the given polynomial expressed as a linear combination of          }
{        Chebyshev's polynomials of the degrees p+1, p+2, ..., n).          }
{  Others parameters:                                                       }
{    st - a variable which within the procedure lowdegapprox is assigned    }
{         the value of:                                                     }
{           1, if n<0,                                                      }
{           0, otherwise.                                                   }
{         Note: If st=1, then p is not calculated and a is not changed on   }
{               exit.                                                       }
{  Unlocal identifier:                                                      }
{    vector - a type identifier of extended array [q0..qn], where q0<=0 and }
{             q>=n.                                                         }
{                                                                           }
{---------------------------------------------------------------------------}
var j,k  : Integer;
    ak,r : Extended;
begin
  if n<0
    then st:=1
    else begin
           st:=0;
           for j:=n downto 2 do
             for k:=j to n do
               begin
                 ak:=0.5*a[k];
                 a[k]:=ak;
                 a[k-2]:=a[k-2]+ak
               end;
           p:=n;
           r:=abs(a[p]);
           while (r<=eps) and (p>0) do
             begin
               p:=p-1;
               r:=r+abs(a[p])
             end;
           for j:=2 to p do
             for k:=p downto j do
               begin
                 ak:=a[k];
                 a[k-2]:=a[k-2]-ak;
                 a[k]:=2*ak
               end
         end
end;