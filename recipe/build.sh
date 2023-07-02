set -ex

export DESTDIR="/"

export PKG_CONFIG=$BUILD_PREFIX/bin/pkg-config

if [ -z "$MESON_ARGS" ]; then
  # for some reason this is not set on Linux
  MESON_ARGS="--buildtype=release --prefix=${PREFIX} --libdir=lib"
fi

# _BSD_SOURCE must be set on old versions of Linux to expose some typedefs
export CPPFLAGS="-D_BSD_SOURCE=1 ${CPPFLAGS}"

meson setup builddir \
	 ${MESON_ARGS} \
	-Dopenssl=enabled \
	-Dgnutls=disabled \
	-Dlibproxy=disabled \
	-Dgnome_proxy=disabled \
	--wrap-mode=nofallback || cat builddir/meson-logs/meson-log.txt
ninja -v -C builddir -j ${CPU_COUNT}
ninja -C builddir install -j ${CPU_COUNT}
