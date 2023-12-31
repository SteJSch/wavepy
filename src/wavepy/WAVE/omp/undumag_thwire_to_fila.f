*CMZ :  2.00/01 16/04/2018  14.03.16  by  Michael Scheer
*CMZ :  1.25/03 23/03/2018  17.08.17  by  Michael Scheer
*CMZ :  1.25/02 22/03/2018  14.48.44  by  Michael Scheer
*CMZ :  1.25/01 16/03/2018  16.51.35  by  Michael Scheer
*CMZ :  1.25/00 15/03/2018  21.53.23  by  Michael Scheer
*-- Author :    Michael Scheer   08/03/2018
      subroutine undumag_thwire_to_fila(k)

      use undumagf90m

      implicit none

*KEEP,phycon.
      include 'phycon.cmn'
*KEND.

      double precision w,h,xc,yc,zc,xx,yy,zz,rmat(3,3),x0,y0,z0,dphi,dr,dl,
     &  curr,cw,phi,r

      integer k,iw,nr,nphi,kolor,ir,iphi

      iw=ncwires

      curr=thickwire(1,k)

      x0=thickwire(2,k)
      y0=thickwire(3,k)
      z0=thickwire(4,k)

      dl=thickwire(5,k)
      r=thickwire(6,k)
      nr=thickwire(7,k)
      nphi=thickwire(8,k)
      kolor=thickwire(9,k)

      rmat(1,1:3)=thickwire(10:12,k)
      rmat(2,1:3)=thickwire(13:15,k)
      rmat(3,1:3)=thickwire(16:18,k)

      dphi=twopi1/nphi
      dr=r/nr

      cw=curr/(nphi*nr)

      xx=dl/2.0d0
      do ir=1,nr
        r=(ir-0.5d0)*dr
        phi=-dphi
        do iphi=1,nphi
          iw=iw+1
          phi=phi+dphi
          yy=r*sin(phi)
          zz=r*cos(phi)
          wire(1,iw)=7 ! type thick wire
          wire(2,iw)=cw
          wire(3,iw)=-rmat(1,1)*xx+rmat(1,2)*yy+rmat(1,3)*zz+x0
          wire(4,iw)=-rmat(2,1)*xx+rmat(2,2)*yy+rmat(2,3)*zz+y0
          wire(5,iw)=-rmat(3,1)*xx+rmat(3,2)*yy+rmat(3,3)*zz+z0
          wire(6,iw)= rmat(1,1)*xx+rmat(1,2)*yy+rmat(1,3)*zz+x0
          wire(7,iw)= rmat(2,1)*xx+rmat(2,2)*yy+rmat(2,3)*zz+y0
          wire(8,iw)= rmat(3,1)*xx+rmat(3,2)*yy+rmat(3,3)*zz+z0
          wire(9,iw)=kolor
          wire(10,iw)=k ! number
        enddo
      enddo

      ncwires=iw

      return
      end
