class Tinyproxy < Formula
  desc "HTTP/HTTPS proxy for POSIX systems"
  homepage "https://www.banu.com/tinyproxy/"
  url "https://github.com/tinyproxy/tinyproxy/releases/download/1.8.4/tinyproxy-1.8.4.tar.xz"
  sha256 "a41f4ddf0243fc517469cf444c8400e1d2edc909794acda7839f1d644e8a5000"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "73ad83b43d81259d0251e5c33a3f35a8200059f01421084054472b5ad96a1240" => :sierra
    sha256 "004c6319701e7529b252e1860321cf14369a74029a6f05523662365ff1292f1b" => :el_capitan
    sha256 "b68a1b323a20f689b96e7405f2c491c66849fa011beb450dcf417be491557da4" => :yosemite
    sha256 "7bba647101259e9299a8a61177fcba2966b056091e9b1a28a43207e612a0bcfc" => :mavericks
  end

  depends_on "asciidoc" => :build

  option "with-reverse", "Enable reverse proxying"
  option "with-transparent", "Enable transparent proxying"
  option "with-filter", "Enable url filtering"

  deprecated_option "reverse" => "with-reverse"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --disable-regexcheck
    ]

    args << "--enable-reverse" if build.with? "reverse"
    args << "--enable-transparent" if build.with? "transparent"
    args << "--enable-filter" if build.with? "filter"

    system "./configure", *args

    # Fix broken XML lint
    # See: https://bugs.freebsd.org/bugzilla/show_bug.cgi?id=154624
    inreplace %w[docs/man5/Makefile docs/man8/Makefile], "-f manpage",
                                                         "-f manpage \\\n  -L"

    system "make", "install"
  end

  def post_install
    (var/"log/tinyproxy").mkpath
    (var/"run/tinyproxy").mkpath
  end

  test do
    pid = fork do
      exec "#{sbin}/tinyproxy"
    end
    sleep 2

    begin
      assert_match /tinyproxy/, shell_output("curl localhost:8888")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end

  plist_options :manual => "tinyproxy"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/tinyproxy</string>
            <string>-d</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
