*CMZ :  2.15/00 28/04/2000  10.34.14  by  Michael Scheer
*CMZ :  2.12/03 23/07/99  16.22.43  by  Michael Scheer
*CMZ :  1.03/06 06/08/98  12.23.52  by  Michael Scheer
*CMZ :  1.02/03 07/01/98  13.27.05  by  Michael Scheer
*CMZ :  1.01/00 23/10/97  18.55.22  by  Michael Scheer
*CMZ :  1.00/00 05/08/97  15.15.52  by  Michael Scheer
*CMZ : 00.02/02 14/01/97  11.44.42  by  Michael Scheer
*CMZ : 00.01/09 26/07/95  12.17.53  by  Michael Scheer
*CMZ : 00.01/08 29/06/95  11.45.06  by  Michael Scheer
*CMZ : 00.01/05 01/02/95  10.23.00  by  Michael Scheer
*CMZ : 00.01/04 08/12/94  10.42.32  by  Michael Scheer
*CMZ : 00.01/02 22/11/94  11.09.55  by  Michael Scheer
*CMZ : 00.01/01 28/10/94  12.18.20  by  Michael Scheer
*CMZ : 00.00/07 26/05/94  11.17.12  by  Michael Scheer
*CMZ : 00.00/02 28/04/94  17.57.07  by  Michael Scheer
*-- Author :
      PROGRAM WAVE_LOOP

      IMPLICIT NONE

      CHARACTER*60 RFILE,VFILE,UFILE

      INTEGER LUNRES,LUNVAR,LUNU,IVAR,ITRY

      INTEGER ILOOP,JLOOP,NLOOP(2),ICODE

      DOUBLE PRECISION VAR(2),VARMIN(2),VARMAX(2),DVAR(2)

      INTEGER LIDIMP,NFREQP,IFREQ,I
      PARAMETER(LIDIMP=5,NFREQP=3)

      REAL*4 PINCENZ,FREQ(NFREQP),WFLUX(LIDIMP,NFREQP),WFLUXT(NFREQP)
     &        ,SPECCEN(LIDIMP,NFREQP),SPECCENT(NFREQP)

      DATA LUNU/19/
      DATA UFILE/'UOUT.LOOP'/ !DUMMY TO PASS VARIABLES TO WAVE_LOOP

      DATA LUNVAR/20/
      DATA VFILE/'UNAME.LOOP'/ !DUMMY TO PASS VARIABLES TO WAVE

      DATA LUNRES/21/
      DATA RFILE/'WAVE.LOOP'/    !FILE OF RESULTS

      READ(5,*)NLOOP(1),VARMIN(1),VARMAX(1)
      READ(5,*)NLOOP(2),VARMIN(2),VARMAX(2)

      OPEN(UNIT=LUNVAR,FILE=VFILE,STATUS='NEW',FORM='FORMATTED')
      CLOSE(LUNVAR)

      OPEN(UNIT=LUNVAR,FILE='TERM.LOOP',STATUS='NEW',FORM='FORMATTED')
      CLOSE(LUNVAR)

      OPEN(UNIT=LUNRES,FILE=RFILE,STATUS='NEW',FORM='FORMATTED',
     &     RECL=256)
      CLOSE(LUNRES)

      DO IVAR=1,2
        IF (NLOOP(IVAR).GT.1) THEN
             DVAR(IVAR)=(VARMAX(IVAR)-VARMIN(IVAR))/(NLOOP(IVAR)-1)
        ELSE
          DVAR(IVAR)=0.0
        ENDIF
      ENDDO !ILOOP

      DO ILOOP=1,NLOOP(1)

      VAR(1)=(VARMIN(1)+DVAR(1)*(ILOOP-1))

      DO JLOOP=1,NLOOP(2)

          VAR(2)=(VARMIN(2)+DVAR(2)*(JLOOP-1))

          OPEN(UNIT=LUNVAR,FILE=VFILE,STATUS='OLD',FORM='FORMATTED')
         WRITE(LUNVAR,*)VAR
          CLOSE(LUNVAR)

          CALL LIB$SPAWN('$PURGE/KEEP=3 WAVE.OUT,WH:WAVE_HISTO.HIS')
          CALL LIB$SPAWN('$RUN/NODEBUG WE:WAVE')

          OPEN(UNIT=LUNU,FILE='TERM.LOOP',STATUS='OLD',ERR=9999)
          CLOSE(LUNU)

          OPEN(UNIT=LUNU,FILE=UFILE,STATUS='OLD')
         READ(LUNU,*)ICODE,PINCENZ
         DO IFREQ=1,NFREQP
            READ(LUNU,*)FREQ(IFREQ)
            READ(LUNU,*)(WFLUX(I,IFREQ),I=1,5),WFLUXT(IFREQ)
            READ(LUNU,*)(SPECCEN(I,IFREQ),I=1,5),SPECCENT(IFREQ)
         ENDDO !IFREQ
99           CLOSE (LUNU)

        ITRY=0
999     CALL LIB$SPAWN('$WAIT 00:00:05')
        ITRY=ITRY+1
        IF (ITRY.GT.100) GOTO 9999

          OPEN(UNIT=LUNRES,FILE=RFILE,STATUS='OLD',ACCESS='APPEND'
     &   ,FORM='FORMATTED',RECL=256,ERR=999)
         DO IFREQ=1,NFREQP
            WRITE(LUNRES,*)ICODE,PINCENZ !FOR NTUPLE
            WRITE(LUNRES,*)FREQ(IFREQ)
            WRITE(LUNRES,*)(WFLUX(I,IFREQ),I=1,5),WFLUXT(IFREQ)
            WRITE(LUNRES,*)(SPECCEN(I,IFREQ),I=1,5),SPECCENT(IFREQ)
         ENDDO !IFREQ
          CLOSE(LUNRES)

          WRITE(6,*)
          WRITE(6,*) 'NUMBER OF LOOPS DONE:',ILOOP,JLOOP
          WRITE(6,*)ICODE,VAR
          WRITE(6,*)

      ENDDO !JLOOP
      ENDDO !ILOOP

      WRITE(6,*)
      WRITE(6,*)'--- Program WAVE_LOOP terminated ---'
      WRITE(6,*)

      STOP ' '

9999  STOP '--- Program WAVE_LOOP aborted ---'

      END