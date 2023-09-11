*CMZ :  4.00/04 23/08/2019  16.19.15  by  Michael Scheer
*CMZ :  3.01/06 23/06/2014  10.12.46  by  Michael Scheer
*CMZ :  3.00/00 11/03/2013  15.12.11  by  Michael Scheer
*CMZ :  2.70/12 01/03/2013  16.28.24  by  Michael Scheer
*CMZ :  2.67/00 17/02/2012  10.38.44  by  Michael Scheer
*CMZ :  2.52/16 29/04/2010  11.46.31  by  Michael Scheer
*CMZ :  2.41/10 30/06/2004  16.42.15  by  Michael Scheer
*CMZ :  2.16/08 23/10/2000  17.29.35  by  Michael Scheer
*CMZ :  2.16/04 17/07/2000  15.36.32  by  Michael Scheer
*CMZ :  1.03/06 09/06/98  14.43.04  by  Michael Scheer
*CMZ :  1.00/00 24/09/97  10.31.28  by  Michael Scheer
*CMZ : 00.01/06 15/02/95  12.34.02  by  Michael Scheer
*CMZ : 00.01/04 30/01/95  10.41.22  by  Michael Scheer
*CMZ : 00.01/02 18/11/94  16.53.40  by  Michael Scheer
*CMZ : 00.00/04 29/04/94  17.52.27  by  Michael Scheer
*CMZ : 00.00/00 28/04/94  16.11.49  by  Michael Scheer
*-- Author : Michael Scheer
      SUBROUTINE HSPEC1(ID,TIT,MODE)
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

*KEEP,observf90u.
      include 'observf90u.cmn'
*KEND.

C--- STORE RESULTS OF SPECTRUM CALCULATION ON HISTOGRAM FILE

      IMPLICIT NONE

*KEEP,cmpara.
      include 'cmpara.cmn'
*KEEP,contrl.
      include 'contrl.cmn'
*KEEP,myfiles.
      include 'myfiles.cmn'
*KEEP,freqs.
      include 'freqs.cmn'
*KEEP,observf90.
      include 'observf90.cmn'
*KEEP,whbook.
      include 'whbook.cmn'
*KEEP,pawcmn.
*KEND.

      INTEGER IOBZ,IOBY,ID
      INTEGER ICYCLE,MODE

      REAL*4 ZMIN,ZMAX,YMIN,YMAX,ZFILL,YFILL

      CHARACTER(80) TIT

      data icycle/0/

      ZMIN=OBSVZ(1)-OBSVDZ/2.
      ZMAX=OBSVZ(NOBSVZ)+OBSVDZ/2.
      YMIN=OBSVY(1)-OBSVDY/2.
      YMAX=OBSVY(NOBSVY)+OBSVDY/2.

      IF (MODE.EQ.1) THEN

         call hbook1m(ID,TIT,NOBSVZ,ZMIN,ZMAX,VMX)

         DO IOBZ=1,NOBSVZ
             ZFILL=OBSVZ(IOBZ)
             CALL hfillm(ID,ZFILL,0.,FILL(IOBZ))
         ENDDO !IOBZ

      ELSE IF(MODE.EQ.2) THEN

         call hbook1m(ID,TIT,NOBSVY,YMIN,YMAX,VMX)

         DO IOBY=1,NOBSVY
             YFILL=OBSVY(IOBY)
             CALL hfillm(ID,YFILL,0.,FILL(IOBY))
         ENDDO !IOBZ

      ELSE
         WRITE(6,*) '*** ERROR IN HSPEC1: MODE WRONG ***'
         STOP
      ENDIF

      CALL MHROUT(ID,ICYCLE,' ')
c      IF (ID.NE.IDSPEC-1.AND.ID.NE.IDSPEC-2) CALL hdeletm(ID)
      CALL hdeletm(ID)

      RETURN
      END
