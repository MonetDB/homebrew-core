class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://download.kde.org/stable/applications/18.04.3/src/kcachegrind-18.04.3.tar.xz"
  sha256 "2370827f8d3c29ec931fc3ebf34726e42d25aaaab6c2f10dc5dd87f57056acfd"

  bottle do
    cellar :any
    sha256 "bf971056db18f7d62bf0638f1d8945d8b6ee4fd364b8ebe081141e1a7a0bdcb0" => :mojave
    sha256 "4a3e3ebaddd3109eee2cf891966cfab1c005e20fa258cb3de0fb1063eac74ad4" => :high_sierra
    sha256 "6104ad74b207d770490b65b6cd18a0d8e9c7e7bfae6e33db29e1bb2c33f2231f" => :sierra
    sha256 "7a9e4dac8bf9d741b18391c8d2e7f05f407caf1f30e6619b64cd3a9cce22cd1b" => :el_capitan
  end

  depends_on "qt"
  depends_on "graphviz" => :optional

  def install
    cd "qcachegrind" do
      system "#{Formula["qt"].opt_bin}/qmake", "-spec", "macx-clang",
                                               "-config", "release"
      system "make"
      prefix.install "qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    end
  end
end
