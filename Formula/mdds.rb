class Mdds < Formula
  desc "Multi-dimensional data structure and indexing algorithm"
  homepage "https://gitlab.com/mdds/mdds"
  url "https://kohei.us/files/mdds/src/mdds-1.4.2.tar.bz2"
  sha256 "82f38750248c007956c38ffefcc549932c8b257b76c72fb79a06eabc50107369"

  bottle do
    cellar :any_skip_relocation
    sha256 "93d86496d4e693f4ea63c77af613af5b0be2b0da6026bb2a9aa7a7a59d32b811" => :mojave
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :high_sierra
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :sierra
    sha256 "2cefe5ebe9c9580d93cdc439a0e3f17ec44e8cc88cd3243317c8e7711544e669" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "boost"
  needs :cxx11

  def install
    # Gets it to work when the CLT is installed
    inreplace "configure.ac", "$CPPFLAGS -I/usr/include -I/usr/local/include",
                              "$CPPFLAGS -I/usr/local/include"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mdds/flat_segment_tree.hpp>
      int main() {
        mdds::flat_segment_tree<unsigned, unsigned> fst(0, 4, 8);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-std=c++11",
                    "-I#{include.children.first}"
    system "./test"
  end
end
