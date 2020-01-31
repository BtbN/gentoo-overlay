# Copyright 2017-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES="
ansi_term-0.11.0
anyhow-1.0.26
atty-0.2.13
autocfg-0.1.7
base64-0.11.0
bitflags-1.2.1
byteorder-1.3.2
bytes-0.5.3
c2-chacha-0.2.3
cc-1.0.48
cfg-if-0.1.10
clap-2.33.0
core-foundation-0.6.4
core-foundation-sys-0.6.2
doh-proxy-0.2.1
fnv-1.0.6
foreign-types-0.3.2
foreign-types-shared-0.1.1
fs_extra-1.1.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.3.1
futures-channel-0.3.1
futures-core-0.3.1
futures-executor-0.3.1
futures-io-0.3.1
futures-macro-0.3.1
futures-sink-0.3.1
futures-task-0.3.1
futures-util-0.3.1
getrandom-0.1.13
h2-0.2.1
hermit-abi-0.1.5
http-0.2.0
http-body-0.3.1
httparse-1.3.4
hyper-0.13.1
indexmap-1.3.0
iovec-0.1.4
itoa-0.4.4
jemalloc-sys-0.3.2
jemallocator-0.3.2
kernel32-sys-0.2.2
lazy_static-1.4.0
libc-0.2.66
libdoh-0.2.1
log-0.4.8
memchr-2.2.1
mio-0.6.21
miow-0.2.1
native-tls-0.2.3
net2-0.2.33
num_cpus-1.11.1
openssl-0.10.26
openssl-probe-0.1.2
openssl-sys-0.9.53
pin-project-0.4.6
pin-project-internal-0.4.6
pin-project-lite-0.1.1
pin-utils-0.1.0-alpha.4
pkg-config-0.3.17
ppv-lite86-0.2.6
proc-macro-hack-0.5.11
proc-macro-nested-0.1.3
proc-macro2-1.0.6
quote-1.0.2
rand-0.7.2
rand_chacha-0.2.1
rand_core-0.5.1
rand_hc-0.2.0
redox_syscall-0.1.56
remove_dir_all-0.5.2
schannel-0.1.16
security-framework-0.3.4
security-framework-sys-0.3.3
slab-0.4.2
strsim-0.8.0
syn-1.0.11
tempfile-3.1.0
textwrap-0.11.0
time-0.1.42
tokio-0.2.6
tokio-tls-0.3.0
tokio-util-0.2.0
tower-service-0.3.0
try-lock-0.2.2
unicode-width-0.1.7
unicode-xid-0.2.0
vcpkg-0.2.8
vec_map-0.8.1
want-0.3.0
wasi-0.7.0
winapi-0.2.8
winapi-0.3.8
winapi-build-0.1.1
winapi-i686-pc-windows-gnu-0.4.0
winapi-x86_64-pc-windows-gnu-0.4.0
ws2_32-sys-0.2.1
"

inherit cargo systemd

DESCRIPTION="A DNS-over-HTTPS (DoH) proxy"
HOMEPAGE="https://github.com/jedisct1/rust-doh"
SRC_URI="$(cargo_crate_uris ${CRATES})"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:0 )"
RDEPEND="$DEPEND"
BDEPEND=">=virtual/rust-1.39"

src_compile() {
	cargo_src_compile \
		$(usex ssl --features=tls "")
}

src_install() {
	cargo_src_install \
		$(usex ssl --features=tls "")

	systemd_dounit "${FILESDIR}"/doh-proxy.service
}
