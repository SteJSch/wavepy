*CMZ : 00.00/15 24/10/2012  14.21.57  by  Michael Scheer
*CMZ : 00.00/00 10/01/95  15.27.17  by  Michael Scheer
*-- Author :
      SUBROUTINE UTIL_CHECK_GFLOAT(IGFLOAT)

C--- FLAG IGFLOAT IS SET TO ONE IF ROUTINE IS COMPILED WITH G_FLOAT OPTION

      IMPLICIT NONE
      REAL*8 G
      INTEGER IGFLOAT
      DATA G/1./
      igfloat=0
      RETURN
      END
