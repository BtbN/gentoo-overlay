# Copyright 2017-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

CRATES="
aho-corasick-0.6.6
ansi_term-0.11.0
arrayvec-0.4.7
atty-0.2.11
backtrace-0.3.9
backtrace-sys-0.1.23
base64-0.9.2
bitflags-0.9.1
bitflags-1.0.3
byteorder-1.2.4
bytes-0.4.9
cargo_metadata-0.5.8
cc-1.0.18
cfg-if-0.1.4
clap-2.32.0
clippy-0.0.212
clippy_lints-0.0.212
crossbeam-deque-0.3.1
crossbeam-epoch-0.4.3
crossbeam-utils-0.3.2
doh-proxy-0.1.7
dtoa-0.4.3
either-1.5.0
error-chain-0.11.0
fuchsia-zircon-0.3.3
fuchsia-zircon-sys-0.3.3
futures-0.1.23
futures-cpupool-0.1.8
getopts-0.2.18
httparse-1.3.2
hyper-0.11.27
idna-0.1.5
if_chain-0.1.3
iovec-0.1.2
itertools-0.7.8
itoa-0.4.2
kernel32-sys-0.2.2
language-tags-0.2.2
lazy_static-1.1.0
lazycell-0.6.0
libc-0.2.42
log-0.3.9
log-0.4.3
matches-0.1.7
memchr-2.0.1
memoffset-0.2.1
mime-0.3.8
mio-0.6.15
miow-0.2.1
net2-0.2.33
nodrop-0.1.12
num-traits-0.2.5
num_cpus-1.8.0
percent-encoding-1.0.1
proc-macro2-0.4.9
pulldown-cmark-0.1.2
quine-mc_cluskey-0.2.4
quote-0.6.5
rand-0.3.22
rand-0.4.2
redox_syscall-0.1.40
redox_termios-0.1.1
regex-1.0.2
regex-syntax-0.6.2
relay-0.1.1
rustc-demangle-0.1.9
rustc_version-0.2.3
safemem-0.2.0
scoped-tls-0.1.2
scopeguard-0.3.3
semver-0.9.0
semver-parser-0.7.0
serde-1.0.70
serde_derive-1.0.70
serde_json-1.0.24
slab-0.3.0
slab-0.4.1
smallvec-0.2.1
strsim-0.7.0
syn-0.14.7
take-0.1.0
termion-1.5.1
textwrap-0.10.0
thread_local-0.3.5
time-0.1.40
tokio-0.1.7
tokio-codec-0.1.0
tokio-core-0.1.17
tokio-executor-0.1.2
tokio-fs-0.1.2
tokio-io-0.1.7
tokio-proto-0.1.1
tokio-reactor-0.1.2
tokio-service-0.1.0
tokio-tcp-0.1.0
tokio-threadpool-0.1.5
tokio-timer-0.1.2
tokio-timer-0.2.4
tokio-udp-0.1.1
toml-0.4.6
try-lock-0.1.0
ucd-util-0.1.1
unicase-2.1.0
unicode-bidi-0.3.4
unicode-normalization-0.1.7
unicode-width-0.1.5
unicode-xid-0.1.0
unreachable-1.0.0
url-1.7.1
utf8-ranges-1.0.0
vec_map-0.8.1
version_check-0.1.4
void-1.0.2
want-0.0.4
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
