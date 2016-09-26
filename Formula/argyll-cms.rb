class ArgyllCms < Formula
  desc "ICC compatible color management system"
  homepage "http://www.argyllcms.com/"
  url "http://www.argyllcms.com/Argyll_V1.9.0_src.zip"
  version "1.9.0"
  sha256 "93adb00665505a1859573c7f286d991c1c07cae2883b65d67a258892c731880e"

  bottle do
    cellar :any
    revision 1
    sha256 "4598c3c991524acfb49162ec6d7e28bba2e10e07c7a1515ea43da30d66eb3cc7" => :el_capitan
    sha256 "149da3dc3ff1634c599cafbc5e3bdc0610dbe01ccda97b191c6eca4bf9059987" => :yosemite
    sha256 "bfacf495413da04c187e2c40049b9a0d77f09df34dee8820a67624d449276b52" => :mavericks
  end

  depends_on "jam" => :build
  depends_on "jpeg"
  depends_on "libtiff"

  conflicts_with "num-utils", :because => "both install `average` binaries"

  def install
    system "sh", "makeall.sh"
    system "./makeinstall.sh"
    rm "bin/License.txt"
    prefix.install "bin", "ref", "doc"
  end

  test do
    system bin/"targen", "-d", "0", "test.ti1"
    system bin/"printtarg", testpath/"test.ti1"
    %w[test.ti1.ps test.ti1.ti1 test.ti1.ti2].each { |f| File.exist? f }
  end
end
