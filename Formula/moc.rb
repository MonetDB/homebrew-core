class Moc < Formula
  desc "Terminal-based music player"
  homepage "https://moc.daper.net/"
  revision 4

  stable do
    url "http://ftp.daper.net/pub/soft/moc/stable/moc-2.5.2.tar.bz2"
    sha256 "f3a68115602a4788b7cfa9bbe9397a9d5e24c68cb61a57695d1c2c3ecf49db08"

    # Remove for > 2.5.2; FFmpeg 4.0 compatibility
    # 01 to 05 below are backported from patches provided 26 Apr 2018 by
    # upstream's John Fitzgerald
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/01-codec-2.5.2.patch"
      sha256 "c6144dbbd85e3b775e3f03e83b0f90457450926583d4511fe32b7d655fdaf4eb"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/02-codecpar-2.5.2.patch"
      sha256 "5ee71f762500e68a6ccce84fb9b9a4876e89e7d234a851552290b42c4a35e930"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/03-defines-2.5.2.patch"
      sha256 "2ecfb9afbbfef9bd6f235bf1693d3e94943cf1402c4350f3681195e1fbb3d661"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/04-lockmgr-2.5.2.patch"
      sha256 "9ccfad2f98abb6f974fe6dc4c95d0dc9a754a490c3a87d3bd81082fc5e5f42dc"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/05-audio4-2.5.2.patch"
      sha256 "9a75ac8479ed895d07725ac9b7d86ceb6c8a1a15ee942c35eb5365f4c3cc7075"
    end
  end

  bottle do
    sha256 "a536689c04be421cd2d55851d32b460a888188adb5bea42fcbb57db465e6c87c" => :high_sierra
    sha256 "c5b44244ca3421ea8eb867f5bffde2be4823d335a960047d1246a8295807ebf9" => :sierra
    sha256 "6286eeb3b7ca9500ae5ab3c795dcf3ca94fa8440141ccd02ae7fd0107d3950f4" => :el_capitan
  end

  devel do
    url "http://ftp.daper.net/pub/soft/moc/unstable/moc-2.6-alpha3.tar.xz"
    sha256 "a27b8888984cf8dbcd758584961529ddf48c237caa9b40b67423fbfbb88323b1"

    # Patch for clock_gettime issue
    # https://moc.daper.net/node/1576
    patch do
      url "https://raw.githubusercontent.com/Homebrew/patches/78d5908905c6848bb75ae41b70d6bbb46abaa69b/moc/r2936-clock_gettime.patch"
      sha256 "601b5cdf59db67f180f1aaa6cc90804c1cb69c44cdecb2e8149338782e4f21a8"
    end

    depends_on "popt"

    # Remove for > 2.6-alpha3; FFmpeg 4.0 compatibility
    # 01 to 05 below provided 26 Apr 2018 by upstream's John Fitzgerald
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/01-codec.patch"
      sha256 "c424fcfff8f318896c868ae2e019120b78857f6ef1ccf1000df92fbe571d1f69"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/02-codecpar.patch"
      sha256 "4bcc745a484c3ffd4c5cf169fd299b6ab18d387740f77d9cc9eec3f57f5fcf7c"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/03-defines.patch"
      sha256 "088596c51f47d5b4a47fb00def2a832536cba2cdb6bb4dc767af5f2edb33164e"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/04-lockmgr.patch"
      sha256 "a83d86ac4f0d88afddd0d76516b95071e4b876d51f85ee2c876be9c6f7ce6cc9"
    end

    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/514941c/moc/05-audio4.patch"
      sha256 "05d467cc7b1f9529187d0fcf5375ccb2088a606fd5ecd75a8330b8f68676eefc"
    end
  end

  head do
    url "svn://daper.net/moc/trunk"

    depends_on "popt"
  end

  # Remove autoconf, automake and gettext when > 2.5.2 and > 2.6-alpha3 come out
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "ffmpeg"
  depends_on "jack"
  depends_on "libtool"
  depends_on "ncurses"

  def install
    # Not needed for stable or devel when > 2.5.2 and > 2.6-alpha3 come out
    system "autoreconf", "-fvi"
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You must start the jack daemon prior to running mocp.
      If you need wide-character support in the player, for example
      with Chinese characters, you can install using
          --with-ncurses
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mocp --version")
  end
end
