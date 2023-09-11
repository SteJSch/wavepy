*CMZ : 00.00/01 05/06/96  16.08.05  by  Michael Scheer
*-- Author :    Michael Scheer   03/06/96

      SUBROUTINE UTIL_DETERMINANTE(NDIM,A,DET,IFAIL)

C CALCULATES DETERMINANT OF MATRIX A

      IMPLICIT NONE

      INTEGER IFAIL,NDIM,NWORKP,JFAIL,I,J

      PARAMETER (NWORKP=128)

      REAL*8 STORE(NWORKP,NWORKP)
      REAL*8 A(NDIM,NDIM),DET
      INTEGER IWS(2*NWORKP)


      IFAIL=0
      DET=0.D0

      IF (NDIM.GT.NWORKP) THEN
          WRITE(6,*)'*** ERROR: DIMENSION EXCEEDED IN UTIL_DETER ***'
          IFAIL=99
          RETURN
      ENDIF

      DO I=1,NDIM
      DO J=1,NDIM
          STORE(J,I)=A(J,I)
      ENDDO
      ENDDO

      CALL DFACT(NDIM,A,NDIM,IWS,IFAIL,DET,JFAIL)

      IF (JFAIL.NE.0.OR.IFAIL.NE.0) IFAIL=10*JFAIL+IFAIL

      DO I=1,NDIM
      DO J=1,NDIM
          A(J,I)=STORE(J,I)
      ENDDO
      ENDDO

      RETURN
      END