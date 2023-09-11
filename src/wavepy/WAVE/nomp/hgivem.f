*CMZ :  4.00/14 31/12/2021  11.06.17  by  Michael Scheer
*CMZ :  3.02/04 12/12/2014  15.08.21  by  Michael Scheer
*CMZ :  3.02/03 10/11/2014  16.17.19  by  Michael Scheer
*CMZ :  3.02/00 01/09/2014  11.11.30  by  Michael Scheer
*CMZ :  3.01/06 23/06/2014  16.20.53  by  Michael Scheer
*CMZ :  3.01/05 13/06/2014  09.09.29  by  Michael Scheer
*CMZ :  0.01/03 09/06/2014  16.23.45  by  Michael Scheer
*CMZ :  0.01/02 06/06/2014  15.14.16  by  Michael Scheer
*CMZ :  0.01/01 02/06/2014  09.51.44  by  Michael Scheer
*CMZ :  0.01/00 29/04/2014  12.04.58  by  Michael Scheer
*CMZ :  0.00/02 29/04/2014  09.07.49  by  Michael Scheer
*CMZ :  0.00/01 28/04/2014  20.49.27  by  Michael Scheer
*-- Author :    Michael Scheer   26/04/2014
      subroutine hgivem(id,title,nchax,xmin,xmax,nchay,ymin,ymax,nwt,loc)
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

      implicit none

      integer*8 nchax8,nwt8,loc8,nchay8
      double precision xmin8,xmax8,ymin8,ymax8
      integer nchax,nchay,nwt,loc
      integer id
      real*4 x,y,xmin,xmax,ymin,ymax
      character(*) title

      call mh_give(id,title,nchax,xmin8,xmax8,nchay,ymin8,ymax8,nwt,loc)
      xmin=sngl(xmin8)
      xmax=sngl(xmax8)
      ymin=sngl(ymin8)
      ymax=sngl(ymax8)
      return
      end
