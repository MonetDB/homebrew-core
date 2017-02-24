class Tnef < Formula
  desc "Microsoft MS-TNEF attachment unpacker"
  homepage "https://github.com/verdammelt/tnef"
  url "https://github.com/verdammelt/tnef/archive/1.4.13.tar.gz"
  sha256 "e1d0eb2ba1f7e4689158cf3dfe10ed1571ea239eedc223b830331c6b0fbfcbf7"

  bottle do
    cellar :any_skip_relocation
    sha256 "8971b75ed212864d6fe77ec60a9e9edd24ca43cb5ecacd96f7f99dd271be6387" => :sierra
    sha256 "f890ad7f42e1abd4f2b4d50fa438642731c82fe01f237ed8926c28537029a7d3" => :el_capitan
    sha256 "a39a144c679b2ae1dfdde6c3062fd9aefefb9d20c44be0943439a17cd1a81a85" => :yosemite
    sha256 "f908fdb42132f3cc2904accf4cefa3623f461a5a683bc37f93c258b144d0c465" => :mavericks
    sha256 "fc3c6f4a0a89f97da20ffea1b99a153e16fc5d9359f73f3c45ca3776912a68e8" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
