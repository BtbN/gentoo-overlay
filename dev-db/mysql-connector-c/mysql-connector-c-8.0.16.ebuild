# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

MULTILIB_WRAPPED_HEADERS+=(
	/usr/include/mysql/my_config.h
)

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/connector/c/"
LICENSE="GPL-2"

SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-${PV}.tar.gz"
KEYWORDS="~amd64"

# It's actually 21, but nothing is prepared for that.
SUBSLOT="18"
SLOT="0/${SUBSLOT}"
IUSE="libressl +ssl static-libs"

CDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	ssl? (
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	)
	"
RDEPEND="${CDEPEND}
	!dev-db/mysql[client-libs(+)]
	!dev-db/mysql-cluster[client-libs(+)]
	!dev-db/mariadb[client-libs(+)]
	!dev-db/mariadb-connector-c[mysqlcompat]
	!dev-db/mariadb-galera[client-libs(+)]
	!dev-db/percona-server[client-libs(+)]
	"
DEPEND="${CDEPEND}"

DOCS=( README )

S="${WORKDIR}/mysql-${PV}"

src_prepare() {
	sed -i -e 's/CLIENT_LIBS/CONFIG_CLIENT_LIBS/' "${S}/scripts/CMakeLists.txt" || die
	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DINSTALL_LAYOUT=RPM
		-DINSTALL_LIBDIR=$(get_libdir)
		-DWITH_DEFAULT_COMPILER_OPTIONS=OFF
		-DWITH_DEFAULT_FEATURE_SET=OFF
		-DENABLED_LOCAL_INFILE=ON
		-DMYSQL_UNIX_ADDR="${EPREFIX}/run/mysqld/mysqld.sock"
		-DWITH_ZLIB=system
		-DWITH_SSL=$(usex ssl system bundled)
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITH_BOOST="${S}/boost"
		-DWITHOUT_SERVER=ON
	)
	cmake-utils_src_configure
}

multilib_src_install() {
	cmake-utils_src_install
	find "${D}/usr/bin" -type f -not -name my_print_defaults -not -name perror -not -name mysql_config -delete || die "deleting failed"
	rm -r "${D}/usr/share" || die "rm failed"
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}

pkg_preinst() {
	if [[ -z ${REPLACING_VERSIONS} && -e "${EROOT}usr/$(get_libdir)/libmysqlclient.so" ]] ; then
		elog "Due to ABI changes when switching between different client libraries,"
		elog "revdep-rebuild must find and rebuild all packages linking to libmysqlclient."
		elog "Please run: revdep-rebuild --library libmysqlclient.so.${SUBSLOT}"
		ewarn "Failure to run revdep-rebuild may cause issues with other programs or libraries"
	fi
}
