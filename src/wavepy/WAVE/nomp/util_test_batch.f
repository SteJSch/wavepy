*CMZ :  2.70/12 01/03/2013  16.28.24  by  Michael Scheer
*CMZ :  2.48/00 26/01/2004  09.37.25  by  Michael Scheer
*CMZ : 00.00/00 10/01/95  15.25.51  by  Michael Scheer
*-- Author : Michael Scheer
      SUBROUTINE UTIL_TEST_BATCH(IBATCH)
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

      CHARACTER(11) TESTBATCH
      INTEGER IBATCH

      CALL UTIL_GET_MODE(TESTBATCH)

C----------- OLD -------------------------------------------
C     CHARACTER(11) TESTBATCH
C     CALL LIB$SPAWN('@UTIL:UTIL_TEST_BATCH.COM')
C     OPEN(UNIT=10,FILE='UTIL:TEST_BATCH.DAT',STATUS='OLD')
C     READ(10,'(1A11)')TESTBATCH
C----------- OLD -------------------------------------------

      IF (TESTBATCH.EQ.'BATCH') THEN
        IBATCH=1
      ELSE
        IBATCH=0
      ENDIF

      RETURN
      END
