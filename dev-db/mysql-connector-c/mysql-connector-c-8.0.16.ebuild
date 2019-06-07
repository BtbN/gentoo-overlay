# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

# wrap the config script
MULTILIB_CHOST_TOOLS=( /usr/bin/mysql_config )

DESCRIPTION="C client library for MariaDB/MySQL"
HOMEPAGE="https://dev.mysql.com/downloads/"
LICENSE="GPL-2"

SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-boost-${PV}.tar.gz"
KEYWORDS="~amd64"

SLOT="0/18" # 0/21, but it's broken...
IUSE="ldap libressl +ssl static-libs"

CDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	ldap? ( dev-libs/cyrus-sasl:=[${MULTILIB_USEDEP}] )
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

	# All these are for the server only
	sed -i \
		-e '/MYSQL_CHECK_LIBEVENT/d' \
		-e '/MYSQL_CHECK_RAPIDJSON/d' \
		-e '/MYSQL_CHECK_ICU/d' \
		-e '/MYSQL_CHECK_RE2/d' \
		-e '/MYSQL_CHECK_LZ4/d' \
		-e '/MYSQL_CHECK_EDITLINE/d' \
		-e '/MYSQL_CHECK_CURL/d' \
		-e '/ADD_SUBDIRECTORY(man)/d' \
		-e '/ADD_SUBDIRECTORY(share)/d' \
		CMakeLists.txt || die

	# Skip building clients
	echo > client/CMakeLists.txt || die

	if use libressl ; then
		sed -i 's/OPENSSL_MAJOR_VERSION STREQUAL "1"/OPENSSL_MAJOR_VERSION STREQUAL "2"/' \
			"${S}/cmake/ssl.cmake" || die
	fi

	# Forcefully disable auth plugin
	if ! use ldap ; then
		sed -i -e '/MYSQL_CHECK_SASL/d' CMakeLists.txt || die
		echo > libmysql/authentication_ldap/CMakeLists.txt || die
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
		-DWITH_SSL=$(usex ssl system wolfssl)
		-DLIBMYSQL_OS_OUTPUT_NAME=mysqlclient
		-DSHARED_LIB_PATCH_VERSION="0"
		-DCMAKE_POSITION_INDEPENDENT_CODE=ON
		-DWITH_BOOST="${S}/boost"
		-DWITHOUT_SERVER=ON
	)
	cmake-utils_src_configure
}

multilib_src_install_all() {
	if ! use static-libs ; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
