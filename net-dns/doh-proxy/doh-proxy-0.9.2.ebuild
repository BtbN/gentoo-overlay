# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
	aead-0.3.2
	aes-0.6.0
	aes-gcm-0.8.0
	aes-soft-0.6.4
	aesni-0.10.0
	ansi_term-0.12.1
	anyhow-1.0.55
	arc-swap-1.5.0
	atty-0.2.14
	autocfg-1.1.0
	base64-0.13.0
	bitflags-1.3.2
	bitvec-0.18.5
	block-buffer-0.9.0
	bumpalo-3.9.1
	byteorder-1.4.3
	bytes-1.1.0
	cc-1.0.73
	cfg-if-1.0.0
	chacha20-0.6.0
	chacha20poly1305-0.7.1
	cipher-0.2.5
	clap-2.34.0
	cpufeatures-0.2.1
	cpuid-bool-0.2.0
	crypto-mac-0.10.1
	ct-codecs-1.1.1
	ctr-0.6.0
	curve25519-dalek-3.2.1
	digest-0.9.0
	dnsstamps-0.1.9
	elliptic-curve-0.8.5
	ff-0.8.0
	fnv-1.0.7
	fs_extra-1.2.0
	funty-1.1.0
	futures-0.3.21
	futures-channel-0.3.21
	futures-core-0.3.21
	futures-executor-0.3.21
	futures-io-0.3.21
	futures-macro-0.3.21
	futures-sink-0.3.21
	futures-task-0.3.21
	futures-util-0.3.21
	generic-array-0.14.5
	getrandom-0.2.5
	ghash-0.3.1
	group-0.8.0
	h2-0.3.11
	hashbrown-0.11.2
	hermit-abi-0.1.19
	hkdf-0.10.0
	hmac-0.10.1
	hpke-0.5.1
	http-0.2.6
	http-body-0.4.4
	httparse-1.6.0
	httpdate-1.0.2
	hyper-0.14.17
	indexmap-1.8.0
	itoa-1.0.1
	jemalloc-sys-0.3.2
	jemallocator-0.3.2
	js-sys-0.3.56
	lazy_static-1.4.0
	libc-0.2.119
	lock_api-0.4.6
	log-0.4.14
	memchr-2.4.1
	mio-0.8.0
	miow-0.3.7
	ntapi-0.3.7
	num_cpus-1.13.1
	odoh-rs-1.0.0-alpha.1
	once_cell-1.9.0
	opaque-debug-0.3.0
	p256-0.7.3
	parking_lot-0.12.0
	parking_lot_core-0.9.1
	pin-project-lite-0.2.8
	pin-utils-0.1.0
	poly1305-0.6.2
	polyval-0.4.5
	ppv-lite86-0.2.16
	proc-macro2-1.0.36
	quote-1.0.15
	radium-0.3.0
	rand-0.8.5
	rand_chacha-0.3.1
	rand_core-0.5.1
	rand_core-0.6.3
	redox_syscall-0.2.10
	ring-0.16.20
	rustls-0.19.1
	scopeguard-1.1.0
	sct-0.6.1
	sha2-0.9.9
	slab-0.4.5
	smallvec-1.8.0
	socket2-0.4.4
	spin-0.5.2
	strsim-0.8.0
	subtle-2.4.1
	syn-1.0.86
	synstructure-0.12.6
	textwrap-0.11.0
	thiserror-1.0.30
	thiserror-impl-1.0.30
	tokio-1.17.0
	tokio-rustls-0.22.0
	tokio-util-0.6.9
	tower-service-0.3.1
	tracing-0.1.31
	tracing-core-0.1.22
	try-lock-0.2.3
	typenum-1.15.0
	unicode-width-0.1.9
	unicode-xid-0.2.2
	universal-hash-0.4.1
	untrusted-0.7.1
	vec_map-0.8.2
	version_check-0.9.4
	want-0.3.0
	wasi-0.10.2+wasi-snapshot-preview1
	wasm-bindgen-0.2.79
	wasm-bindgen-backend-0.2.79
	wasm-bindgen-macro-0.2.79
	wasm-bindgen-macro-support-0.2.79
	wasm-bindgen-shared-0.2.79
	web-sys-0.3.56
	webpki-0.21.4
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
	windows-sys-0.32.0
	windows_aarch64_msvc-0.32.0
	windows_i686_gnu-0.32.0
	windows_i686_msvc-0.32.0
	windows_x86_64_gnu-0.32.0
	windows_x86_64_msvc-0.32.0
	wyz-0.2.0
	x25519-dalek-1.2.0
	zeroize-1.3.0
	zeroize_derive-1.3.2
"

inherit cargo systemd

DESCRIPTION="A DNS-over-HTTPS (DoH) and ODoH (Oblivious DoH) proxy"
HOMEPAGE="https://github.com/DNSCrypt/doh-server"
SRC_URI="$(cargo_crate_uris) https://github.com/DNSCrypt/doh-server/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"
LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions BSD BSD-2 ISC MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ssl"

S="${WORKDIR}/doh-server-${PV}"

src_compile() {
	cargo_src_compile --no-default-features \
		$(usex ssl --features=tls "")
}

src_install() {
	cargo_src_install --no-default-features \
		$(usex ssl --features=tls "")

	systemd_dounit "${FILESDIR}"/doh-proxy.service
}
