class Sqlite < Formula
  desc "Command-line interface for SQLite"
  homepage "https://sqlite.org/"
  url "https://sqlite.org/2018/sqlite-autoconf-3260000.tar.gz"
  version "3.26.0"
  sha256 "5daa6a3fb7d1e8c767cd59c4ded8da6e4b00c61d3b466d0685e35c4dd6d7bf5d"
  revision 1

  bottle do
    cellar :any
    sha256 "950736ef2a17d92518538ef97f985019509332e0b7717667fb521c8ec2cadc8b" => :mojave
    sha256 "5301650f025a5802d806f62079a01282446dbb6e91cb4cac567633cfa22c7b5a" => :high_sierra
    sha256 "4e30d34e63ead32ee747323c60f0c4bf24b97d326112d4bd386d70fbb72fdd77" => :sierra
  end

  keg_only :provided_by_macos, "macOS provides an older sqlite3"

  depends_on "readline"

  def install
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_COLUMN_METADATA=1"
    # Default value of MAX_VARIABLE_NUMBER is 999 which is too low for many
    # applications. Set to 250000 (Same value used in Debian and Ubuntu).
    ENV.append "CPPFLAGS", "-DSQLITE_MAX_VARIABLE_NUMBER=250000"
    ENV.append "CPPFLAGS", "-DSQLITE_ENABLE_RTREE=1"

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-dynamic-extensions
      --enable-readline
      --disable-editline
    ]

    system "./configure", *args
    system "make", "install"
  end

  def caveats
    s = ""
    user_history = "~/.sqlite_history"
    user_history_path = File.expand_path(user_history)
    if File.exist?(user_history_path) && File.read(user_history_path).include?("\\040")
      s += <<~EOS
        Homebrew has detected an existing SQLite history file that was created
        with the editline library. The current version of this formula is
        built with Readline. To back up and convert your history file so that
        it can be used with Readline, run:

          sed -i~ 's/\\\\040/ /g' #{user_history}

        before using the `sqlite` command-line tool again. Otherwise, your
        history will be lost.
      EOS
    end
    s
  end

  test do
    path = testpath/"school.sql"
    path.write <<~EOS
      create table students (name text, age integer);
      insert into students (name, age) values ('Bob', 14);
      insert into students (name, age) values ('Sue', 12);
      insert into students (name, age) values ('Tim', 13);
      select name from students order by age asc;
    EOS

    names = shell_output("#{bin}/sqlite3 < #{path}").strip.split("\n")
    assert_equal %w[Sue Tim Bob], names
  end
end
