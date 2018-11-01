class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.io/"
  url "https://etsh.io/src/etsh-5.2.0.tar.gz"
  sha256 "af561b7fa2f9eb872e2e5a71a8f8e5479f8bb5829a8ec1534f0240475c3dfe5e"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "4b842c0110ddaab3be2ef7cc8c647c9db93ea5817d0dbaa6c0b0968ad910fb5f" => :mojave
    sha256 "ec0708f30a6445068f2664b4de4842129b1eb16c86913937d4af97b678499455" => :high_sierra
    sha256 "96e06d7b7f24c5bf57d485d301bdb2624c2e24fd5f221ee6a07a284447d9a6e3" => :sierra
    sha256 "1cd1038356285388b1cc258188fd04ac4d643713b888192a83f7bb89d2247010" => :el_capitan
  end

  conflicts_with "teleport", :because => "both install `tsh` binaries"

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"
    bin.install_symlink "etsh" => "osh"
    bin.install_symlink "tsh" => "sh6"
  end

  test do
    assert_match "brew!", shell_output("#{bin}/etsh -c 'echo brew!'").strip
  end
end
