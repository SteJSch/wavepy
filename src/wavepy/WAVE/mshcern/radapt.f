*CMZ :          28/08/2014  13.48.08  by  Michael Scheer
*-- Author :    Michael Scheer   28/08/2014

cmsh Generated with: cpp -E -DCERNLIB_DOUBLE -DCERNLIB_UNIX radapt.F

# 1 "radapt.F"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "radapt.F"
*
* $Id: radapt.F,v 1.1.1.1 1996/04/01 15:02:13 mclareni Exp $
*
* $Log: radapt.F,v $
* Revision 1.1.1.1 1996/04/01 15:02:13 mclareni
* Mathlib gen
*
*
# 1 "/usr/include/gen/pilot.h" 1 3 4
# 10 "radapt.F" 2
      SUBROUTINE RADAPT(F,A,B,NSEG,RELTOL,ABSTOL,RES,ERR)

C RES = Estimated Integral of F from A to B,
C ERR = Estimated absolute error on RES.
C NSEG specifies how the adaptation is to be done:
C =0 means use previous binning,
C =1 means fully automatic, adapt until tolerance attained.
C =n>1 means first split interval into n equal segments,
C then adapt as necessary to attain tolerance.
C The specified tolerances are:
C relative: RELTOL ; absolute: ABSTOL.
C It stops when one OR the other is satisfied, or number of
C segments exceeds NDIM. Either TOLA or TOLR (but not both!)
C can be set to zero, in which case only the other is used.

      DOUBLE PRECISION TVALS,TERSS
      EXTERNAL F

      PARAMETER (NDIM=100)
      PARAMETER (R1 = 1, HF = R1/2)

      DIMENSION XLO(NDIM),XHI(NDIM),TVAL(NDIM),TERS(NDIM)
      SAVE XLO,XHI,TVAL,TERS,NTER
      DATA NTER /0/

      IF(NSEG .LE. 0) THEN
       IF(NTER .EQ. 0) THEN
        NSEGD=1
        GO TO 2
       ENDIF
       TVALS=0
       TERSS=0
       DO 1 I = 1,NTER
       CALL RGS56P(F,XLO(I),XHI(I),TVAL(I),TE)
       TERS(I)=TE**2
       TVALS=TVALS+TVAL(I)
       TERSS=TERSS+TERS(I)
    1 CONTINUE
       ROOT= SQRT(2*TERSS)
       GO TO 9
      ENDIF
      NSEGD=MIN(NSEG,NDIM)
    2 XHIB=A
      BIN=(B-A)/NSEGD
      DO 3 I = 1,NSEGD
      XLO(I)=XHIB
      XLOB=XLO(I)
      XHI(I)=XHIB+BIN
      IF(I .EQ. NSEGD) XHI(I)=B
      XHIB=XHI(I)
      CALL RGS56P(F,XLOB,XHIB,TVAL(I),TE)
      TERS(I)=TE**2
    3 CONTINUE
      NTER=NSEGD
      DO 4 ITER = 1,NDIM
      TVALS=TVAL(1)
      TERSS=TERS(1)
      DO 5 I = 2,NTER
      TVALS=TVALS+TVAL(I)
      TERSS=TERSS+TERS(I)
    5 CONTINUE
      ROOT= SQRT(2*TERSS)
      IF(ROOT .LE. ABSTOL .OR. ROOT .LE. RELTOL*ABS(TVALS)) GO TO 9
      IF(NTER .EQ. NDIM) GO TO 9
      BIGE=TERS(1)
      IBIG=1
      DO 6 I = 2,NTER
      IF(TERS(I) .GT. BIGE) THEN
       BIGE=TERS(I)
       IBIG=I
      ENDIF
    6 CONTINUE
      NTER=NTER+1
      XHI(NTER)=XHI(IBIG)
      XNEW=HF*(XLO(IBIG)+XHI(IBIG))
      XHI(IBIG)=XNEW
      XLO(NTER)=XNEW
      CALL RGS56P(F,XLO(IBIG),XHI(IBIG),TVAL(IBIG),TE)
      TERS(IBIG)=TE**2
      CALL RGS56P(F,XLO(NTER),XHI(NTER),TVAL(NTER),TE)
      TERS(NTER)=TE**2
    4 CONTINUE
    9 RES=TVALS
      ERR=ROOT
      RETURN
      END
