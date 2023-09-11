*CMZ :          26/02/2021  11.28.58  by  Michael Scheer
*CMZ : 00.00/07 17/06/2008  09.40.43  by  Michael Scheer
*CMZ : 00.00/02 28/07/99  17.13.31  by  Michael Scheer
*CMZ : 00.00/01 17/01/97  16.00.54  by  Michael Scheer
*-- Author : Michael Scheer
      SUBROUTINE UTIL_LINEAR_FIT_DATA_GAUSS
     &  (IFAIL,NPARP,NPAR,PARAM,NDIMPOI,NPOI,DATAPOINTS,NFUN,FITFUN,A,T)

C     DOUBLE PRECISION SUBROUTINE FOR MULTIDIMENSIONAL LINEAR FIT

C     INPUT:
C       ------
C     NPAR:     NUMBER OF PARAMETERS TO FIT
C     NPOI:     NUMBER OF DATAPOINTS (NPOI MUST BE .LE. NDIMPOI)
C     NFUN:     DIMENSION OF FUNCTION
C     NDIMPOI:    DIMENSION FOR NUMBER OF DATAPOINTS
C     A:     WORKINGSPACE A(NPAR,NPAR)
C     DATAPOINTS: DATA(NDIMPOI,NPAR)
C            NUMBER OF DATA MUST BE AT LEAST NPAR
C     FITFUN:     VALUES OF FUNCTIONS TO FIT, FITFUN(NPOI,NPAR,NFUN)
C                   NUMBER OF DATA MUST BE AT LEAST NPAR

C     OUTPUT:
C     -------
C     PARAM:       PARAMETERS TO BE FITTED
C     IFAIL:       FAILURE FLAG, ZERO IF EVERYTHING SEEMS TO BE OK

c FOR AN EXAMPLE SEE util_linear_fit_data_main

      IMPLICIT NONE

      INTEGER IFAIL,NPAR,NDIMPOI,NPOI,NPARP
      INTEGER IPAR,IPOI
      INTEGER JPAR,IFUN,NFUN

      DOUBLE PRECISION PARAM,A,T,FITFUN,DATAPOINTS
      DIMENSION PARAM(NPAR),A(NPAR,NPAR),T(NFUN,NPAR)
     &  ,DATAPOINTS(NDIMPOI,NFUN),FITFUN(NDIMPOI,NPARP,NFUN)

      IF (NPOI.GT.NDIMPOI) STOP
     &  '*** ERROR IN UTIL_LINEAR_FIT: DIMENSION NDIMPOI EXCEEDED ***'

      IFAIL=0

      IF (NPOI*NFUN.LT.NPAR) THEN
        IFAIL=-9999
        RETURN
      ENDIF

      PARAM=0.0D0
      A=0.0D0

C--- SET UP EQUATION SYSTEM


C -- SET UP INHOMOGENITY OF EQUATION SYSTEM

      DO IPAR=1,NPAR
        DO IFUN=1,NFUN
          DO IPOI=1,NPOI
            PARAM(IPAR)=PARAM(IPAR)
     &        +DATAPOINTS(IPOI,IFUN)*FITFUN(IPOI,IPAR,IFUN)
          ENDDO
        ENDDO
      ENDDO

C -- SET UP MATRIX OF EQUATION SYSTEM

      DO JPAR=1,NPAR
        DO IPAR=1,NPAR
          DO IFUN=1,NFUN
            DO IPOI=1,NPOI
              A(IPAR,JPAR)=A(IPAR,JPAR)
     &          +FITFUN(IPOI,IPAR,IFUN)*FITFUN(IPOI,JPAR,IFUN)
            ENDDO
          ENDDO
        ENDDO
      ENDDO

C--- SOLVE EQUATION SYSTEM WITH CERN-ROUTINE F010

C      CALL DEQN(NPAR,A,NPAR,T,IFAIL,1,PARAM)

      call util_lineqnsys_gauss(a,npar,param,t,ifail)

      RETURN
      END
