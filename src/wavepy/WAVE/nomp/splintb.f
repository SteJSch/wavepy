*CMZ :  4.00/11 17/05/2021  11.31.37  by  Michael Scheer
*CMZ :  4.00/07 10/07/2020  08.29.01  by  Michael Scheer
*CMZ :  2.70/12 01/03/2013  16.28.24  by  Michael Scheer
*CMZ :  2.66/19 07/06/2011  14.08.31  by  Michael Scheer
*CMZ :  2.41/13 22/08/2002  17.16.36  by  Michael Scheer
*CMZ :  2.15/00 28/04/2000  10.32.36  by  Michael Scheer
*CMZ :  2.13/10 25/03/2000  14.36.03  by  Michael Scheer
*CMZ :  2.11/00 11/05/99  18.02.35  by  Michael Scheer
*CMZ :  1.03/06 09/06/98  15.14.32  by  Michael Scheer
*CMZ : 00.01/02 18/11/94  18.40.22  by  Michael Scheer
*CMZ : 00.00/00 28/04/94  16.12.36  by  Michael Scheer
*-- Author : Michael Scheer
C************************************************************************
      SUBROUTINE SPLINTB(N,X,Y)
*KEEP,gplhint.
!******************************************************************************
!
!      Copyright 2013 Helmholtz-Zentrum Berlin (HZB)
!      Hahn-Meitner-Platz 1
!      D-14109 Berlin
!      Germany
!
!      Author Michael Scheer, Michael.Scheer@Helmholtz-Berlin.de
!
! -----------------------------------------------------------------------
!
!    This program is free software: you can redistribute it and/or modify
!    it under the terms of the GNU General Public License as published by
!    the Free Software Foundation, either version 3 of the License, or
!    (at your option) any later version.
!
!    This program is distributed in the hope that it will be useful,
!    but WITHOUT ANY WARRANTY; without even the implied warranty of
!    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!    GNU General Public License for more details.
!
!    You should have received a copy (wave_gpl.txt) of the GNU General Public
!    License along with this program.
!    If not, see <http://www.gnu.org/licenses/>.
!
!    Dieses Programm ist Freie Software: Sie koennen es unter den Bedingungen
!    der GNU General Public License, wie von der Free Software Foundation,
!    Version 3 der Lizenz oder (nach Ihrer Option) jeder spaeteren
!    veroeffentlichten Version, weiterverbreiten und/oder modifizieren.
!
!    Dieses Programm wird in der Hoffnung, dass es nuetzlich sein wird, aber
!    OHNE JEDE GEWAEHRLEISTUNG, bereitgestellt; sogar ohne die implizite
!    Gewaehrleistung der MARKTFAEHIGKEIT oder EIGNUNG FueR EINEN BESTIMMTEN ZWECK.
!    Siehe die GNU General Public License fuer weitere Details.
!
!    Sie sollten eine Kopie (wave_gpl.txt) der GNU General Public License
!    zusammen mit diesem Programm erhalten haben. Wenn nicht,
!    siehe <http://www.gnu.org/licenses/>.
!
!******************************************************************************
*KEND.

      IMPLICIT NONE
      INTEGER N,KLO,KHI,K,KD
      DOUBLE PRECISION Y,X,H,A,B

*KEEP,cmpara.
      include 'cmpara.cmn'
*KEND.
      DOUBLE PRECISION XA(NBTABP),YA(NBTABP),Y2A(NBTABP)
      COMMON/BTABC/XA,YA,Y2A

      DATA KLO/1/

      IF(     XA(1).LT.XA(N).AND.(X.LT.XA(1).OR.X.GT.XA(N))
     &  .OR.
     &  XA(N).LT.XA(1).AND.(X.LT.XA(N).OR.X.GT.XA(1)))
     &  STOP '***SR SPLINTB: X OUT OF RANGE ***'


      IF (X.GE.XA(KLO)) THEN

C HUNT UP
        KD=1
11      KHI=MIN(KLO+KD,N)
        IF (X.GT.XA(KHI)) THEN
          KD=2*KD
          KLO=KHI
          GOTO 11
        ENDIF

      ELSE    !(X.GE.XA(KLO))

C HUNT DOWN
        KD=1
        KHI=KLO
22      KLO=MAX(KHI-KD,1)
        IF (X.LT.XA(KLO)) THEN
          KD=2*KD
          KHI=KLO
          GOTO 22
        ENDIF

      ENDIF

1     IF (KHI-KLO.GT.1) THEN
        K=(KHI+KLO)/2
        IF(XA(K).GT.X)THEN
          KHI=K
        ELSE
          KLO=K
        ENDIF
        GOTO 1
      ENDIF

      H=XA(KHI)-XA(KLO)

      IF (H.LE.0.) THEN
        WRITE(6,*) 'Bad XA input.'
        STOP
      ENDIF

      A=(XA(KHI)-X)/H
      B=(X-XA(KLO))/H
      Y=A*YA(KLO)+B*YA(KHI)+
     &  (A*(A*A-1.0d0)*Y2A(KLO)+B*(B*b-1.0d0)*Y2A(KHI))*(H**2)/6.

      RETURN
      END