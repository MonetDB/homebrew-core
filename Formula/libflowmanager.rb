class Libflowmanager < Formula
  desc "Flow-based measurement tasks with packet-based inputs"
  homepage "https://research.wand.net.nz/software/libflowmanager.php"
  url "https://research.wand.net.nz/software/libflowmanager/libflowmanager-3.0.0.tar.gz"
  sha256 "0866adfcdc223426ba17d6133a657d94928b4f8e12392533a27387b982178373"

  bottle do
    cellar :any
    sha256 "456098a2fa42176dd28c40be96b857569ed0b674e2b789f3f532f5c446e1494b" => :sierra
    sha256 "21d694144204f4067bea98e9d9c9f6919febe32c162dd6c309bf3efb7323ce24" => :el_capitan
    sha256 "8bd1c6137570f83f81bde7a0efc28d7521c4102086c8c721cd9ad7ff5f8c8ab8" => :yosemite
  end

  depends_on "libtrace"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
