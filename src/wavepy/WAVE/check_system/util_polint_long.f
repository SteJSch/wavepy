*CMZ : 00.00/02 22/03/99  17.27.17  by  Michael Scheer
*-- Author :    Michael Scheer   15/03/99

      SUBROUTINE UTIL_POLINT_LONG(NDIM,XA,YA,N,X,Y,DY)

C POLYNOMIAL INTERPOLATION OF YA(XA) AT X. DY IS ESTIMATED ERROR OF Y(X)
C LITERATUR: NUMERICAL RECIPIES

      IMPLICIT NONE

      INTEGER N,NMAX,I,NDIM,IFAIL,IOLD,KL,KH
      PARAMETER (NMAX=10)

      REAL*8 XA(NDIM),YA(NDIM),X,Y,DY

      IFAIL=0
      IF (N.GT.NMAX) THEN
          WRITE(6,*)'*** ERROR IN UTIL_POLINT_LONG: N.GT.NMAX ***'
          STOP
      ENDIF

      IF (N.GT.NDIM) THEN
          WRITE(6,*)'*** ERROR IN UTIL_POLINT_LONG: N.GT.NDIM ***'
          STOP
      ENDIF

C LOCATE X

      CALL UTIL_LOCATE(NDIM,XA,X,IOLD,I,IFAIL)
      IF (IFAIL.NE.0) THEN
          WRITE(6,*)'*** ERROR IN UTIL_POLINT_LONG: UTIL_LOCATE FAILED ***'
          STOP
      ENDIF

      KL=I-N/2
      KH=I+(N-1)/2

      IF (KH.GT.NDIM) THEN
          KH=NDIM
          KL=NDIM-N+1
      ELSEIF (KL.LE.1) THEN
          KL=1
          KH=1+N-1
      ENDIF

      CALL UTIL_POLINT(XA(KL),YA(KL),N,X,Y,DY)

      RETURN
      END
