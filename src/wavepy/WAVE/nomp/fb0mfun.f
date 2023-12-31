*CMZ :  2.70/12 01/03/2013  16.28.23  by  Michael Scheer
*CMZ :  2.15/00 28/04/2000  10.32.34  by  Michael Scheer
*CMZ : 00.01/02 18/11/94  16.33.53  by  Michael Scheer
*CMZ : 00.00/04 29/04/94  17.50.38  by  Michael Scheer
*CMZ : 00.00/00 28/04/94  16.13.22  by  Michael Scheer
*-- Author : Michael Scheer
C******************************************************************
      DOUBLE PRECISION FUNCTION FB0MFUN(FASYM)
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

C--- FUER EIN GEGEBENES FASYM WIRD FB0M SO BERECHNET, DASS DIE DIPOL-
C    FOLGE UND DER ASYMMETRISCHE HALBACHTYP DIE GLEICHE EMITTANZ HABEN
C     EMPIRISCHER FIT

      IMPLICIT NONE
      DOUBLE PRECISION FASYM
CC      DOUBLE PRECISION FASYM,P1,P2,P3

CC      DATA P1,P2,P3/0.8400358,-0.0316626,1.224754/ !FIT VOM 080891 (CA.)

CC    FB0MFUN=1./(FASYM-P1)+P2*FASYM+P3 !FIT, S.OUTPUT VOM 13.08.91 (2852FF.)

      CALL FB0MSPLINE(FASYM,FB0MFUN)

      RETURN
      END
