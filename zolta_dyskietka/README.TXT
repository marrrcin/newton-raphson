                                 ÚÄÄÄÄÄÄÄÄÄÄ¿
                                 ³ Contents ³
                                 ÀÄÄÄÄÄÄÄÄÄÄÙ
            1. Introduction ®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®®
            2. How the Procedures Are Store and How to Call Them
            3. Exemplary User's Program ®®®®®®®®®®®®®®®®®®®®®®®®
            4. Contents of the Diskette ®®®®®®®®®®®®®®®®®®®®®®®®


                               1. INTRODUCTION
                               ßßßßßßßßßßßßßßß

 The package is designed for a whole range of users of the IBM Personal
 Computer and compatibles. These include not only scientists, engineers and
 students, who make frequent use of numerical methods, but also all other
 users who face the need to solve mathematical problems.

 The package includes over 110 ready-made procedures and functions in such
 areas as interpolation, approximation, fast Fourier transform, systems of
 linear equations, eigen problems, nonlinear equations, numerical integration
 and differentiation, and ordinary and partial differential equations. All
 the procedures and functions have been written in Turbo Pascal - one of the
 most popular modern programming language developed by Borland Int. - and
 tested on an computer running Turbo Pascal Version 7.0 and Borland Pascal
 Version 7.0 compilers. Nevertheless, if you have an earlier version of these
 compilers (5.0, 5.5 or 6.0) or a later one (Object Pascal 1.0 or 2.0) you
 can also use the package.


           2. HOW THE PROCEDURES ARE STORE AND HOW TO CALL THEM
           ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 The functions and procedures of this package are grouped in directories
 (see Contents of the Diskette). Before using a particular procedure or
 function in your program read the appropriate description of it in the
 accompanying manual, paying special attention to the instructions on how to
 call the procedure or function from your program, what types of parameters
 to use, and what unlocal identifiers you should declare in your program.

 In order to use a particular procedure or function (or procedures and/or
 functions) of the package in your program you should use the I compiler
 directive of the form:

     {$I pathname}

 where pathname is the path plus the name of the file containing the
 procedure or function. For example, if you want to use the procedure
 "linorthogon" which is in the directory named ODE and in the file
 LINORTH.PAS, insert this diskette in drive A and use in your program the
 $I compiler directive like this:

     {$I a:\ode\linorth.pas}

 We recommend that you make an additional backup copy and use only this copy
 during your work, or create special directories (as on our distribution
 disk) on your hard disk and copy all the files to these directories.

 If you run your program in real DOS mode with a numerical procedure or
 function from this package and get the stack overflow error, then add at
 the beginning of your main program the $M compiler directive like this:

     {$M 65520,0,655360}

 In protected DOS mode you may add the following M compiler directive:

     {$M 65520}

 Since all procedures and functions use the extended type, which is specific
 for he mathematical coprocessor, you need to include in your program the
 following compiler directives:

     {$N+,E-}

 or - to emulate the coprocessor -

     {$N+,E+}


                        3. EXEMPLARY USER'S PROGRAM
                        ßßßßßßßßßßßßßßßßßßßßßßßßßßß

 program MYPROG;
 {$N+,E-}
 {$M 65520,0,655360}
 uses Crt, Dos;
 type vector     = array [1..10] of Extended;
      vector1    = array [1..110] of Extended;
      matrix     = array [1..10, 1..10] of Extended;
      matrix1    = array [1..10, 1..20] of Extended;
      matrix2    = array [1..110, 0..6] of Extended;
      matrix3    = array [0..7, 1..110] of Extended;
      atmatrix   = procedure (x     : Extended;
                              m     : Integer;
                              var a : matrix);
      ftfunction = procedure (x     : Extended;
                              m     : Integer;
                              var f : vector);
 var i, j, m, n, st                        : Integer;
     h1, h2, m1, m2, min, ms1, ms2, s1, s2 : Word;
     h, tau                                : Extended;
     sec                                   : Single;
     znak                                  : Char;
     kl                                    : Boolean;
     gamma, t                              : vector;
     b                                     : matrix;
     u                                     : matrix1;
 procedure comptime (h1, m1, s1, ms1, h2, m2, s2, ms2 : Word;
                     var min                          : Word;
                     var sec                          : Single);
 var t1, t2 : Double;
 begin
   if h2<h1
     then h2:=h2+24;
   t1:=h1*60+m1+(s1+ms1/100)/60;
   t2:=h2*60+m2+(s2+ms2/100)/60;
   t1:=t2-t1;
  min:=Trunc(t1);
  sec:=60*(t1-min)
 end {comptime};
 {$I A:\ODE\LINORTH.PAS}
 procedure atx (x     : Extended;
                m     : Integer;
                var a : matrix); far;
 begin
   a[1,1]:=0;
   a[1,2]:=1;
   a[2,1]:=1;
   a[2,2]:=0
 end {at};
 procedure ftx (x     : Extended;
                m     : Integer;
                var f : vector); far;
 begin
   f[1]:=0;
   f[2]:=2*Sin(x)
 end {ft};
 begin
   ClrScr;
   Write ('SOLVING THE LINEAR BOUNDARY VALUE PROBLEM BY THE ');
   Writeln ('ORTHOGONALIZATION METHOD');
   Write ('*************************************************');
   Writeln ('************************');
   Writeln;
   Writeln ('Enter the following data:');
   Writeln ('=========================');
   Writeln;
   kl:=True;
   repeat
     Write ('Number of equations m = ');
     Readln (m);
     if m>10
       then kl:=False
   until kl;
   Writeln ('The components of vectors b[j] :');
   for j:=1 to m do
     begin
       Write ('j = ', j, '   b[', j, ',1] = ');
       Readln (b[j,1]);
       for i:=2 to m do
         begin
           Write ('        b[', j, ',', i, '] = ');
           Readln (b[j,i])
         end
     end;
   Writeln ('The numbers gamma[j] :');
   for j:=1 to m do
     begin
       Write ('gamma[', j, '] = ');
       Readln (gamma[i])
     end;
   Writeln ('The points t[i] :');
   for i:=1 to m do
     begin
       Write ('t[', i, '] = ');
       Readln (t[i])
     end;
   kl:=True;
   repeat
     Write ('Number of points at which the solution should be found n = ');
     Readln (n);
     if n>20
       then kl:=False
   until kl;
   Writeln;
   Writeln ('Calculating... Please, wait!');
   GetTime (h1, m1, s1, ms1);
   linorthogon (m, atx, ftx, b, gamma, t, n, u, st);
   GetTime (h2, m2, s2, ms2);
   comptime (h1, m1, s1, ms1, h2, m2, s2, ms2, min, sec);
   Writeln;
   Writeln ('Status = ', st);
   if st<2
     then begin
            Writeln;
            Writeln ('Solution at the points :');
            Writeln ('========================');
            Writeln;
            tau:=t[m];
            h:=(tau-t[1])/(n-1);
            for j:=n downto 1 do
              begin
                Writeln ('tau = ', tau:6:3, ' :   u[1] = ', u[1,j]);
                for i:=2 to m do
                  Writeln ('                 u[', i, '] = ', u[i,j]);
                tau:=tau-h
              end
          end;
   Write ('Time of computations: ', min, ' min ');
   if sec<10
     then Write (sec:3:1)
     else Write (sec:4:1);
   Writeln (' sec');
   if KeyPressed
     then repeat
            znak:=ReadKey
          until not KeyPressed;
   Writeln ('End of program. Press any key...');
   repeat
   until KeyPressed
 end.

                        4. CONTENTS OF THE DISKETTE
                        ßßßßßßßßßßßßßßßßßßßßßßßßßßß
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³   Directories   ³    Files     ³                Contents                   ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \INTERPOL       ³ Polynomial Interpolation                                 ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ LAGRANGE.PAS ³ Lagrange function                         ³
³                 ³ NEVILLE.PAS  ³ Neville function                          ³
³                 ³ DIVDFFNS.PAS ³ divdifferences procedure                  ³
³                 ³ NEWTVAL.PAS  ³ Newtonvalue function                      ³
³                 ³ NEWTCNS.PAS  ³ Newtoncoeffns procedure                   ³
³                 ³ HRMTVAL.PAS  ³ Hermitevalue function                     ³
³                 ³ HRMTCNS.PAS  ³ Hermitecoeffns procedure                  ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Trigonometric Interpolation                              ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ GRVAL.PAS    ³ GReinschvalue function                    ³
³                 ³ GRCNS.PAS    ³ GReinschcoeffns procedure                 ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Interpolation by Splines                                 ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ NSPLVAL.PAS  ³ naturalsplinevalue function               ³
³                 ³ NSPLCNS.PAS  ³ naturalsplinecoeffns procedure            ³
³                 ³ CSPLVAL.PAS  ³ clampedsplinevalue function               ³
³                 ³ CSPLCNS.PAS  ³ clampedsplinecoeffns procedure            ³
³                 ³ PSPLVAL.PAS  ³ periodsplinevalue function                ³
³                 ³ PSPLCNS.PAS  ³ periodsplinecoeffns procedure             ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \APPROX         ³ Least-Squares Polynomial Approximation                   ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ POLAPPR.PAS  ³ polapprox procedure                       ³
³                 ³ GRAM.PAS     ³ Gram procedure                            ³
³                 ³ LEGENDRE.PAS ³ Legendre procedure                        ³
³                 ³ TRIGAPPR.PAS ³ trigpolapprox procedure                   ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Uniform Approximation                                    ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ LOWAPPR.PAS  ³ lowdegapprox procedure                    ³
³                 ³ OPTAPPR.PAS  ³ optapprox procedure                       ³
³                 ³ RELAPPR.PAS  ³ relapprox procedure                       ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \FFT            ³ Fast Fourier Transform                                   ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ CPLXCNS.PAS  ³ complexcoeffns procedure                  ³
³                 ³ CPLXVLS.PAS  ³ complexvalues procedure                   ³
³                 ³ REALCNS.PAS  ³ realcoeffns procedure                     ³
³                 ³ REALCNS2.PAS ³ realcoeffns2 procedure                    ³
³                 ³ REALVLS.PAS  ³ realvalues procedure                      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \LINEQNS        ³ Linear Equations - Algorithms for Exact Methods          ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ UPPMTRX.PAS  ³ uppertrimatrix procedure                  ³
³                 ³ LOWMTRX.PAS  ³ lowtrimatrix procedure                    ³
³                 ³ GAUSS.PAS    ³ Gauss procedure                           ³
³                 ³ GJORDAN.PAS  ³ GaussJordan procedure                     ³
³                 ³ SYMMTRX.PAS  ³ symmatrix procedure                       ³
³                 ³ SPOSMTRX.PAS ³ symposmatrix procedure                    ³
³                 ³ TRIMTRX.PAS  ³ trimatrix procedure                       ³
³                 ³ CPLXMTRX.PAS ³ complexmatrix procedure                   ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Determinants and Inverse Matrices                        ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ DETRMTRX.PAS ³ detrealmatrix function                    ³
³                 ³ DETCMTRX.PAS ³ detcomplexmatrix procedure                ³
³                 ³ INVRMTRX.PAS ³ invrealmatrix procedure                   ³
³                 ³ INVCMTRX.PAS ³ invcomplexmatrix procedure                ³
³                 ³ INVSMTRX.PAS ³ invsymmatrix procedure                    ³
³                 ³ INVSPMTX.PAS ³ invsymposmatrix procedure                 ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Linear Equations - Iterative Algorithms                  ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ JACOBI.PAS   ³ Jacobi procedure                          ³
³                 ³ GSEIDEL.PAS  ³ GaussSeidel procedure                     ³
³                 ³ CHEBYSHV.PAS ³ Chebyshev procedure                       ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \EIGEN          ³ Eigenvalue Problems - Algorithms for Real Matrices       ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ POWER.PAS    ³ powermethod procedure                     ³
³                 ³ HESSENBG.PAS ³ Hessenberg procedure                      ³
³                 ³ GRSCHQR.PAS  ³ GramSchmidtQR procedure                   ³
³                 ³ HESSBGQR.PAS ³ HessenbergQR procedure                    ³
³                 ³ HYMAN.PAS    ³ Hyman function                            ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Eigenvalue Problems - Algorithms for Symmetric Matrices  ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ EIGENSYM.PAS ³ eigensymmatrix procedure                  ³
³                 ³ HOUSHLDR.PAS ³ Householder procedure                     ³
³                 ³ GIVENS.PAS   ³ Givens procedure                          ³
³                 ³ WIELANDT.PAS ³ Wielandt procedure                        ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \NLINEQNS       ³ Single Equation with One Variable                        ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ REGFALSI.PAS ³ regulafalsi function                      ³
³                 ³ LININTPL.PAS ³ linearintpol function                     ³
³                 ³ JARRATT.PAS  ³ Jarratt function                          ³
³                 ³ NEWTON.PAS   ³ Newton function                           ³
³                 ³ NWTRAPH.PAS  ³ NewtonRaphston function                   ³
³                 ³ BISEARCH.PAS ³ binarysearch function                     ³
³                 ³ STEFFEN.PAS  ³ Steffensen function                       ³
³                 ³ FIXPOINT.PAS ³ fixedpoint function                       ³
³                 ³ MULLER.PAS   ³ Muller procedure                          ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Polynomial Roots                                         ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ NWTROOTS.PAS ³ Newtonroots function                      ³
³                 ³ BISECTN.PAS  ³ bisection function                        ³
³                 ³ BAIRSTOW.PAS ³ Bairstow procedure                        ³
³                 ³ MROOTS.PAS   ³ Mullerroots procedure                     ³
³                 ³ LAGUERRE.PAS ³ Laguerre procedure                        ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Systems of Nonlinear Equations                           ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ NWTSYS.PAS   ³ Newtonsystem procedure                    ³
³                 ³ BROWN.PAS    ³ Brown procedure                           ³
³                 ³ NWTSMPL.PAS  ³ Newtonsimple procedure                    ³
³                 ³ BROYDEN.PAS  ³ Broyden procedure                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \INTEGR         ³ Proper Integrals                                         ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ SIMPSMPL.PAS ³ Simpsonsimple function                    ³
³                 ³ SIMPSON.PAS  ³ Simpson function                          ³
³                 ³ NWTCOTES.PAS ³ NewtonCotes function                      ³
³                 ³ NWTCTCOM.PAS ³ NewtonCotescomp function                  ³
³                 ³ ROMBERG.PAS  ³ Romberg function                          ³
³                 ³ GLEGENDR.PAS ³ GaussLegendre function                    ³
³                 ³ GJACOBI.PAS  ³ GaussJacobi function                      ³
³                 ³ GCHEBYSH.PAS ³ GaussChebyshev function                   ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Improper Integrals                                       ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ GLAGUER.PAS  ³ GaussLaguerre function                    ³
³                 ³ GHERMITE.PAS ³ GaussHermite function                     ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Multiple Integrals                                       ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ SDOUBLE.PAS  ³ Simpsondouble function                    ³
³                 ³ STRIPLE.PAS  ³ Simpsontriple function                    ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \DIFF           ³ Numerical Differentiation                                ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ LAGRDIFF.PAS ³ Lagrangediff function                     ³
³                 ³ NWTDIFF.PAS  ³ Newtondiff function                       ³
³                 ³ ROMBDIFF.PAS ³ Rombergdiff function                      ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \ODE            ³ The Initial Value Problem                                ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ EULER.PAS    ³ Euler procedure                           ³
³                 ³ SCRATON.PAS  ³ Scraton procedure                         ³
³                 ³ RK4.PAS      ³ RungeKutta4 procedure                     ³
³                 ³ ABASHF.PAS   ³ AdamsBashforth procedure                  ³
³                 ³ AMOULTON.PAS ³ AdamsMoulton procedure                    ³
³                 ³ RK4SYS.PAS   ³ RungeKutta4system procedure               ³
³                 ³ FEHLBERG.PAS ³ Fehlberg procedure                        ³
³                 ³ ABASHSYS.PAS ³ AdamsBashforthsystem procedure            ³
³                 ³ AMLTNSYS.PAS ³ AdamsMoultonsystem procedure              ³
³                 ³ RATEXTR.PAS  ³ ratextrapol procedure                     ³
³                 ³ PREDCORR.PAS ³ Adamspredcorr procedure                   ³
³                 ³ VSTEPPC.PAS  ³ Adamsvarsteppredcorr procedure            ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Boundary Value Problems                                  ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ LINORTH.PAS  ³ linorthogon procedure                     ³
³                 ³ LFINDIFF.PAS ³ linfinitediff procedure                   ³
³                 ³ SHOOTING.PAS ³ shooting procedure                        ³
³                 ³ FINDIFF.PAS  ³ finitediff procedure                      ³
³                 ³ LINRR.PAS    ³ linearRayleighRitz procedure              ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \PDE            ³ Elliptic Partial Differential Equations                  ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ DIFFMETH.PAS ³ diffmethod procedure                      ³
³                 ³ ELLDIFF2.PAS ³ ellipticdiff2 procedure                   ³
³                 ³ LAPLACE.PAS  ³ Laplace procedure                         ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Parabolic Partial Differential Equations                 ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ CRANKN.PAS   ³ CrankNicolson procedure                   ³
³                 ³ CRANKNMX.PAS ³ CrankNicolsonmixed procedure              ³
³                 ³ ALTDIR.PAS   ³ altdirection procedure                    ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ Hyperbolic Partial Differential Equations                ³
³                 ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³                 ³ HYPDIFF4.PAS ³ hyperdiff4 procedure                      ³
³                 ³ LOC1DIM.PAS  ³ loc1dim procedure                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\INTERPOL ³ T-*.PAS      ³ test programs for procedures and          ³
³                 ³              ³ functions in files of \INTERPOL directory ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\APPROX   ³ T-*.PAS      ³ test programs for procedures in files of  ³
³                 ³              ³ \APPROX directory                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\FFT      ³ T-*.PAS      ³ test programs for procedures in files of  ³
³                 ³              ³ \FFT directory                            ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\LINEQNS  ³ T-*.PAS      ³ test programs for procedures and          ³
³                 ³              ³ functions in files of \LINEQNS directory  ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\EIGEN    ³ T-*.PAS      ³ test programs for procedures and          ³
³                 ³              ³ functions in files of in \EIGEN directory ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\NLINEQNS ³ T-*.PAS      ³ test progrms for procedures and           ³
³                 ³              ³ functions in files of \NLINEQNS directory ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\INTEGR   ³ T-*.PAS      ³ test programs for functions in files of   ³
³                 ³              ³ \INTEGR directory                         ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\DIFF     ³ T-*.PAS      ³ test programs for functions in files of   ³
³                 ³              ³ \DIFF directory                           ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\ODE      ³ T-*.PAS      ³ test programs for procedures in files of  ³
³                 ³              ³ \ODE directory                            ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \TESTS\PDE      ³ T-*.PAS      ³ test programs for procedures in files of  ³
³                 ³              ³ \PDE directory                            ³
ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
³ \               ³ README.EXE   ³ this program                              ³
³                 ³ README.TXT   ³ text displied by this program             ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
