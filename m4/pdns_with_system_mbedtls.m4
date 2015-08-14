AC_DEFUN([PDNS_WITH_SYSTEM_MBEDTLS],[
  AC_ARG_WITH([system-mbedtls],
    [AS_HELP_STRING([--with-system-mbedtls], [use system mbedt TLS @<:@default=no@:>@])],
    [],
    [with_system_mbedtls=no],
  )

  MBEDTLS_SUBDIR=mbedtls
  MBEDTLS_CFLAGS=-I\$\(top_srcdir\)/ext/$MBEDTLS_SUBDIR/include/
  MBEDTLS_LIBS="-L\$(top_builddir)/ext/$MBEDTLS_SUBDIR/library/ -lpolarssl"

  AS_IF([test "x$with_system_mbedtls" = "xyes"],[
    OLD_LIBS=$LIBS
    LIBS=""
    AC_SEARCH_LIBS([sha1_hmac], [mbedtls polarssl],[
      MBEDTLS_LIBS=$LIBS
      AC_MSG_CHECKING([for mbed TLS/PolarSSL version >= 1.3])
      AC_COMPILE_IFELSE([
        AC_LANG_PROGRAM(
          [[#include <polarssl/version.h>]],
          [[
            #if POLARSSL_VERSION_NUMBER < 0x01030000
            #error invalid version
            #endif
          ]]
        )],
        [have_system_mbedtls=yes],
        [have_system_mbedtls=no]
      )
      AC_MSG_RESULT([$have_system_mbedtls])
      ],
      [have_system_mbedtls=no]
    )
    LIBS=$OLD_LIBS
    ],
    [have_system_mbedtls=no]
  )

  AS_IF([test "x$have_system_mbedtls" = "xyes"],[
    MBEDTLS_CFLAGS=
    MBEDTLS_SUBDIR=
    AC_DEFINE([POLARSSL_SYSTEM], [1], [Defined if system mbed TLS is used])
    ],[
    AS_IF([test "x$with_system_mbedtls" = "xyes"],[
      AC_MSG_ERROR([use of system mbedtls requested but not found])]
    )]
  )

  AC_SUBST(MBEDTLS_CFLAGS)
  AC_SUBST(MBEDTLS_LIBS)
  AC_SUBST(MBEDTLS_SUBDIR)
]
)

