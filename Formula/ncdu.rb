class Ncdu < Formula
  desc "NCurses Disk Usage"
  homepage "https://dev.yorhel.nl/ncdu"
  url "https://dev.yorhel.nl/download/ncdu-1.12.tar.gz"
  sha256 "820e4e4747a2a2ec7a2e9f06d2f5a353516362c22496a10a9834f871b877499a"

  bottle do
    cellar :any_skip_relocation
    revision 2
    sha256 "ccdf04c469320f67a9b19f240902a76ef350587b7bc52a1fdb0c4a13636affc1" => :el_capitan
    sha256 "abfa7e3ab47bfc423f2178729da2cdd23829e607d57d65cbea06f3aee3fadfde" => :yosemite
    sha256 "7ca1ce83f4ae26eab147bb141541f9452ef029e0b28b57dc91a448ed7ff5dce4" => :mavericks
  end

  head do
    url "https://g.blicky.net/ncdu.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncdu -v")
  end
end
