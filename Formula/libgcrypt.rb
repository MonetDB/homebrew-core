class Libgcrypt < Formula
  desc "Cryptographic library based on the code from GnuPG"
  homepage "https://directory.fsf.org/wiki/Libgcrypt"
  url "https://gnupg.org/ftp/gcrypt/libgcrypt/libgcrypt-1.7.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.7.4.tar.bz2"
  sha256 "3b67862e2f4711e25c4ce3cc4b48d52a58a3afdcd1d8c6a57f93a1c0ef03e5c6"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e7c80b73a6f1cc25ace8c581eaede93e069f1c5ae3c83275fb6ae3f5031d7bcd" => :sierra
    sha256 "af9419bfc33e847b7c3e47e2c7cf44daef081e534e631001a56169aa5e538cc6" => :el_capitan
    sha256 "6c838cfadd82115e2e5efcc1f8109e3b7a1f2f5f37d63bf00d70e72dda60689d" => :yosemite
    sha256 "b2e8b5cc88d5041f6d4f19c7edfee8439fb1669908804ba7bd55202c8e4bcc42" => :mavericks
  end

  option :universal

  depends_on "libgpg-error"

  resource "config.h.ed" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/ec8d133/libgcrypt/config.h.ed"
    version "113198"
    sha256 "d02340651b18090f3df9eed47a4d84bed703103131378e1e493c26d7d0c7aab1"
  end

  def install
    # Temporary hack to get libgcrypt building on macOS 10.12 and 10.11 with XCode 8.
    # Seems to be a Clang issue rather than an upstream one, so
    # keep checking whether or not this is necessary.
    # Should be reported to GnuPG if still an issue when near stable.
    # https://github.com/Homebrew/homebrew-core/issues/1957
    ENV.O1 if DevelopmentTools.clang_build_version >= 800

    ENV.universal_binary if build.universal?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}"

    if build.universal?
      buildpath.install resource("config.h.ed")
      system "ed -s - config.h <config.h.ed"
    end

    # Parallel builds work, but only when run as separate steps
    system "make"
    # Slightly hideous hack to help `make check` work in
    # normal place on >10.10 where SIP is enabled.
    # https://github.com/Homebrew/homebrew-core/pull/3004
    # https://bugs.gnupg.org/gnupg/issue2056
    system "install_name_tool", "-change",
                                lib/"libgcrypt.20.dylib",
                                buildpath/"src/.libs/libgcrypt.20.dylib",
                                buildpath/"tests/.libs/random"
    system "make", "check"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"libgcrypt-config", prefix, opt_prefix
  end

  test do
    touch "testing"
    output = shell_output("#{bin}/hmac256 \"testing\" testing")
    assert_match "0e824ce7c056c82ba63cc40cffa60d3195b5bb5feccc999a47724cc19211aef6", output
  end
end
