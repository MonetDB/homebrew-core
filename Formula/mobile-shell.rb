class MobileShell < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://mosh.org/mosh-1.2.6.tar.gz"
  sha256 "7e82b7fbfcc698c70f5843bb960dadb8e7bd7ac1d4d2151c9d979372ea850e85"
  revision 4

  bottle do
    sha256 "bc1a1ce96af199e577ee7eecd75688f43aaa6bddec09a7973c487f8d4233e60f" => :sierra
    sha256 "73f0c2c60aae22d886f44421034fe1e43e2c643dba10913026d9f2935b3c0ddc" => :el_capitan
    sha256 "0d4e77bc71d3413788995fc3029ae29df2789ef6eed7871862a823ffeee7f12d" => :yosemite
  end

  devel do
    url "https://github.com/mobile-shell/mosh/releases/download/mosh-1.3.0-rc2/mosh-1.3.0-rc2.tar.gz"
    sha256 "8b6bff33c469ccea0438877c68774a6b2ded6fccd99b1db180222da82f0654ae"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", :shallow => false

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-test", "Run build-time tests"

  deprecated_option "without-check" => "without-test"

  depends_on "pkg-config" => :build
  depends_on "protobuf"
  depends_on :perl => "5.14" if MacOS.version <= :mountain_lion
  depends_on "tmux" => :build if build.with?("test") || build.bottle?

  def install
    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "\'#{bin}/mosh-client"

    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}", "--enable-completion"
    system "make", "check" if build.with?("test") || build.bottle?
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end
