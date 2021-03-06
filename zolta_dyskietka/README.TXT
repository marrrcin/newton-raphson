                                 ����������Ŀ
                                 � Contents �
                                 ������������
            1. Introduction ������������������������������������
            2. How the Procedures Are Store and How to Call Them
            3. Exemplary User's Program ������������������������
            4. Contents of the Diskette ������������������������


                               1. INTRODUCTION
                               ���������������

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
           ����������������������������������������������������

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
                        ���������������������������

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
                        ���������������������������
����������������������������������������������������������������������������Ŀ
�   Directories   �    Files     �                Contents                   �
����������������������������������������������������������������������������Ĵ
� \INTERPOL       � Polynomial Interpolation                                 �
�                 ����������������������������������������������������������Ĵ
�                 � LAGRANGE.PAS � Lagrange function                         �
�                 � NEVILLE.PAS  � Neville function                          �
�                 � DIVDFFNS.PAS � divdifferences procedure                  �
�                 � NEWTVAL.PAS  � Newtonvalue function                      �
�                 � NEWTCNS.PAS  � Newtoncoeffns procedure                   �
�                 � HRMTVAL.PAS  � Hermitevalue function                     �
�                 � HRMTCNS.PAS  � Hermitecoeffns procedure                  �
�                 ����������������������������������������������������������Ĵ
�                 � Trigonometric Interpolation                              �
�                 ����������������������������������������������������������Ĵ
�                 � GRVAL.PAS    � GReinschvalue function                    �
�                 � GRCNS.PAS    � GReinschcoeffns procedure                 �
�                 ����������������������������������������������������������Ĵ
�                 � Interpolation by Splines                                 �
�                 ����������������������������������������������������������Ĵ
�                 � NSPLVAL.PAS  � naturalsplinevalue function               �
�                 � NSPLCNS.PAS  � naturalsplinecoeffns procedure            �
�                 � CSPLVAL.PAS  � clampedsplinevalue function               �
�                 � CSPLCNS.PAS  � clampedsplinecoeffns procedure            �
�                 � PSPLVAL.PAS  � periodsplinevalue function                �
�                 � PSPLCNS.PAS  � periodsplinecoeffns procedure             �
����������������������������������������������������������������������������Ĵ
� \APPROX         � Least-Squares Polynomial Approximation                   �
�                 ����������������������������������������������������������Ĵ
�                 � POLAPPR.PAS  � polapprox procedure                       �
�                 � GRAM.PAS     � Gram procedure                            �
�                 � LEGENDRE.PAS � Legendre procedure                        �
�                 � TRIGAPPR.PAS � trigpolapprox procedure                   �
�                 ����������������������������������������������������������Ĵ
�                 � Uniform Approximation                                    �
�                 ����������������������������������������������������������Ĵ
�                 � LOWAPPR.PAS  � lowdegapprox procedure                    �
�                 � OPTAPPR.PAS  � optapprox procedure                       �
�                 � RELAPPR.PAS  � relapprox procedure                       �
����������������������������������������������������������������������������Ĵ
� \FFT            � Fast Fourier Transform                                   �
�                 ����������������������������������������������������������Ĵ
�                 � CPLXCNS.PAS  � complexcoeffns procedure                  �
�                 � CPLXVLS.PAS  � complexvalues procedure                   �
�                 � REALCNS.PAS  � realcoeffns procedure                     �
�                 � REALCNS2.PAS � realcoeffns2 procedure                    �
�                 � REALVLS.PAS  � realvalues procedure                      �
����������������������������������������������������������������������������Ĵ
� \LINEQNS        � Linear Equations - Algorithms for Exact Methods          �
�                 ����������������������������������������������������������Ĵ
�                 � UPPMTRX.PAS  � uppertrimatrix procedure                  �
�                 � LOWMTRX.PAS  � lowtrimatrix procedure                    �
�                 � GAUSS.PAS    � Gauss procedure                           �
�                 � GJORDAN.PAS  � GaussJordan procedure                     �
�                 � SYMMTRX.PAS  � symmatrix procedure                       �
�                 � SPOSMTRX.PAS � symposmatrix procedure                    �
�                 � TRIMTRX.PAS  � trimatrix procedure                       �
�                 � CPLXMTRX.PAS � complexmatrix procedure                   �
�                 ����������������������������������������������������������Ĵ
�                 � Determinants and Inverse Matrices                        �
�                 ����������������������������������������������������������Ĵ
�                 � DETRMTRX.PAS � detrealmatrix function                    �
�                 � DETCMTRX.PAS � detcomplexmatrix procedure                �
�                 � INVRMTRX.PAS � invrealmatrix procedure                   �
�                 � INVCMTRX.PAS � invcomplexmatrix procedure                �
�                 � INVSMTRX.PAS � invsymmatrix procedure                    �
�                 � INVSPMTX.PAS � invsymposmatrix procedure                 �
�                 ����������������������������������������������������������Ĵ
�                 � Linear Equations - Iterative Algorithms                  �
�                 ����������������������������������������������������������Ĵ
�                 � JACOBI.PAS   � Jacobi procedure                          �
�                 � GSEIDEL.PAS  � GaussSeidel procedure                     �
�                 � CHEBYSHV.PAS � Chebyshev procedure                       �
����������������������������������������������������������������������������Ĵ
� \EIGEN          � Eigenvalue Problems - Algorithms for Real Matrices       �
�                 ����������������������������������������������������������Ĵ
�                 � POWER.PAS    � powermethod procedure                     �
�                 � HESSENBG.PAS � Hessenberg procedure                      �
�                 � GRSCHQR.PAS  � GramSchmidtQR procedure                   �
�                 � HESSBGQR.PAS � HessenbergQR procedure                    �
�                 � HYMAN.PAS    � Hyman function                            �
�                 ����������������������������������������������������������Ĵ
�                 � Eigenvalue Problems - Algorithms for Symmetric Matrices  �
�                 ����������������������������������������������������������Ĵ
�                 � EIGENSYM.PAS � eigensymmatrix procedure                  �
�                 � HOUSHLDR.PAS � Householder procedure                     �
�                 � GIVENS.PAS   � Givens procedure                          �
�                 � WIELANDT.PAS � Wielandt procedure                        �
����������������������������������������������������������������������������Ĵ
� \NLINEQNS       � Single Equation with One Variable                        �
�                 ����������������������������������������������������������Ĵ
�                 � REGFALSI.PAS � regulafalsi function                      �
�                 � LININTPL.PAS � linearintpol function                     �
�                 � JARRATT.PAS  � Jarratt function                          �
�                 � NEWTON.PAS   � Newton function                           �
�                 � NWTRAPH.PAS  � NewtonRaphston function                   �
�                 � BISEARCH.PAS � binarysearch function                     �
�                 � STEFFEN.PAS  � Steffensen function                       �
�                 � FIXPOINT.PAS � fixedpoint function                       �
�                 � MULLER.PAS   � Muller procedure                          �
�                 ����������������������������������������������������������Ĵ
�                 � Polynomial Roots                                         �
�                 ����������������������������������������������������������Ĵ
�                 � NWTROOTS.PAS � Newtonroots function                      �
�                 � BISECTN.PAS  � bisection function                        �
�                 � BAIRSTOW.PAS � Bairstow procedure                        �
�                 � MROOTS.PAS   � Mullerroots procedure                     �
�                 � LAGUERRE.PAS � Laguerre procedure                        �
�                 ����������������������������������������������������������Ĵ
�                 � Systems of Nonlinear Equations                           �
�                 ����������������������������������������������������������Ĵ
�                 � NWTSYS.PAS   � Newtonsystem procedure                    �
�                 � BROWN.PAS    � Brown procedure                           �
�                 � NWTSMPL.PAS  � Newtonsimple procedure                    �
�                 � BROYDEN.PAS  � Broyden procedure                         �
����������������������������������������������������������������������������Ĵ
� \INTEGR         � Proper Integrals                                         �
�                 ����������������������������������������������������������Ĵ
�                 � SIMPSMPL.PAS � Simpsonsimple function                    �
�                 � SIMPSON.PAS  � Simpson function                          �
�                 � NWTCOTES.PAS � NewtonCotes function                      �
�                 � NWTCTCOM.PAS � NewtonCotescomp function                  �
�                 � ROMBERG.PAS  � Romberg function                          �
�                 � GLEGENDR.PAS � GaussLegendre function                    �
�                 � GJACOBI.PAS  � GaussJacobi function                      �
�                 � GCHEBYSH.PAS � GaussChebyshev function                   �
�                 ����������������������������������������������������������Ĵ
�                 � Improper Integrals                                       �
�                 ����������������������������������������������������������Ĵ
�                 � GLAGUER.PAS  � GaussLaguerre function                    �
�                 � GHERMITE.PAS � GaussHermite function                     �
�                 ����������������������������������������������������������Ĵ
�                 � Multiple Integrals                                       �
�                 ����������������������������������������������������������Ĵ
�                 � SDOUBLE.PAS  � Simpsondouble function                    �
�                 � STRIPLE.PAS  � Simpsontriple function                    �
����������������������������������������������������������������������������Ĵ
� \DIFF           � Numerical Differentiation                                �
�                 ����������������������������������������������������������Ĵ
�                 � LAGRDIFF.PAS � Lagrangediff function                     �
�                 � NWTDIFF.PAS  � Newtondiff function                       �
�                 � ROMBDIFF.PAS � Rombergdiff function                      �
����������������������������������������������������������������������������Ĵ
� \ODE            � The Initial Value Problem                                �
�                 ����������������������������������������������������������Ĵ
�                 � EULER.PAS    � Euler procedure                           �
�                 � SCRATON.PAS  � Scraton procedure                         �
�                 � RK4.PAS      � RungeKutta4 procedure                     �
�                 � ABASHF.PAS   � AdamsBashforth procedure                  �
�                 � AMOULTON.PAS � AdamsMoulton procedure                    �
�                 � RK4SYS.PAS   � RungeKutta4system procedure               �
�                 � FEHLBERG.PAS � Fehlberg procedure                        �
�                 � ABASHSYS.PAS � AdamsBashforthsystem procedure            �
�                 � AMLTNSYS.PAS � AdamsMoultonsystem procedure              �
�                 � RATEXTR.PAS  � ratextrapol procedure                     �
�                 � PREDCORR.PAS � Adamspredcorr procedure                   �
�                 � VSTEPPC.PAS  � Adamsvarsteppredcorr procedure            �
�                 ����������������������������������������������������������Ĵ
�                 � Boundary Value Problems                                  �
�                 ����������������������������������������������������������Ĵ
�                 � LINORTH.PAS  � linorthogon procedure                     �
�                 � LFINDIFF.PAS � linfinitediff procedure                   �
�                 � SHOOTING.PAS � shooting procedure                        �
�                 � FINDIFF.PAS  � finitediff procedure                      �
�                 � LINRR.PAS    � linearRayleighRitz procedure              �
����������������������������������������������������������������������������Ĵ
� \PDE            � Elliptic Partial Differential Equations                  �
�                 ����������������������������������������������������������Ĵ
�                 � DIFFMETH.PAS � diffmethod procedure                      �
�                 � ELLDIFF2.PAS � ellipticdiff2 procedure                   �
�                 � LAPLACE.PAS  � Laplace procedure                         �
�                 ����������������������������������������������������������Ĵ
�                 � Parabolic Partial Differential Equations                 �
�                 ����������������������������������������������������������Ĵ
�                 � CRANKN.PAS   � CrankNicolson procedure                   �
�                 � CRANKNMX.PAS � CrankNicolsonmixed procedure              �
�                 � ALTDIR.PAS   � altdirection procedure                    �
�                 ����������������������������������������������������������Ĵ
�                 � Hyperbolic Partial Differential Equations                �
�                 ����������������������������������������������������������Ĵ
�                 � HYPDIFF4.PAS � hyperdiff4 procedure                      �
�                 � LOC1DIM.PAS  � loc1dim procedure                         �
����������������������������������������������������������������������������Ĵ
� \TESTS\INTERPOL � T-*.PAS      � test programs for procedures and          �
�                 �              � functions in files of \INTERPOL directory �
����������������������������������������������������������������������������Ĵ
� \TESTS\APPROX   � T-*.PAS      � test programs for procedures in files of  �
�                 �              � \APPROX directory                         �
����������������������������������������������������������������������������Ĵ
� \TESTS\FFT      � T-*.PAS      � test programs for procedures in files of  �
�                 �              � \FFT directory                            �
����������������������������������������������������������������������������Ĵ
� \TESTS\LINEQNS  � T-*.PAS      � test programs for procedures and          �
�                 �              � functions in files of \LINEQNS directory  �
����������������������������������������������������������������������������Ĵ
� \TESTS\EIGEN    � T-*.PAS      � test programs for procedures and          �
�                 �              � functions in files of in \EIGEN directory �
����������������������������������������������������������������������������Ĵ
� \TESTS\NLINEQNS � T-*.PAS      � test progrms for procedures and           �
�                 �              � functions in files of \NLINEQNS directory �
����������������������������������������������������������������������������Ĵ
� \TESTS\INTEGR   � T-*.PAS      � test programs for functions in files of   �
�                 �              � \INTEGR directory                         �
����������������������������������������������������������������������������Ĵ
� \TESTS\DIFF     � T-*.PAS      � test programs for functions in files of   �
�                 �              � \DIFF directory                           �
����������������������������������������������������������������������������Ĵ
� \TESTS\ODE      � T-*.PAS      � test programs for procedures in files of  �
�                 �              � \ODE directory                            �
����������������������������������������������������������������������������Ĵ
� \TESTS\PDE      � T-*.PAS      � test programs for procedures in files of  �
�                 �              � \PDE directory                            �
����������������������������������������������������������������������������Ĵ
� \               � README.EXE   � this program                              �
�                 � README.TXT   � text displied by this program             �
������������������������������������������������������������������������������
