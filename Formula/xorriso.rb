class Xorriso < Formula
  desc "ISO9660+RR manipulation tool"
  homepage "https://www.gnu.org/software/xorriso/"
  url "https://ftpmirror.gnu.org/xorriso/xorriso-1.4.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/xorriso/xorriso-1.4.6.tar.gz"
  sha256 "526f728c7eee6f8c4b69fbf391789e6c80806197c2861cf5922cf7cfe1035784"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f3ba6bccfafa627081d6451066f825b7e2bceeac4268a13941e7f5628d08dff" => :el_capitan
    sha256 "0fae01430d1912f75b6a9283cbaa4a279cbdf8f81b5b67342fd62f67fddf1a55" => :yosemite
    sha256 "7bfcd73adc264d44efe7e5dd1cf21e761e5816ff308e5100da62bdba0029a321" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    # `make install` has to be deparallelized due to the following error:
    #   mkdir: /usr/local/Cellar/xorriso/1.4.2/bin: File exists
    #   make[1]: *** [install-binPROGRAMS] Error 1
    # Reported 14 Jun 2016: https://lists.gnu.org/archive/html/bug-xorriso/2016-06/msg00003.html
    ENV.deparallelize { system "make", "install" }
  end

  test do
    system bin/"xorriso", "--help"
  end
end
