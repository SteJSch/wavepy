*CMZ : 00.00/01 20/06/95  10.09.17  by  Michael Scheer
*-- Author :    Michael Scheer   26/01/95

      SUBROUTINE UTIL_MAX_PARABEL(NDIM,X,F,XMX,FMX,WSX,WSF,JFAIL)

C--- TO FIND MAXIMUM OF ARRAY FUNCTION F(X)

C     INPUT : F(NDIM)   ARRAY OF FUNCTION
C             X(NDIM)   ARRAY OF ARGUMENTS
C             WSX(NDIM) WORKINGSPACE
C             WSF(NDIM) WORKINGSPACE

C     OUTPUT:  XMX ARGUMENT WHERE FUNCTION REACHES EXTREMUM
C              FMX MAXIMUM OF FUNCTION
C              JFAIL FLAG: =0, IF OK, =1 ELSE

      IMPLICIT NONE

      INTEGER NDIM,I,IFAIL,JFAIL
      REAL*8 X(NDIM),F(NDIM),XMX,FMX,WSX(NDIM),WSF(NDIM)
      REAL*8 XDUM(3),FDUM(3),A(3),FP(3),FMAX,XMAX

      FMAX=-1.D30
      DO I=1,NDIM
          WSX(I)=X(I)
          WSF(I)=F(I)
          IF (WSF(I).GT.FMAX) THEN
              FMAX=WSF(I)
              XMAX=WSX(I)
          ENDIF
      ENDDO

      CALL UTIL_SORT_FUNC(NDIM,WSF,WSX)

      DO I=1,3
         XDUM(I)=WSX(NDIM-I+1)
         FDUM(I)=WSF(NDIM-I+1)
      ENDDO

      CALL UTIL_PARABEL(XDUM,FDUM,A,FP,XMX,FMX,IFAIL)

      IF (IFAIL.NE.0.OR.FMX.LT.FMAX) THEN
          JFAIL=1
          WRITE(6,*)
          WRITE(6,*)'*** WARNING SR UTIL_MAX_PARABEL: SEARCH FAILED ***'
          WRITE(6,*)'*** MAXIMUM OF ARRAY TAKEN ***'
          WRITE(6,*)
          FMX=FMAX
          XMX=XMAX
          RETURN
      ENDIF

      JFAIL=0

      RETURN
      END
