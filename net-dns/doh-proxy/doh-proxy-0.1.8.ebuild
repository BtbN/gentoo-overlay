# Copyright 2017-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
ansi_term-0.11.0
arrayvec-0.4.7
atty-0.2.11
base64-0.9.2
bitflags-1.0.3
byteorder-1.2.4
bytes-0.4.9
cfg-if-0.1.5
clap-2.32.0
crossbeam-deque-0.3.1
crossbeam-epoch-0.4.3
crossbeam-utils-0.3.2
doh-proxy-0.1.8
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.23
futures-cpupool-0.1.8
h2-0.1.12
http-0.1.10
httparse-1.3.2
hyper-0.12.8
indexmap-1.0.1
iovec-0.1.2
itoa-0.4.2
kernel32-sys-0.2.2
lazy_static-1.1.0
lazycell-0.6.0
libc-0.2.43
log-0.4.4
memoffset-0.2.1
mio-0.6.15
miow-0.2.1
net2-0.2.33
nodrop-0.1.12
num_cpus-1.8.0
rand-0.4.3
redox_syscall-0.1.40
redox_termios-0.1.1
rustc_version-0.2.3
safemem-0.2.0
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
slab-0.3.0
slab-0.4.1
string-0.1.1
strsim-0.7.0
termion-1.5.1
textwrap-0.10.0
time-0.1.40
tokio-0.1.7
tokio-codec-0.1.0
tokio-executor-0.1.3
tokio-fs-0.1.3
tokio-io-0.1.7
tokio-reactor-0.1.3
tokio-tcp-0.1.1
tokio-threadpool-0.1.5
tokio-timer-0.1.2
tokio-timer-0.2.5
tokio-udp-0.1.1
try-lock-0.2.2
unicode-width-0.1.5
vec_map-0.8.1
version_check-0.1.4
want-0.0.6
winapi-0.2.8
winapi-0.3.5
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
IUSE=""

DEPEND=">=dev-util/cargo-0.28.0"

src_install() {
	cargo_src_install

	systemd_dounit "${FILESDIR}"/doh-proxy.service
}
