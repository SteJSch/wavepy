*CMZ :  4.01/02 04/05/2023  12.52.24  by  Michael Scheer
*CMZ :  3.05/00 27/04/2018  12.45.27  by  Michael Scheer
*CMZ :  1.25/00 16/03/2018  14.15.52  by  Michael Scheer
*CMZ :  1.23/03 19/09/2017  19.32.15  by  Michael Scheer
*CMZ :  1.23/02 18/09/2017  14.10.42  by  Michael Scheer
*CMZ :  1.15/11 19/04/2017  14.47.22  by  Michael Scheer
*CMZ :  1.15/02 01/04/2017  15.43.17  by  Michael Scheer
*CMZ :  1.15/01 28/03/2017  14.43.16  by  Michael Scheer
*CMZ :  1.10/01 18/11/2016  15.02.58  by  Michael Scheer
*CMZ :  1.02/01 09/09/2016  13.43.20  by  Michael Scheer
*CMZ :  0.00/13 16/08/2016  12.20.28  by  Michael Scheer
*CMZ :  0.00/09 04/07/2016  15.33.12  by  Michael Scheer
*CMZ :  0.00/01 26/04/2016  16.02.08  by  Michael Scheer
*CMZ :  1.17/14 13/04/2016  09.46.04  by  Michael Scheer
*CMZ :  1.17/13 07/04/2016  17.38.21  by  Michael Scheer
*CMZ :  1.17/12 06/04/2016  14.53.04  by  Michael Scheer
*CMZ :  1.17/09 04/04/2016  09.28.51  by  Michael Scheer
*CMZ :  1.17/07 04/04/2016  08.49.46  by  Michael Scheer
*-- Author :    Michael Scheer   03/04/2016
      subroutine undumag_field(x,y,z,bxout,byout,bzout,ifail)

      use bpolyederf90m
      use undumagf90m

      implicit none

*KEEP,seqdebug.
      include 'seqdebug.cmn'
*KEND.

      double precision x,y,z,hx,hy,hz,bxout,byout,bzout,xcut,bx,by,bz,xi,xe
      integer ifail,ifailin,kfail,linside

c      kfail=iwarnbound
      ifailin=ifail
      ifail=0

      if (kundumap.ne.0) then
        call bundumap(x,y,z,bxout,byout,bzout,xi,xe)
        return
      endif

      if (nrec.eq.0.and.kbextern.eq.0.and.ncwires.eq.0) then
        bxout=0.0d0
        byout=0.0d0
        bzout=0.0d0
        return
      endif

      if (nmag.ne.0) then

        linside=kinside

        !x1y1z1
        kfail=ifailin
        call undumag_bpolyeder(x,y,z,bxout,byout,bzout,kfail)
        ifail=ifail+kfail
        if (kinside.gt.0) then
          linside=kinside
          kinside=0
        endif

        if (ixsym.eq.0) then

          if (iysym.ne.0) then
            kfail=ifailin
            call undumag_bpolyeder(x,-y,z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout-hx
            byout=byout+hy
            bzout=bzout-hz
          endif

          if (izsym.ne.0) then
            kfail=ifailin
            call undumag_bpolyeder(x,y,-z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout+hx
            byout=byout+hy
            bzout=bzout-hz
          endif

          if (iysym.ne.0.and.izsym.ne.0) then
            kfail=ifailin
            call undumag_bpolyeder(x,-y,-z,hx,hy,hz,kfail)
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            ifail=ifail+kfail
            bxout=bxout-hx
            byout=byout+hy
            bzout=bzout+hz
          endif

        else !ixsym

          xcut=2.0d0*xsym-x

          !x2y1z1
          kfail=ifailin
          call undumag_bpolyeder(xcut,y,z,hx,hy,hz,kfail)
          ifail=ifail+kfail
          if (kinside.gt.0) then
            linside=kinside
            kinside=0
          endif
          bxout=bxout-hx
          byout=byout+hy
          bzout=bzout+hz

          if (iysym.ne.0) then
            !x1y2z1
            kfail=ifailin
            call undumag_bpolyeder(x,-y,z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout-hx
            byout=byout+hy
            bzout=bzout-hz
            !x2y1z1
            kfail=ifailin
            call undumag_bpolyeder(xcut,-y,z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            bxout=bxout+hx
            byout=byout+hy
            bzout=bzout-hz
          endif

          if (izsym.ne.0) then
            !x1y1z2
            kfail=ifailin
            call undumag_bpolyeder(x,y,-z,hx,hy,hz,kfail)
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            ifail=ifail+kfail
            bxout=bxout+hx
            byout=byout+hy
            bzout=bzout-hz
            !x2y1z2
            kfail=ifailin
            call undumag_bpolyeder(xcut,y,-z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout-hx
            byout=byout+hy
            bzout=bzout-hz
          endif

          if (iysym.ne.0.and.izsym.ne.0) then
            !x2y2z2
            kfail=ifailin
            call undumag_bpolyeder(xcut,-y,-z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout+hx
            byout=byout+hy
            bzout=bzout+hz
            !x1y2z2
            kfail=ifailin
            call undumag_bpolyeder(x,-y,-z,hx,hy,hz,kfail)
            ifail=ifail+kfail
            if (kinside.gt.0) then
              linside=kinside
              kinside=0
            endif
            bxout=bxout-hx
            byout=byout+hy
            bzout=bzout+hz
          endif

        endif !ixsym

      endif !(nmag.ne.0)

      if (Abs(bxout).lt.1.0d-15) bxout=0.0d0
      if (Abs(byout).lt.1.0d-15) byout=0.0d0
      if (Abs(bzout).lt.1.0d-15) bzout=0.0d0

c      if (iwarnbound.ne.kfail) kfail=100+ifail

      if (ncwires.gt.0) then
        call undumag_bcoils(x,y,z,bx,by,bz,ifail)
        bxout=bxout+bx
        byout=byout+by
        bzout=bzout+bz
      endif

      if (kbextern.ne.0) then
        bxout=bxout+bxex
        byout=byout+byex
        bzout=bzout+bzex
      endif

      kinside=linside

      return
      end
