class Mysql < Formula
  desc "Open source relational database management system"
  homepage "https://dev.mysql.com/doc/refman/5.7/en/"
  url "https://cdn.mysql.com/Downloads/MySQL-5.7/mysql-boost-5.7.20.tar.gz"
  sha256 "260582844ac18222ce2826f48b6c7ca387990b19ddb88331af26738b394e42a4"

  bottle do
    sha256 "a2e6118b43021c5644a5972551a2b504529146d0f3586f2060bab00c40738586" => :high_sierra
    sha256 "00db29d31d78c659c573b5d4746a1237630d69cce66f2d61c14689948374ec68" => :sierra
    sha256 "016deb20192b24bfdb8011918941da4b9752a5237fbeec4b29568e8dd1417189" => :el_capitan
  end

  devel do
    url "https://cdn.mysql.com/Downloads/MySQL-8.0/mysql-boost-8.0.3-rc.tar.gz"
    sha256 "bc6ef8e496447edde87da243db56682d44c8344e5695c3f265b3316b3a8aa56f"

    fails_with :clang do
      build 800
      cause "Wrong inlining with Clang 8.0, see MySQL Bug #86711"
    end
    # GCC is not supported either, so exclude for El Capitan.
    depends_on :macos => :sierra if DevelopmentTools.clang_build_version == 800
  end

  option "with-test", "Build with unit tests"
  option "with-embedded", "Build the embedded server"
  option "with-archive-storage-engine", "Compile with the ARCHIVE storage engine enabled"
  option "with-blackhole-storage-engine", "Compile with the BLACKHOLE storage engine enabled"
  option "with-local-infile", "Build with local infile loading support"
  option "with-debug", "Build with debug support"

  deprecated_option "enable-local-infile" => "with-local-infile"
  deprecated_option "enable-debug" => "with-debug"
  deprecated_option "with-tests" => "with-test"

  depends_on "cmake" => :build
  depends_on "pidof" unless MacOS.version >= :mountain_lion
  depends_on "openssl"

  # https://github.com/Homebrew/homebrew-core/issues/1475
  # Needs at least Clang 3.3, which shipped alongside Lion.
  # Note: MySQL themselves don't support anything below El Capitan.
  depends_on :macos => :lion

  conflicts_with "mysql-cluster", "mariadb", "percona-server",
    :because => "mysql, mariadb, and percona install the same binaries."
  conflicts_with "mysql-connector-c",
    :because => "both install MySQL client libraries"
  conflicts_with "mariadb-connector-c",
    :because => "both install plugins"

  def datadir
    var/"mysql"
  end

  def install
    # Don't hard-code the libtool path. See:
    # https://github.com/Homebrew/legacy-homebrew/issues/20185
    inreplace "cmake/libutils.cmake",
      "COMMAND /usr/bin/libtool -static -o ${TARGET_LOCATION}",
      "COMMAND libtool -static -o ${TARGET_LOCATION}"

    # -DINSTALL_* are relative to `CMAKE_INSTALL_PREFIX` (`prefix`)
    args = %W[
      -DMYSQL_DATADIR=#{datadir}
      -DINSTALL_INCLUDEDIR=include/mysql
      -DINSTALL_MANDIR=share/man
      -DINSTALL_DOCDIR=share/doc/#{name}
      -DINSTALL_INFODIR=share/info
      -DINSTALL_MYSQLSHAREDIR=share/mysql
      -DWITH_SSL=system
      -DDEFAULT_CHARSET=utf8
      -DDEFAULT_COLLATION=utf8_general_ci
      -DSYSCONFDIR=#{etc}
      -DCOMPILATION_COMMENT=Homebrew
      -DWITH_EDITLINE=system
      -DWITH_BOOST=boost
    ]

    # To enable unit testing at build, we need to download the unit testing suite
    if build.with? "test"
      args << "-DENABLE_DOWNLOADS=ON"
    else
      args << "-DWITH_UNIT_TESTS=OFF"
    end

    # Build the embedded server
    args << "-DWITH_EMBEDDED_SERVER=ON" if build.with? "embedded"

    # Compile with ARCHIVE engine enabled if chosen
    args << "-DWITH_ARCHIVE_STORAGE_ENGINE=1" if build.with? "archive-storage-engine"

    # Compile with BLACKHOLE engine enabled if chosen
    args << "-DWITH_BLACKHOLE_STORAGE_ENGINE=1" if build.with? "blackhole-storage-engine"

    # Build with local infile loading support
    args << "-DENABLED_LOCAL_INFILE=1" if build.with? "local-infile"

    # Build with debug support
    args << "-DWITH_DEBUG=1" if build.with? "debug"

    system "cmake", ".", *std_cmake_args, *args
    system "make"
    system "make", "install"

    # We don't want to keep a 240MB+ folder around most users won't need.
    (prefix/"mysql-test").cd do
      system "./mysql-test-run.pl", "status", "--vardir=#{Dir.mktmpdir}"
    end
    rm_rf prefix/"mysql-test"

    # Don't create databases inside of the prefix!
    # See: https://github.com/Homebrew/homebrew/issues/4975
    rm_rf prefix/"data"

    # Perl script was removed in 5.7.9 so install C++ binary instead.
    # Binary is deprecated & will be removed in future upstream
    # update but is still required for mysql-test-run to pass in test.
    if build.stable?
      (prefix/"scripts").install "client/mysql_install_db"
      bin.install_symlink prefix/"scripts/mysql_install_db"
    end

    # Fix up the control script and link into bin.
    inreplace "#{prefix}/support-files/mysql.server",
              /^(PATH=".*)(")/,
              "\\1:#{HOMEBREW_PREFIX}/bin\\2"
    bin.install_symlink prefix/"support-files/mysql.server"

    # Install my.cnf that binds to 127.0.0.1 by default
    (buildpath/"my.cnf").write <<~EOS
      # Default Homebrew MySQL server config
      [mysqld]
      # Only allow connections from localhost
      bind-address = 127.0.0.1
    EOS
    etc.install "my.cnf"
  end

  def post_install
    # Make sure the datadir exists
    datadir.mkpath
    unless (datadir/"mysql/user.frm").exist?
      ENV["TMPDIR"] = nil
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
        "--basedir=#{prefix}", "--datadir=#{datadir}", "--tmpdir=/tmp"
    end
  end

  def caveats
    s = <<~EOS
      We've installed your MySQL database without a root password. To secure it run:
          mysql_secure_installation

      MySQL is configured to only allow connections from localhost by default

      To connect run:
          mysql -uroot
    EOS
    if my_cnf = ["/etc/my.cnf", "/etc/mysql/my.cnf"].find { |x| File.exist? x }
      s += <<~EOS

        A "#{my_cnf}" from another install may interfere with a Homebrew-built
        server starting up correctly.
      EOS
    end
    s
  end

  plist_options :manual => "mysql.server start"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/mysqld_safe</string>
        <string>--datadir=#{datadir}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{datadir}</string>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      # Expects datadir to be a completely clean dir, which testpath isn't.
      dir = Dir.mktmpdir
      system bin/"mysqld", "--initialize-insecure", "--user=#{ENV["USER"]}",
      "--basedir=#{prefix}", "--datadir=#{dir}", "--tmpdir=#{dir}"

      pid = fork do
        exec bin/"mysqld", "--bind-address=127.0.0.1", "--datadir=#{dir}"
      end
      sleep 2

      output = shell_output("curl 127.0.0.1:3306")
      output.force_encoding("ASCII-8BIT") if output.respond_to?(:force_encoding)
      assert_match version.to_s, output
    ensure
      Process.kill(9, pid)
      Process.wait(pid)
    end
  end
end
