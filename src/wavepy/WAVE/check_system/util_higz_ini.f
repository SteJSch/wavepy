*CMZ : 00.00/02 07/01/98  15.23.41  by  Michael Scheer
*-- Author :    Michael Scheer   07/01/98

      SUBROUTINE UTIL_HIGZ_INI

      IMPLICIT NONE

      INTEGER NDPAWCP
      PARAMETER (NDPAWCP=200000)
      REAL*4 RPAW(NDPAWCP)
      COMMON/PAWC/RPAW

      CALL HLIMIT(NDPAWCP)
      CALL HPLINT(1)

      RETURN
      END