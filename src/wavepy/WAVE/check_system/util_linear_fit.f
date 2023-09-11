*CMZ : 00.00/20 12/10/2016  13.46.51  by  Michael Scheer
*CMZ : 00.00/02 28/07/99  17.13.31  by  Michael Scheer
*CMZ : 00.00/01 17/01/97  16.00.54  by  Michael Scheer
*-- Author :
      SUBROUTINE UTIL_LINEAR_FIT
     &  (IFAIL,NPAR,PARAM,NDIMPOI,NPOI,NARG,NFUN,A,T,FUNDATA)

c +PATCH,//UTIL/FOR
c +DECK,UTIL_LINEAR_FIT.

C     DOUBLE PRECISION SUBROUTINE FOR MULTIDIMENSIONAL LINEAR FIT

C     INPUT:
C       ------
C     NPAR:     NUMBER OF PARAMETERS TO FIT
C     NPOI:     NUMBER OF DATAPOINTS (NPOI MUST BE .LE. NDIMPOI)
C     NDIMPOI:    DIMENSION FOR NUMBER OF DATAPOINTS
C     NARG:     NUMBER OF ARGUMENTS FOR FUNCTION
C     NFUN:     DIMENSION OF FUNCTION
C     A:     WORKINGSPACE A(NPAR,NPAR)
C     T:     WORKINGSPACE T(NFUN,NPAR)
C     FUNDATA:    DATA POINTS FUNDATA(NARG+NFUN,NDIMPOI)
C            NUMBER OF DATA MUST BE AT LEAST NPAR

C     OUTPUT:
C     -------
C     PARAM:       PARAMETERS TO BE FITTED
C     IFAIL:       FAILURE FLAG, ZERO IF EVERYTHING SEEMS TO BE OK

C     EXAMPLE:
C     --------
C     NPAR=4
C     NPOI=10
C     NARG=3
C     NFUN=2
C     FUNDATA(NARG+NFUN,NPOI):
C         FUNDATA(1,I)=X(I)
C         FUNDATA(2,I)=Y(I)
C         FUNDATA(3,I)=Z(I)
C         FUNDATA(4,I)=BX(I)
C         FUNDATA(5,I)=BY(I)
C

C     FIT SUCH THAT
C
C         dCHI2/dP1=0
C         dCHI2/dP2=0
C         dCHI2/dP3=0
C         dCHI2/dP4=0
C
C     WITH
C
C         DO I=1,NPOI
C          CHI2=CHI2+
C         +((P1*X(I)*Y(I)*SIN(  K*Z(I)+)-BX(IPOI))**2
C         +((P2*X(I)*Y(I)*COS(  K*Z(I)+)-BX(IPOI))**2
C         +((P3*X(I)*Y(I)*SIN(3*K*Z(I)+)-BY(IPOI))**2
C         +((P4*X(I)*Y(I)*COS(3*K*Z(I)+)-BY(IPOI))**2
C         ENDDO   !IPOI
C
C     AND P1=PARAM(1), P2=....
C

      IMPLICIT NONE

      INTEGER IFAIL,NPAR,NDIMPOI,NPOI,NARG,NFUN
      INTEGER IPAR,IPOI,IFUN
      INTEGER JPAR,JPOI

      DOUBLE PRECISION PARAM,A,T,FUNDATA
      DIMENSION PARAM(NPAR),A(NPAR,NPAR)
     &           ,T(NFUN,NPAR),FUNDATA(NARG+NFUN,NDIMPOI)

      IF (NPOI.GT.NDIMPOI) STOP
     &'*** ERROR IN UTIL_LINEAR_FIT: DIMENSION NDIMPOI EXCEEDED ***'

      IFAIL=0

      JPOI=NPOI*NFUN

C     JPOI=0
C     DO IPOI=1,NPOI
C     DO IFUN=1,NFUN
C         IF (FUNDATA(NARG+IFUN,IPOI).NE.9999.) JPOI=JPOI+1
C     ENDDO
C     ENDDO

C ATTENTION: SINCE T IS ALSO USED AS WORKINGSPACE FOR F010
C          ITS DIMENSION MUST BE AT LEAST 2*NPAR, I.E. NPOI.GE.NPAR
      IF (JPOI.LT.NPAR) THEN
          IFAIL=9999
          RETURN
      ENDIF

      DO JPAR=1,NPAR
        PARAM(JPAR)=0.D0
        DO IPAR=1,NPAR
          A(IPAR,JPAR)=0.D0
        ENDDO
      ENDDO

C--- SET UP EQUATION SYSTEM


C -- SET UP INHOMOGENITY OF EQUATION SYSTEM

      DO IPOI=1,NPOI
C    T(IFUN,IPAR)=dChi2/dIPAR for each point and function

        CALL UTIL_LINEAR_FIT_USER(NARG,NFUN,NPAR,NDIMPOI,IPOI,FUNDATA,T)

        DO IPAR=1,NPAR
          DO IFUN=1,NFUN
            PARAM(IPAR)=PARAM(IPAR)
     &        +T(IFUN,IPAR)*FUNDATA(NARG+IFUN,IPOI)
          ENDDO
        ENDDO

      ENDDO

C -- SET UP MATRIX OF EQUATION SYSTEM

      DO IPOI=1,NPOI

        CALL UTIL_LINEAR_FIT_USER(NARG,NFUN,NPAR,NDIMPOI,IPOI,FUNDATA,T)

        DO IFUN=1,NFUN
          DO JPAR=1,NPAR
            DO IPAR=1,NPAR
              A(IPAR,JPAR)=A(IPAR,JPAR)
     &          +(T(IFUN,IPAR)*T(IFUN,JPAR))
            ENDDO
          ENDDO
        ENDDO
      ENDDO

C--- SOLVE EQUATION SYSTEM WITH CERN-ROUTINE F010

      CALL DEQN(NPAR,A,NPAR,T,IFAIL,1,PARAM)

      RETURN
      END