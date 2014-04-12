procedure diffmethod (n,m                 : Integer;
                      alpha,beta          : Extended;
                      a,b,c,d,e,f,g       : coefficient;
                      phi1,phi2,phi3,phi4 : boundary;
                      var u               : matrix;
                      var kind,st         : Integer);
{---------------------------------------------------------------------------}
{                                                                           }
{  The procedure diffmethod solves the second order partial differential    }
{  equation a(x,y)u|xx + 2b(x,y)u|xy + c(x,y)u|yy + 2d(x,y)u|x + 2e(x,y)u|y }
{  + g(x,y)u = f(x,y), where u=u(x,y), u|xx denotes the second partial      }
{  derivative of u with respect to x, u:xy - the second mixed partial       }
{  derivative of u with respect to x and y, u|x - the first partial         }
{  derivative of u with respect to x, etc., 0<=x<=alpha, 0<=y<=beta, with   }
{  the boundary conditions u=phi1(y) for x=0, u=phi2(x) for y=0, u=phi3(y)  }
{  for x=alpha, u=phi4(x) for y=beta, where phi1(0)=phi2(0),                }
{  phi2(alpha)=phi3(0), phi3(beta)=phi4(alpha), phi4(0)=phi1(beta). The     }
{  functions a=a(x,y), b=b(x,y), c=c(x,y) for each 0<x<alpha and 0<y<beta   }
{  must fulfill one of the following condition: b(x,y)b(x,y)-a(x,y)c(x,y)<0 }
{  or b(x,y)b(x,y)-a(x,y)c(x,y)=0 or b(x,y)b(x,y)-a(x,y)c(x,y)>0. The       }
{  problem is solved by a difference method.                                }
{  Data:                                                                    }
{    n                   - number of subintervals in the interval           }
{                          [0,alpha],                                       }
{    m                   - number of subintervals in the interval           }
{                          [0,beta],                                        }
{    alpha               - maximum value of x,                              }
{    beta                - maximum value of y,                              }
{    a,b,c,d,e,f,g       - Turbo Pascal functions which calculate the       }
{                          values of functions a=a(x,y), b=b(x,y),          }
{                          c=c(x,y), d=d(x,y), e=e(x,y), f=f(x,y) and       }
{                          g=g(x,y) occurring in the differential equation, }
{    phi1,phi2,phi3,phi4 - Turbo Pascal functions which calculate the       }
{                          values of functions phi1=phi1(y), phi2=phi2(x),  }
{                          phi3=phi3(y) and phi4=phi4(x) occurring in the   }
{                          boundary conditions.                             }
{  Result:                                                                  }
{    u - an array containing the solution (the element u[i,j] contains the  }
{        solution at the point (ih,jk), where i=0,1,...,n, j=0,1,...,m,     }
{        h=alpha/n, k=beta/m.                                               }
{  Other parameters:                                                        }
{    kind - a variable which determines the kind of the equation and which  }
{           within the procedure diffmethod is assigned the value of:       }
{             1, if the equation is elliptic and st=0 or st=5,              }
{             2, if the equation is parabolic and st=0 or st=5,             }
{             3, if the equation is hyperbolic and st=0 or st=5,            }
{             0, if st<>0 and st<>5.                                        }
{    st   - a variable which within the procedure diffmethod is assigned    }
{           the value of:                                                   }
{             1, if n<2 or m<2,                                             }
{             2, if alpha<=0 or beta<=0,                                    }
{             3, if the equation is not elliptic, parabolic, nor hyperbolic,}
{             4, if at least one of the conditions phi1(0)=phi2(0),         }
{                phi2(alpha)=phi3(0), phi3(beta)=phi4(alpha),               }
{                phi4(0)=phi1(beta) is not fulfilled (that means the        }
{                boundary conditions are wrong),                            }
{             5, if the matrix of adequate linear system is singular,       }
{             0, otherwise.                                                 }
{           Note: If st<>0, then the elements of array u are not            }
{                 calculated.                                               }
{  Unlocal identifiers:                                                     }
{    vector      - a type identifier of extended array [q1..qn1m1], where   }
{                  q1<=1 and qn1m1>=(n-1)*(m-1)+1,                          }
{    vector1     - a type identifier of extended array [q1..qnm4], where    }
{                  q1<=1 and qnm4>=(n*m-n-m+4)*(n*m-n-m+4)/4,               }
{    vector2     - a type identifier of integer array [q1..qn1m1], where    }
{                  q1<=1 and qn1m1>=(n-1)*(m-1)+1,                          }
{    matrix      - a type identifier of extended array [q0..qn,q0..qm],     }
{                  where q0<=0, qn>=n and qm>=m,                            }
{    coefficient - a procedural-type identifier defined as follows          }
{                    type coefficient = function (x,y : Extended)           }
{                                       : Extended;                         }
{    boundary    - a procedural-type identifier defined as follows          }
{                    type boundary = function (x : Extended) : Extended;    }
{  Notes: 1) Any function passed as a parameter should be declared with a   }
{            far directive or compiled in the $F+ state.                    }
{         2) If the stack overflow error is reported when using this        }
{            procedure, increase the size of the stack by using the $M      }
{            compiler directive in your program.                            }
{                                                                           }
{---------------------------------------------------------------------------}
var   i,j,jh,j1,k,kh,l,lh,l1,l2,n1,n2,p,q,rh : Integer;
      af,bf,cf,df,ef,h1,h2,hh1,hh2,max,s     : Extended;
      a1,b1                                  : vector;
      x                                      : vector1;
      r                                      : vector2;
function boundconds (b1,b2 : Extended) : Integer;
var u,v : Extended;
begin
  u:=abs(b1);
  v:=abs(b2);
  if u<v
    then u:=v;
  boundconds:=0;
  if u<>0
    then if abs(b1-b2)/u>=1.0e-14
           then boundconds:=4
end {boundconds};
begin
  st:=0;
  if (n<2) or (m<2)
    then st:=1
    else if (alpha<=0) or (beta<=0)
           then st:=2
           else begin
                  h1:=alpha/n;
                  h2:=beta/m;
                  for i:=0 to n do
                    begin
                      hh1:=i*h1;
                      for j:=0 to m do
                        begin
                          hh2:=j*h2;
                          s:=b(hh1,hh2);
                          if s*s-a(hh1,hh2)*c(hh1,hh2)>=0
                            then st:=3
                        end
                    end;
                  if st=0
                    then kind:=1
                    else begin
                           st:=0;
                           for i:=0 to n do
                             begin
                               hh1:=i*h1;
                               for j:=0 to m do
                                 begin
                                   hh2:=j*h2;
                                   s:=b(hh1,hh2);
                                   if s*s-a(hh1,hh2)*c(hh1,hh2)<>0
                                     then st:=3
                                 end
                             end;
                           if st=0
                             then kind:=2
                             else begin
                                    st:=0;
                                    for i:=0 to n do
                                      begin
                                        hh1:=i*h1;
                                        for j:=0 to m do
                                          begin
                                            hh2:=j*h2;
                                            s:=b(hh1,hh2);
                                            if s*s-a(hh1,hh2)*c(hh1,hh2)<=0
                                              then st:=3
                                          end
                                      end;
                                    if st=0
                                      then kind:=3
                                  end
                         end
                end;
  if st=0
    then begin
           st:=boundconds(phi1(0.0e0),phi2(0.0e0));
           if st=0
             then begin
                    st:=boundconds(phi2(alpha),phi3(0.0e0));
                    if st=0
                      then begin
                             st:=boundconds(phi3(beta),phi4(alpha));
                             if st=0
                               then st:=boundconds(phi4(0.0e0),phi1(beta))
                           end
                  end
         end;
  if st=0
    then begin
           n1:=(n-1)*(m-1);
           n2:=n1+1;
           p:=n2;
           for i:=1 to n2 do
             r[i]:=0;
           k:=0;
           j:=0;
           repeat
             k:=k+1;
             for i:=1 to n1 do
               a1[i]:=0;
             j:=j+1;
             s:=k-1;
             i:=trunc(s/(m-1))+1;
             l1:=(i-2)*(m-1)+j;
             l2:=l1+m-1;
             hh1:=i*h1;
             hh2:=j*h2;
             af:=a(hh1,hh2)/h1;
             bf:=b(hh1,hh2)/(2*h1*h2);
             cf:=c(hh1,hh2)/h2;
             df:=d(hh1,hh2);
             ef:=e(hh1,hh2);
             if i>1
               then begin
                      a1[l1]:=(af-df)/h1;
                      if j>1
                        then a1[l1-1]:=bf;
                      if j<m-1
                        then a1[l1+1]:=-bf
                    end;
             a1[l2]:=g(hh1,hh2)-2*(af/h1+cf/h2);
             if j>1
               then a1[l2-1]:=(cf-ef)/h2;
             if j<m-1
               then a1[l2+1]:=(cf+ef)/h2;
             l1:=l2+m-1;
             if i<n-1
               then begin
                      a1[l1]:=(af+df)/h1;
                      if j>1
                        then a1[l1-1]:=-bf;
                      if j<m-1
                        then a1[l1+1]:=bf
                    end;
             s:=f(hh1,hh2);
             if i=1
               then begin
                      s:=s+bf*(phi1(hh2+h2)-phi1(hh2-h2))-(af-df)*phi1(hh2)
                         /h1;
                      if j=1
                        then s:=s-(cf-ef)*phi2(hh1)/h2+bf*phi2(hh1+h1);
                      if j=m-1
                        then s:=s-(cf+ef)*phi4(hh1)/h2-bf*phi4(hh1)
                    end
               else if i=n-1
                      then begin
                             s:=s+bf*(phi3(hh2-h2)-phi3(hh2+h2))-(af+df)
                                *phi3(hh2)/h2;
                             if j=1
                               then s:=s-bf*phi2(hh1-h1)-(cf-ef)*phi2(hh1)
                                       /h2;
                             if j=m-1
                               then s:=s+bf*phi4(hh1-h1)-(cf+ef)*phi4(hh1)/h2
                           end
                      else begin
                             if j=1
                               then s:=s+bf*(phi2(hh1+h1)-phi2(hh1-h1))
                                       -(cf-ef)*phi2(hh1)/h2;
                             if j=m-1
                               then s:=s+bf*(phi4(hh1-h1)-phi4(hh1+h1))
                                       -(cf+ef)*phi4(hh1)/h2
                           end;
             a1[n2]:=s;
             for i:=1 to n1 do
               begin
                 rh:=r[i];
                 if rh<>0
                   then b1[rh]:=a1[i]
               end;
             kh:=k-1;
             l:=0;
             max:=0;
             for j1:=1 to n2 do
               if r[j1]=0
                 then begin
                        s:=a1[j1];
                        l:=l+1;
                        q:=l;
                        for i:=1 to kh do
                          begin
                            s:=s-b1[i]*x[q];
                            q:=q+p
                          end;
                        a1[l]:=s;
                        s:=abs(s);
                        if (j1<n2) and (s>max)
                          then begin
                                 max:=s;
                                 jh:=j1;
                                 lh:=l
                               end
                      end;
             if max=0
               then st:=5
               else begin
                      max:=1/a1[lh];
                      r[jh]:=k;
                      for i:=1 to p do
                        a1[i]:=max*a1[i];
                      jh:=0;
                      q:=0;
                      for j1:=1 to kh do
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
                    end;
             if j=m-1
               then j:=0
           until (k=n1) or (st=5);
           if st=0
             then begin
                    for k:=1 to n1 do
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
                      end;
                    for i:=1 to n-1 do
                      for j:=1 to m-1 do
                        u[i,j]:=x[(i-1)*(m-1)+j];
                    for i:=1 to n-1 do
                      begin
                        hh1:=i*h1;
                        u[i,0]:=phi2(hh1);
                        u[i,m]:=phi4(hh1)
                      end;
                    for j:=0 to m do
                      begin
                        hh2:=j*h2;
                        u[0,j]:=phi1(hh2);
                        u[n,j]:=phi3(hh2)
                      end
                  end
         end;
  if (st<>0) and (st<>5)
    then kind:=0
end;