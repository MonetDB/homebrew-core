class Qbs < Formula
  desc "Build tool for developing projects across multiple platforms."
  homepage "https://wiki.qt.io/Qbs"
  url "https://download.qt.io/official_releases/qbs/1.9.0/qbs-src-1.9.0.tar.gz"
  sha256 "eb1bdedd274ad349442cb6b3938b4b904e7f738881c0689c2b71b620ec714793"
  head "https://code.qt.io/qt-labs/qbs.git"

  bottle do
    cellar :any
    sha256 "717dc0193d30ad8e28f33b100a7753ce5a0266b69e168c6a114ff6b84ad5ec68" => :sierra
    sha256 "2aaa459c7ad7d1e6c39d14649d4c05b766374da50e2ac6b3e1fd61b7b47b1e69" => :el_capitan
    sha256 "6c87156f701bc16793aeb468942419a03077ad3628107d2e0ed3c144b6d04098" => :yosemite
  end

  depends_on "qt"

  def install
    cd "qbs-src-1.9.0" do
      system "qmake", "qbs.pro", "-r", "QBS_INSTALL_PREFIX=/"
      system "make", "install", "INSTALL_ROOT=#{prefix}"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() {
        return 0;
      }
    EOS

    (testpath/"test.qbp").write <<-EOS.undent
      import qbs

      CppApplication {
        name: "test"
        files: "test.c"
        consoleApplication: true
      }
    EOS

    system "#{bin}/qbs", "setup-toolchains", "--detect", "--settings-dir", testpath
    system "#{bin}/qbs", "run", "--settings-dir", testpath, "-f", "test.qbp", "profile:clang"
  end
end
