class Gnupg < Formula
  desc "GNU Pretty Good Privacy (PGP) package"
  homepage "https://gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.2.5.tar.bz2"
  sha256 "3fa189a32d4fb62147874eb1389047c267d9ba088f57ab521cb0df46f08aef57"

  bottle do
    sha256 "0a39a50f6c360bdc7f8134c64cf25cf69cca7ce1ba4e184f2d28849dfe44eb67" => :high_sierra
    sha256 "8c49055d7612b56f2923a1a926411eecd6d2b51881cce7120c922093414cf417" => :sierra
    sha256 "9eeca76a0a1bc6ef935dfccd751a7250cf5f8a42cfa35ce2e6628088e40e34d5" => :el_capitan
  end

  option "with-gpgsplit", "Additionally install the gpgsplit utility"
  option "with-gpg-zip", "Additionally install the gpg-zip utility"
  option "with-large-secmem", "Additionally allocate extra secure memory"
  option "without-libusb", "Disable the internal CCID driver"

  deprecated_option "without-libusb-compat" => "without-libusb"

  depends_on "pkg-config" => :build
  depends_on "sqlite" => :build if MacOS.version == :mavericks
  depends_on "npth"
  depends_on "gnutls"
  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pinentry"
  depends_on "gettext"
  depends_on "adns"
  depends_on "libusb" => :recommended
  depends_on "readline" => :optional
  depends_on "encfs" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sbindir=#{bin}
      --sysconfdir=#{etc}
      --enable-symcryptrun
      --with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry
      --enable-all-tests
    ]

    args << "--disable-ccid-driver" if build.without? "libusb"
    args << "--with-readline=#{Formula["readline"].opt_prefix}" if build.with? "readline"
    args << "--enable-large-secmem" if build.with? "large-secmem"

    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    bin.install "tools/gpgsplit" if build.with? "gpgsplit"
    bin.install "tools/gpg-zip" if build.with? "gpg-zip"
  end

  def post_install
    (var/"run").mkpath
    quiet_system "killall", "gpg-agent"
  end

  def caveats; <<~EOS
    Once you run this version of gpg you may find it difficult to return to using
    a prior 1.4.x or 2.0.x. Most notably the prior versions will not automatically
    know about new secret keys created or imported by this version. We recommend
    creating a backup of your `~/.gnupg` prior to first use.

    For full details on each change and how it could impact you please see
      https://www.gnupg.org/faq/whats-new-in-2.1.html
    EOS
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system bin/"gpg", "--batch", "--gen-key", "batch.gpg"
      (testpath/"test.txt").write "Hello World!"
      system bin/"gpg", "--detach-sign", "test.txt"
      system bin/"gpg", "--verify", "test.txt.sig"
    ensure
      system bin/"gpgconf", "--kill", "gpg-agent"
    end
  end
end
