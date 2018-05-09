class Mpfi < Formula
  desc "Multiple precision interval arithmetic library"
  homepage "https://perso.ens-lyon.fr/nathalie.revol/software.html"
  url "https://gforge.inria.fr/frs/download.php/file/37331/mpfi-1.5.3.tar.bz2"
  sha256 "2383d457b208c6cd3cf2e66b69c4ce47477b2a0db31fbec0cd4b1ebaa247192f"

  bottle do
    cellar :any
    sha256 "e829d1293ff9101516234d9c8d60f05a948da004f684baaa5c8bd9d591aa6156" => :high_sierra
    sha256 "ee2d9a5b676f12ea283b660f45abf572ca84440ec9b497f4b481a605ba07b209" => :sierra
    sha256 "02631fb35a90f64746031700c51f42dfb67a43206754d1f56196360ed8208f4e" => :el_capitan
  end

  depends_on "gmp"
  depends_on "mpfr"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mpfi.h>

      int main()
      {
        mpfi_t x;
        mpfi_init(x);
        mpfi_clear(x);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lgmp", "-lmpfr", "-L#{lib}", "-lmpfi",
                   "-o", "test"
    system "./test"
  end
end
