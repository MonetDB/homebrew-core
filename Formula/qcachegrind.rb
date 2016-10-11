class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "http://download.kde.org/stable/applications/15.12.0/src/kcachegrind-15.12.0.tar.xz"
  sha256 "69d9f27e44d747f9aa433db45b75f1aef7eec6b6afd5b2b7cf0da0949c776a3e"

  bottle do
    cellar :any
    sha256 "e1da7ea0db2f7ab475ad2e5fa79eaadad6e7878e37de49038af5eb837831c2c6" => :sierra
    sha256 "0cea2d593204c50bc842a46bf2963447f374eb57b6bb0edd47d8db9473be7316" => :el_capitan
    sha256 "240c97e6d9f83416ac0ea50a7ccc03c295e6fc3937e9bd9066b6bed3fd2fa81f" => :yosemite
    sha256 "097cf0dfa43c444b17637ea69d1127d8e5c4e94545fb1107f3dbb71ea219d6f6" => :mavericks
  end

  depends_on "graphviz" => :optional
  depends_on "qt5"

  def install
    cd "qcachegrind"
    system "#{Formula["qt5"].bin}/qmake", "-spec", "macx-clang", "-config", "release"
    system "make"
    # Install app
    prefix.install "qcachegrind.app"
    # Symlink in the command-line version
    bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
  end
end
