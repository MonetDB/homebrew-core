require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-1.19.2/pandoc-1.19.2.tar.gz"
  sha256 "8a87110f60e6412a4cae68b27e1647d029b73bb7f1794a62a3477a0df1bbbbbc"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "a8ab6fddd1437208f23eba528b00f3ff321ce8b04d4174fc5a849fe01b938abc" => :sierra
    sha256 "a17042674efb75a6fdf96be7e40feebfc805f4a6ccd4859901499ebe9130914a" => :el_capitan
    sha256 "1ab808a57bf1603bab47c5e2176ee014774cc19cad6d40e3034f7cd901c93f42" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      install_cabal_package *args
    end
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<-EOS.undent
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<-EOS.undent
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
