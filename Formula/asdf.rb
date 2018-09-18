class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https://github.com/asdf-vm"
  url "https://github.com/asdf-vm/asdf/archive/v0.5.1.tar.gz"
  sha256 "5e7d4d61256e9f8185fcf04ef2b7f060a821569764d5c1212dc7d0ef7eb2edee"
  head "https://github.com/asdf-vm/asdf.git"

  bottle :unneeded

  depends_on "autoconf"
  depends_on "automake"
  depends_on "coreutils"
  depends_on "libtool"
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    bash_completion.install "completions/asdf.bash"
    fish_completion.install "completions/asdf.fish"
    libexec.install "bin/private"
    prefix.install Dir["*"]

    inreplace "#{lib}/commands/reshim.sh",
              "exec $(asdf_dir)/bin/private/asdf-exec ",
              "exec $(asdf_dir)/libexec/private/asdf-exec "
  end

  def caveats; <<~EOS
    Add the following line to your bash profile (e.g. ~/.bashrc, ~/.profile, or ~/.bash_profile)
         source #{opt_prefix}/asdf.sh

    If you use Fish shell, add the following line to your fish config (e.g. ~/.config/fish/config.fish)
         source #{opt_prefix}/asdf.fish
  EOS
  end

  test do
    output = shell_output("#{bin}/asdf plugin-list")
    assert_match "Oohes nooes ~! No plugins installed", output
  end
end
