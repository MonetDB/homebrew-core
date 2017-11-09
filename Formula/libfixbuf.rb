class Libfixbuf < Formula
  desc "Implements the IPFIX Protocol as a C library"
  homepage "https://tools.netsa.cert.org/fixbuf/"
  url "https://tools.netsa.cert.org/releases/libfixbuf-1.8.0.tar.gz"
  sha256 "c0a3b4f99916c7124b1964b273fc3a1969e34228633f68a1a9615f2b420236ce"

  bottle do
    cellar :any
    sha256 "69feffdd0ed493ae68a568d51f1fae6644d2c89a4b8bd766dfb130092afd8765" => :high_sierra
    sha256 "3d6014e37bac0a264e32a8210decbe6dcfa8e8c8512591d401b041e6483833c6" => :sierra
    sha256 "25f95e58cbb615835cf32e623319a1d6688f64af9547520f76008eb13f500a71" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end
end
