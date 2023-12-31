*CMZ :  4.00/11 04/02/2021  15.09.44  by  Michael Scheer
*CMZ :  2.01/03 24/01/2019  10.41.25  by  Michael Scheer
*CMZ :  1.25/04 03/04/2018  11.55.41  by  Michael Scheer
*CMZ :  1.25/02 22/03/2018  14.48.44  by  Michael Scheer
*CMZ :  1.25/01 16/03/2018  16.51.35  by  Michael Scheer
*CMZ :  1.25/00 15/03/2018  21.53.23  by  Michael Scheer
*-- Author :    Michael Scheer   08/03/2018
      subroutine undumag_race_to_fila(k)

      use undumagf90m

      use commandlinef90m

      implicit none

*KEEP,phycon.
      include 'phycon.cmn'
*KEND.

      double precision, dimension (:), allocatable :: y,z

      double precision h,w,r,barl,curr,cw,vx,vy,vz,phi,alpha,cosa,sina,
     &  cosphi,sinphi,cosphi1,sinphi2,cosphi2,sinphi1,costhe,sinthe,
     &  xc,yc,zc,x0,y0,z0,dphi,dr,dy,ro,ri,xr1,zr1,xr2,zr2,dz,vn,
     &  xi,xo,zi,zo,wx,wy,wz,ux,uy,uz,rotmat(3,3),vnor(3),rmat(3,3)

      integer k,iw,ir,nz,ny,nphi,iphi,iy,iz,kolor,ical,istat,i,j,kold

      data ical/0/

      save ical,iw

      !rotate (vx,vy,vz) to y-axis

      if (ical.eq.0) then
        ical=1
      endif

      iw=ncwires
      kold=iw

      curr=race(1,k)

      x0=race(2,k)
      y0=race(3,k)
      z0=race(4,k)

      vx=race(5,k)
      vy=race(6,k)
      vz=race(7,k)

      vn=sqrt(vx**2+vy**2+vz**2)
      if (vn.eq.0.0d0) then
        write(lun6,*)
        write(lun6,*)"*** Error in undumag_race_to_fila: Zero normal vector for coil",k
        stop
      endif
      vx=vx/vn
      vy=vy/vn
      vz=vz/vn

      alpha=race(8,k)
      xo=race(9,k)/2.0d0
      zi=race(10,k)/2.0d0
      zo=race(11,k)/2.0d0
      ri=race(12,k)
      h=race(13,k)
      ny=race(14,k)
      nz=race(15,k)
      nphi=race(16,k)
      kolor=race(17,k)

      w=zo-zi
      xi=xo-w
      ro=ri+w

      yc=0.0d0

c      if (ri.lt.w) then
c        write(lun6,*)
c        write(lun6,*)"*** Warning in undumag_race_to_fila: Inner radius of coils is lower than the difference of outer and inner width ***"
c        stop
c      endif

      if (xi.lt.ri) then
        write(lun6,*)
        write(lun6,*)"*** Error in undumag_race_to_fila: The inner length is smaller than twice the inner radius ***"
        stop
      endif

      allocate(y(ny),z(nz))

      dphi=pi1/2.0d0/nphi
      dy=h/ny
      dz=w/nz

      do iz=1,nz
        z(iz)=zi+(iz-0.5d0)*dz
      enddo

      do iy=1,ny
        y(iy)=yc-h/2.0d0+(iy-0.5d0)*dy
      enddo

      cw=curr/(ny*nz)

      ! first x bar
      do iy=1,ny
        do iz=1,nz
          iw=iw+1
          wire(1,iw)=2 ! racetrack flag
          wire(2,iw)=cw
          wire(3,iw)=+xi-ri
          wire(4,iw)=+y(iy)
          wire(5,iw)=-z(iz)
          wire(6,iw)=-xi+ri
          wire(7,iw)=+y(iy)
          wire(8,iw)=-z(iz)
          wire(9,iw)=kolor
          wire(10,iw)=k ! racetrack number
        enddo
      enddo

      ! first arc
      xc=-xi+ri
      zc=-zi+ri
      sinphi1=0.0d0
      cosphi1=1.0d0
      do iphi=1,nphi
        sinphi2=sin(iphi*dphi)
        cosphi2=cos(iphi*dphi)
        do iy=1,ny
          do iz=1,nz
            iw=iw+1
            r=ri+(iz-0.5d0)*dz
            wire(1,iw)=2
            wire(2,iw)=cw
            wire(3,iw)=+xc-r*sinphi1
            wire(4,iw)=+y(iy)
            wire(5,iw)=+zc-r*cosphi1
            wire(6,iw)=+xc-r*sinphi2
            wire(7,iw)=+y(iy)
            wire(8,iw)=+zc-r*cosphi2
            wire(9,iw)=kolor
            wire(10,iw)=k ! racetrack number
          enddo
        enddo
        sinphi1=sinphi2
        cosphi1=cosphi2
      enddo

      ! first z bar
      do iy=1,ny
        do iz=1,nz
          iw=iw+1
          wire(1,iw)=2 ! racetrack flag
          wire(2,iw)=cw
          wire(3,iw)=-xi-(iz-0.5d0)*dz
          wire(4,iw)=+y(iy)
          wire(5,iw)=-zi+ri
          wire(6,iw)=wire(3,iw)
          wire(7,iw)=+y(iy)
          wire(8,iw)=+zi-ri
          wire(9,iw)=kolor
          wire(10,iw)=k ! racetrack number
        enddo
      enddo

      ! second arc
      xc=-xi+ri
      zc=zi-ri
      sinphi1=0.0d0
      cosphi1=1.0d0
      do iphi=1,nphi
        sinphi2=sin(iphi*dphi)
        cosphi2=cos(iphi*dphi)
        do iy=1,ny
          do iz=1,nz
            iw=iw+1
            r=ri+(iz-0.5d0)*dz
            wire(1,iw)=2
            wire(2,iw)=cw
            wire(3,iw)=+xc-r*cosphi1
            wire(4,iw)=+y(iy)
            wire(5,iw)=+zc+r*sinphi1
            wire(6,iw)=+xc-r*cosphi2
            wire(7,iw)=+y(iy)
            wire(8,iw)=+zc+r*sinphi2
            wire(9,iw)=kolor
            wire(10,iw)=k ! racetrack number
          enddo
        enddo
        sinphi1=sinphi2
        cosphi1=cosphi2
      enddo

      ! second x bar
      do iy=1,ny
        do iz=1,nz
          iw=iw+1
          wire(1,iw)=2 ! racetrack flag
          wire(2,iw)=cw
          wire(3,iw)=-xi+ri
          wire(4,iw)=+y(iy)
          wire(5,iw)=+z(iz)
          wire(6,iw)=+xi-ri
          wire(7,iw)=+y(iy)
          wire(8,iw)=+z(iz)
          wire(9,iw)=kolor
          wire(10,iw)=k ! racetrack number
        enddo
      enddo

      ! third arc
      xc=xi-ri
      zc=zi-ri
      sinphi1=0.0d0
      cosphi1=1.0d0
      do iphi=1,nphi
        sinphi2=sin(iphi*dphi)
        cosphi2=cos(iphi*dphi)
        do iy=1,ny
          do iz=1,nz
            iw=iw+1
            r=ri+(iz-0.5d0)*dz
            wire(1,iw)=2
            wire(2,iw)=cw
            wire(3,iw)=+xc+r*sinphi1
            wire(4,iw)=+y(iy)
            wire(5,iw)=+zc+r*cosphi1
            wire(6,iw)=+xc+r*sinphi2
            wire(7,iw)=+y(iy)
            wire(8,iw)=+zc+r*cosphi2
            wire(9,iw)=kolor
            wire(10,iw)=k ! racetrack number
          enddo
        enddo
        sinphi1=sinphi2
        cosphi1=cosphi2
      enddo

      ! second z bar
      do iy=1,ny
        do iz=1,nz
          iw=iw+1
          wire(1,iw)=2 ! racetrack flag
          wire(2,iw)=cw
          wire(3,iw)=+xi+(iz-0.5d0)*dz
          wire(4,iw)=+y(iy)
          wire(5,iw)=+zi-ri
          wire(6,iw)=wire(3,iw)
          wire(7,iw)=+y(iy)
          wire(8,iw)=-zi+ri
          wire(9,iw)=kolor
          wire(10,iw)=k ! racetrack number
        enddo
      enddo

      ! fourth arc
      xc=xi-ri
      zc=-zi+ri
      sinphi1=0.0d0
      cosphi1=1.0d0
      do iphi=1,nphi
        sinphi2=sin(iphi*dphi)
        cosphi2=cos(iphi*dphi)
        do iy=1,ny
          do iz=1,nz
            iw=iw+1
            r=ri+(iz-0.5d0)*dz
            wire(1,iw)=2
            wire(2,iw)=cw
            wire(3,iw)=+xc+r*cosphi1
            wire(4,iw)=+y(iy)
            wire(5,iw)=+zc-r*sinphi1
            wire(6,iw)=+xc+r*cosphi2
            wire(7,iw)=+y(iy)
            wire(8,iw)=+zc-r*sinphi2
            wire(9,iw)=kolor
            wire(10,iw)=k ! racetrack number
          enddo
        enddo
        sinphi1=sinphi2
        cosphi1=cosphi2
      enddo


      !rotate and translate coil

      vnor(1)=vx
      vnor(2)=vy
      vnor(3)=vz
      call util_rotate_vector_to_y_axis(vnor,rotmat,istat)

      do i=1,3
        do j=1,3
          rmat(i,j)=rotmat(j,i)
        enddo
      enddo

      cosa=cos(alpha/180.0d0*pi1)
      sina=sin(alpha/180.0d0*pi1)

      do i=kold+1,iw
        wx=cosa*wire(3,i)+sina*wire(5,i)
        wy=wire(4,i)
        wz=-sina*wire(3,i)+cosa*wire(5,i)
        wire(3:5,i)=rmat(1:3,1)*wx+rmat(1:3,2)*wy+rmat(1:3,3)*wz
        wx=wire(6,i)
        wy=wire(7,i)
        wz=wire(8,i)
        wx=cosa*wire(6,i)+sina*wire(8,i)
        wy=wire(7,i)
        wz=-sina*wire(6,i)+cosa*wire(8,i)
        wire(6:8,i)=rmat(1:3,1)*wx+rmat(1:3,2)*wy+rmat(1:3,3)*wz
        wire(3,i)=wire(3,i)+x0
        wire(4,i)=wire(4,i)+y0
        wire(5,i)=wire(5,i)+z0
        wire(6,i)=wire(6,i)+x0
        wire(7,i)=wire(7,i)+y0
        wire(8,i)=wire(8,i)+z0
      enddo

      deallocate(y,z)

      ncwires=iw

      return
      end
