class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/syndbg/goenv"
  url "https://github.com/syndbg/goenv/archive/1.13.0.tar.gz"
  sha256 "d74266672032be311ada977e5341cc0a2fc880d368e44820226f5e0bcc4bc20f"
  version_scheme 1
  head "https://github.com/syndbg/goenv.git"

  bottle :unneeded

  def install
    inreplace "libexec/goenv", "/usr/local", HOMEBREW_PREFIX
    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
