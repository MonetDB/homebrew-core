class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"

  head "http://git.savannah.gnu.org/r/bash.git"

  stable do
    url "https://ftpmirror.gnu.org/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.4.tar.gz"
    mirror "https://gnu.cu.be/bash/bash-4.4.tar.gz"
    mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4.tar.gz"
    sha256 "d86b3392c1202e8ff5a423b302e6284db7f8f435ea9f39b5b1b20fd3ac36dfcb"
    version "4.4.5"

    %w[
      001 3e28d91531752df9a8cb167ad07cc542abaf944de9353fe8c6a535c9f1f17f0f
      002 7020a0183e17a7233e665b979c78c184ea369cfaf3e8b4b11f5547ecb7c13c53
      003 51df5a9192fdefe0ddca4bdf290932f74be03ffd0503a3d112e4199905e718b2
      004 ad080a30a4ac6c1273373617f29628cc320a35c8cd06913894794293dc52c8b3
      005 221e4b725b770ad0bb6924df3f8d04f89eeca4558f6e4c777dfa93e967090529
    ].each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftpmirror.gnu.org/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://ftp.gnu.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://gnu.cu.be/bash/bash-4.4-patches/bash44-#{p}"
        mirror "https://mirror.unicorncloud.org/gnu/bash/bash-4.4-patches/bash44-#{p}"
        sha256 checksum
      end
    end
  end

  bottle do
    sha256 "a2f73335f36d0a35970b1ee2b41e4a6b939ffd9df2a3ee9e9ebb942765d10002" => :sierra
    sha256 "9f11130718619dd0523760d714c8ac349fd62cc0b11dc70671ff132e7fc94ef5" => :el_capitan
    sha256 "af85e62012466dbb9ec9e08fe59acb03aff35f2d41844d2871c80bbd5a9e6ac3" => :yosemite
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end
