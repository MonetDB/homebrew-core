class Openconnect < Formula
  desc "Open client for Cisco AnyConnect VPN"
  homepage "https://www.infradead.org/openconnect/"
  url "ftp://ftp.infradead.org/pub/openconnect/openconnect-8.02.tar.gz"
  mirror "https://fossies.org/linux/privat/openconnect-8.02.tar.gz"
  sha256 "1ca8f2c279f12609bf061db78b51e5f913b3bce603a0d4203230a413d8dfe012"
  revision 1

  bottle do
    sha256 "53521355595b9b5ad7c67c5d37ea772eb4e8a47131e4431e95ae1473bacc70f2" => :mojave
    sha256 "54aa04eb941ed606b81340e16b2ea50d53f7adb9be2df3bd4e309bdc6b34a400" => :high_sierra
    sha256 "25cdd4355fa850a16dfd16498f1034b9bd6f8a8b753727fa9401a7d88934a2fc" => :sierra
  end

  head do
    url "git://git.infradead.org/users/dwmw2/openconnect.git", :shallow => false
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "stoken"

  resource "vpnc-script" do
    url "http://git.infradead.org/users/dwmw2/vpnc-scripts.git/blob_plain/1000e0f6dd7d6bff163169a46359211c1fc3a6d2:/vpnc-script"
    sha256 "5b2f23f2a4e585537118957218579b411e65c9dbddffbcabd0cc63b5a46bddd4"
  end

  def install
    etc.install resource("vpnc-script")
    chmod 0755, "#{etc}/vpnc-script"

    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --sbindir=#{bin}
      --localstatedir=#{var}
      --with-vpnc-script=#{etc}/vpnc-script
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match "Open client for multiple VPN protocols", pipe_output("#{bin}/openconnect 2>&1")
  end
end
