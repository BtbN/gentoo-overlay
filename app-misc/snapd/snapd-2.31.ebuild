# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools systemd

DESCRIPTION="Service and tools for management of snap packages"
HOMEPAGE="http://snapcraft.io/"

SRC_URI="https://github.com/snapcore/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
#KEYWORDS="~amd64"
IUSE=""

RESTRICT="mirror"

DEPEND="sys-apps/systemd
	sys-libs/libseccomp
	sys-fs/squashfs-tools:0
	sys-libs/libcap
	sys-fs/xfsprogs
	dev-vcs/git
	dev-lang/go
	dev-go/go-tools"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.31-cmd-snap-seccomp-drop-link-flags-that-will-be-reject.patch"
)

src_prepare() {
	export GOPATH="${WORKDIR}/go"

	pkg_go_path="$GOPATH/src/github.com/snapcore"
	mkdir -p "$pkg_go_path"
	ln --no-target-directory -fs "${S}" "${pkg_go_path}/${PN}"

	default
}

src_compile() {
	export GOPATH="${WORKDIR}/go"
	export XDG_CONFIG_HOME="${S}"

	export CGO_ENABLED="1"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export CGO_LDFLAGS="${LDFLAGS}"

	local go_url="github.com/snapcore/${PN}"

	./mkversion.sh "${PVR}" || die "mkversion failed"

	cd "${GOPATH}/src/${go_url}"
	./get-deps.sh || die "get-deps failed"

	go build -o "$GOPATH/bin/snap" "${go_url}/cmd/snap" || die "go build failed"
	go build -o "$GOPATH/bin/snapctl" "${go_url}/cmd/snapctl" || die "go build failed"
	go build -o "$GOPATH/bin/snapd" "${go_url}/cmd/snapd" || die "go build failed"
	go build -o "$GOPATH/bin/snap-seccomp" "${go_url}/cmd/snap-seccomp" || die "go build failed"
	go build -o "$GOPATH/bin/snap-update-ns" -ldflags '-extldflags "-static"' "${go_url}/cmd/snap-update-ns" || die "go build failed"
	CGO_ENABLED=0 go build -o $GOPATH/bin/snap-exec "${go_url}/cmd/snap-exec" || die "go build failed"

	emake -C data \
		BINDIR=/usr/bin \
		LIBEXECDIR=/usr/lib \
		SYSTEMDSYSTEMUNITDIR=/lib/systemd/system \
		SNAP_MOUNT_DIR=/var/lib/snapd/snap \
		SNAPD_ENVIRONMENT_FILE=/etc/default/snapd
	
	cd cmd
	eautoreconf
	./configure --prefix=/usr \
		--libexecdir=/usr/lib/snapd \
		--with-snap-mount-dir=/var/lib/snapd/snap \
		--disable-apparmor \
		--enable-nvidia-biarch \
		--enable-merged-usr || die "configure failed"
	emake
}

