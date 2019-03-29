class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v3.3.tar.gz"
  sha256 "b3fa0d339509564164d8ab3c8cd0c076ad3fdd500af3cea55a7fa4a089cd3c01"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "434cfe046abbea9ebb1456c52c9a40be912d14d6fa5a267b4ea4a404d4b17709" => :mojave
    sha256 "4283d675b4f870c944c088575fffde74986173042acffb9301d7107b3ffa6bcf" => :high_sierra
    sha256 "4283d675b4f870c944c088575fffde74986173042acffb9301d7107b3ffa6bcf" => :sierra
    sha256 "4283d675b4f870c944c088575fffde74986173042acffb9301d7107b3ffa6bcf" => :el_capitan
  end

  depends_on "sphinx-doc" => :build
  depends_on "pyqt"
  depends_on "python"

  def install
    ENV.delete("PYTHONPATH")
    system "make", "PYTHON=python3", "prefix=#{prefix}", "install"
    system "make", "install-doc", "PYTHON=python3", "prefix=#{prefix}",
           "SPHINXBUILD=#{Formula["sphinx-doc"].opt_bin}/sphinx-build"
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
