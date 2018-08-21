# Copyright 2017-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.6
ansi_term-0.11.0
arrayvec-0.4.7
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.24
base64-0.9.2
bitflags-0.9.1
bitflags-1.0.3
byteorder-1.2.4
bytes-0.4.9
cargo_metadata-0.5.8
cc-1.0.18
cfg-if-0.1.5
clap-2.32.0
clippy-0.0.212
clippy_lints-0.0.212
crossbeam-deque-0.3.1
crossbeam-epoch-0.4.3
crossbeam-utils-0.3.2
doh-proxy-0.1.8
either-1.5.0
error-chain-0.11.0
fnv-1.0.6
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.23
futures-cpupool-0.1.8
getopts-0.2.18
h2-0.1.12
http-0.1.10
httparse-1.3.2
hyper-0.12.8
idna-0.1.5
if_chain-0.1.3
indexmap-1.0.1
iovec-0.1.2
itertools-0.7.8
itoa-0.4.2
kernel32-sys-0.2.2
lazy_static-1.1.0
lazycell-0.6.0
libc-0.2.43
log-0.4.4
matches-0.1.7
memchr-2.0.1
memoffset-0.2.1
mio-0.6.15
miow-0.2.1
net2-0.2.33
nodrop-0.1.12
num-traits-0.2.5
num_cpus-1.8.0
percent-encoding-1.0.1
proc-macro2-0.4.13
pulldown-cmark-0.1.2
quine-mc_cluskey-0.2.4
quote-0.6.6
rand-0.4.3
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.2
regex-syntax-0.6.2
rustc-demangle-0.1.9
rustc_version-0.2.3
ryu-0.2.4
safemem-0.2.0
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.72
serde_derive-1.0.72
serde_json-1.0.26
slab-0.3.0
slab-0.4.1
string-0.1.1
strsim-0.7.0
syn-0.14.8
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.6
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
toml-0.4.6
try-lock-0.2.2
ucd-util-0.1.1
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
url-1.7.1
utf8-ranges-1.0.0
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

DEPEND=">=dev-util/cargo-0.29.0
	>=virtual/rust-1.28.0"

src_install() {
	cargo_src_install

	systemd_dounit "${FILESDIR}"/doh-proxy.service
}
