class Parrot < Formula
  desc "Open source virtual machine (for Perl6, et al.)"
  homepage "http://www.parrot.org/"
  head "https://github.com/parrot/parrot.git"

  stable do
    url "ftp://ftp.parrot.org/pub/parrot/releases/supported/8.1.0/parrot-8.1.0.tar.bz2"
    sha256 "caf356acab64f4ea50595a846808e81d0be8ada8267afbbeb66ddb3c93cb81d3"

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/7524bf5384ddebbb3ba06a040f8acf972aa0a3ba.diff"
      sha256 "6322ba2f4dc8acf433f6f3379196b359bedf4e54aa0f7956cb2724529223bce1"
    end

    # remove at 8.2.0, already in HEAD
    patch do
      url "https://github.com/parrot/parrot/commit/854aec65d6de8eaf5282995ab92100a2446f0cde.diff"
      sha256 "3a5874d71672ad3111cc962ffed9b248529f21832c9feae86377a0bd1dc54612"
    end
  end

  bottle do
    sha256 "e8c50fee6a2111412b5f6ac31292f3ff7d3e4dd2be9a02cc94a890026588ae63" => :sierra
    sha256 "3b78be029276ca642cb2bc705888ed0cd7745c0398cf90bf67031190191c76a8" => :el_capitan
    sha256 "37a9ad2396bcf355d6d7ae2d432489e316d3290528947a6f1a30e753fed59902" => :yosemite
    sha256 "ff4125f633f43c19134e2520c0964025f4ea14efd5ce826d0cd905c550fbb24a" => :mavericks
  end

  depends_on "gmp" => :optional
  depends_on "icu4c" => :optional
  depends_on "pcre" => :optional
  depends_on "readline" => :optional
  depends_on "libffi" => :optional

  conflicts_with "rakudo-star"

  def install
    system "perl", "Configure.pl", "--prefix=#{prefix}",
                                   "--mandir=#{man}",
                                   "--debugging=0",
                                   "--cc=#{ENV.cc}"

    system "make"
    system "make", "install"
    # Don't install this file in HOMEBREW_PREFIX/lib
    rm_rf lib/"VERSION"
  end

  test do
    path = testpath/"test.pir"
    path.write <<-EOS.undent
      .sub _main
        .local int i
        i = 0
      loop:
        print i
        inc i
        if i < 10 goto loop
      .end
    EOS

    out = `#{bin}/parrot #{path}`
    assert_equal "0123456789", out
    assert_equal 0, $?.exitstatus
  end
end
