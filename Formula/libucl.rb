class Libucl < Formula
  desc "Universal configuration library parser"
  homepage "https://github.com/vstakhov/libucl"
  url "https://github.com/vstakhov/libucl/archive/0.8.1.tar.gz"
  sha256 "a6397e179672f0e8171a0f9a2cfc37e01432b357fd748b13f4394436689d24ef"

  bottle do
    cellar :any
    rebuild 1
    sha256 "40f1428ba50ea5cc8342a851bdf2a2d18504ec9c76ef44ec79165d97d37e15fd" => :high_sierra
    sha256 "bb8581d850dcdbbca18612371aaef23cd4e9d0948ae22a3ad35dda94f69b5874" => :sierra
    sha256 "f505e0d68fbcb0cd33ffbd71ea2e14aea67742c44cd665810cf11447723d91d7" => :el_capitan
    sha256 "d2132009336951013a66d39bf84f49e1b6a167705bfa6006fbdadd223a5ddcb5" => :yosemite
    sha256 "5f5396fc96e31d5114f8b8f708805a13c9781b96ca530445f0e7e80f3623e6b6" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "lua" => :optional

  def install
    system "./autogen.sh"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]
    args << "--enable-lua" if build.with? "lua"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <ucl++.h>
      #include <string>
      #include <cassert>

      int main(int argc, char **argv) {
        const std::string cfg = "foo = bar; section { flag = true; }";
        std::string err;
        auto obj = ucl::Ucl::parse(cfg, err);
        assert(obj);
        assert(obj[std::string("foo")].string_value() == "bar");
        assert(obj[std::string("section")][std::string("flag")].bool_value());
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lucl", "-o", "test"
    system "./test"
  end
end
