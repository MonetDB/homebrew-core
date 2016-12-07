class Fonttools < Formula
  include Language::Python::Virtualenv

  desc "Library for manipulating fonts"
  homepage "https://github.com/fonttools/fonttools"
  url "https://github.com/fonttools/fonttools/releases/download/3.3.0/fonttools-3.3.0.zip"
  sha256 "fe06549f6d6f67e9098f2fc43c4037e9db08ee789ba5a4c82d4aa8ecaa0c5001"
  head "https://github.com/fonttools/fonttools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "23fd41967426f2ea5a9f2e79b562e2f8e39ed7d961a57d0e1e3f803d3f24f3e9" => :sierra
    sha256 "decf3838d217c41d19e26fb3ae641490aaeadc5afbf3759624c4375cc50444ac" => :el_capitan
    sha256 "a94629a819ab315cda458f77b14a63fea2bb5353d41a1abaa69736df2785a9af" => :yosemite
  end

  option "with-pygtk", "Build with pygtk support for pyftinspect"

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "pygtk" => :optional

  def install
    virtualenv_install_with_resources
  end

  test do
    cp "/Library/Fonts/Arial.ttf", testpath
    system bin/"ttx", "Arial.ttf"
  end
end
