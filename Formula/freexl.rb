class Freexl < Formula
  desc "Library to extract data from Excel .xls files"
  homepage "https://www.gaia-gis.it/fossil/freexl/index"
  url "https://www.gaia-gis.it/gaia-sins/freexl-sources/freexl-1.0.5.tar.gz"
  sha256 "3dc9b150d218b0e280a3d6a41d93c1e45f4d7155829d75f1e5bf3e0b0de6750d"
  revision 1

  bottle do
    cellar :any
    sha256 "9da7c70cd2106cf1717ca3415243c42873582eb838a5041118c4fca04b7e0886" => :mojave
    sha256 "b8f89ff36ac865e56d050bad7a4eb81c47d38e5b108d6f2f47260fff047df4ed" => :high_sierra
    sha256 "55a1495b30ea8018b334ef30a9511653c212f29af11c34335dc82ddd46a64ab6" => :sierra
    sha256 "a93a9e687fd78a6eb8129896a068f0e982664bf75a06eae236a79fcfbfe0f6ce" => :el_capitan
  end

  depends_on "doxygen" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}",
                          "--disable-silent-rules"

    system "make", "check"
    system "make", "install"

    system "doxygen"
    doc.install "html"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "freexl.h"

      int main()
      {
          printf(freexl_version());
          return 0;
      }
    EOS
    system ENV.cc, "-L#{lib}", "-lfreexl", "test.c", "-o", "test"
    assert_equal version.to_s, shell_output("./test")
  end
end
