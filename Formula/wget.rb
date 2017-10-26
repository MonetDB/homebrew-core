class Wget < Formula
  desc "Internet file retriever"
  homepage "https://www.gnu.org/software/wget/"
  url "https://ftp.gnu.org/gnu/wget/wget-1.19.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/wget/wget-1.19.2.tar.gz"
  sha256 "4f4a673b6d466efa50fbfba796bd84a46ae24e370fa562ede5b21ab53c11a920"

  bottle do
    sha256 "f0b01475fa8fb7f99b7e5e75f7c06e99a609cd9a3f11b62c10f4c76a9f46dbff" => :high_sierra
    sha256 "fe0679b932dd43a87fd415b609a7fbac7a069d117642ae8ebaac46ae1fb9f0b3" => :sierra
    sha256 "a4d259460edf940de5c780e8461c23e3bced288e2ef2532bd1707a086f9842b9" => :el_capitan
    sha256 "61b3eab1439b8dfaed1f18dbd6e8d0ad87d15b9864677e62f3618cc02600064a" => :yosemite
  end

  head do
    url "https://git.savannah.gnu.org/git/wget.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xz" => :build
    depends_on "gettext"
  end

  deprecated_option "enable-debug" => "with-debug"

  option "with-debug", "Build with debug support"

  depends_on "pkg-config" => :build
  depends_on "pod2man" => :build if MacOS.version <= :snow_leopard
  depends_on "openssl@1.1"
  depends_on "pcre" => :optional
  depends_on "libmetalink" => :optional
  depends_on "gpgme" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-ssl=openssl
      --with-libssl-prefix=#{Formula["openssl@1.1"].opt_prefix}
    ]

    args << "--disable-debug" if build.without? "debug"
    args << "--disable-pcre" if build.without? "pcre"
    args << "--with-metalink" if build.with? "libmetalink"
    args << "--with-gpgme-prefix=#{Formula["gpgme"].opt_prefix}" if build.with? "gpgme"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system bin/"wget", "-O", "/dev/null", "https://google.com"
  end
end
