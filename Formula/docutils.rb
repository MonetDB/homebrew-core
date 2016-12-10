class Docutils < Formula
  desc "Text processing system for reStructuredText"
  homepage "http://docutils.sourceforge.net"
  url "https://downloads.sourceforge.net/project/docutils/docutils/0.13.1/docutils-0.13.1.tar.gz"
  sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"

  bottle do
    cellar :any_skip_relocation
    sha256 "6254928e32d119dbce4fc37f0a84306942f760696ecae02f8db4654934a238e6" => :sierra
    sha256 "ee05c025462c3a5cb0ffd524e8fa146c1b3918eb4f4c6fd1006ea4bf4ae5db96" => :el_capitan
    sha256 "a0cb7ec024d31a9f6f3bbcde7f07249e966bf9000008f7aee46a0978dcda9cb9" => :yosemite
    sha256 "61fe1f390fdef3c130f46d66123a483ab0d15994420c89884fb0e99143ff8c19" => :mavericks
  end

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "#{bin}/rst2man.py", "#{prefix}/HISTORY.txt"
  end
end
