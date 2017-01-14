class Coturn < Formula
  desc "Free open source implementation of TURN and STUN Server"
  homepage "https://github.com/coturn/coturn"
  url "http://turnserver.open-sys.org/downloads/v4.5.0.5/turnserver-4.5.0.5.tar.gz"
  sha256 "8484fa6c8d4aab43e1161c02eb8914154a21178b05f8a285e04094ddbb64acf4"

  bottle do
    sha256 "3ec67aacf4536096ff1cc665acf57c60b4d3d190793fcf8462322a6f04fdfb31" => :sierra
    sha256 "e507dc45808beec2df07e3f5baf4654352055e5727737a9566ee83f27a4e5511" => :el_capitan
    sha256 "4a50aa412246808347c3a55365133a8008fcb4cd8913b6d1e124f88461cc8ade" => :yosemite
    sha256 "4ca3c04260270db265b7bad120bed3aebd0bcc60340c20e7db5ee4ebb271a118" => :mavericks
  end

  depends_on "libevent"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "#{bin}/turnadmin", "-l"
  end
end
