class MecabJumandic < Formula
  desc "See mecab"
  homepage "https://taku910.github.io/mecab/"
  url "https://www.mirrorservice.org/sites/distfiles.macports.org/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/macports/distfiles/mecab/mecab-jumandic-7.0-20130310.tar.gz"
  sha256 "eaf216758edee9a159bc3d02507007318686b9537943268c4565cc1f9ef07f15"

  bottle do
    cellar :any_skip_relocation
    sha256 "0331435cdf3fb1af741f835b08990816c2b3e1c1d903a290c400a39e35ec9059" => :sierra
    sha256 "ab65000550be226e608e09e00672d4fc476300da138d68143af75389f8e58231" => :el_capitan
    sha256 "5a9dbc1f67ff36d1f79d6391de2c1d5ab78777322c6e0e829ba4b7a6ab3c88ad" => :yosemite
    sha256 "2d822346c3f44e341ae7b82574dedc1cca41e24e48c45d86fc5f382e26792661" => :mavericks
    sha256 "b61b60c146c415bde98046beecbbf1e7f64c12f072ad2610de6876b93d13a3b0" => :mountain_lion
  end

  # Via ./configure --help, valid choices are utf8 (default), euc-jp, sjis
  option "charset=", "Select charset: utf8 (default), euc-jp, or sjis"

  depends_on "mecab"

  link_overwrite "lib/mecab/dic"

  def install
    charset = ARGV.value("charset") || "utf8"
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-charset=#{charset}
      --with-dicdir=#{lib}/mecab/dic/jumandic
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
     To enable mecab-jumandic dictionary, add to #{HOMEBREW_PREFIX}/etc/mecabrc:
       dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS
  end

  test do
    (testpath/"mecabrc").write <<-EOS.undent
      dicdir = #{HOMEBREW_PREFIX}/lib/mecab/dic/jumandic
    EOS

    pipe_output("mecab --rcfile=#{testpath}/mecabrc", "すもももももももものうち\n", 0)
  end
end
