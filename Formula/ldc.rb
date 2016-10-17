class Ldc < Formula
  desc "Portable D programming language compiler"
  homepage "https://wiki.dlang.org/LDC"
  revision 2

  stable do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.0.0/ldc-1.0.0-src.tar.gz"
    sha256 "3740ee6d5871e953aeb03b11f9d8c951286a55884892b51981bfe579b8fe571d"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
    end
  end

  bottle do
    sha256 "8a9c99461462abb528f47d171931a669ee10f37854a696d0148cb3ca81bafe7a" => :sierra
    sha256 "878eb1604258ed920d02d7fc7115db2f5ed6463ac7f4f18802bd76b85d51ff24" => :el_capitan
    sha256 "a662178ed8421cdaa69fcdd28d6f3b33c2e486e38369be610821f434cf74363a" => :yosemite
    sha256 "2d80883684831b20063db020f28f58bbf3888d9e681ec25d8db0829345ceb58e" => :mavericks
  end

  devel do
    url "https://github.com/ldc-developers/ldc/releases/download/v1.1.0-beta3/ldc-1.1.0-beta3-src.tar.gz"
    sha256 "cf4aeb393eada610aa3bad18c3ae6a5de94250eaa968fe2d1b0a6afdf8ea54f6"
    version "1.1.0-beta3"

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc/releases/download/v0.17.2/ldc-0.17.2-src.tar.gz"
      sha256 "8498f0de1376d7830f3cf96472b874609363a00d6098d588aac5f6eae6365758"
    end
  end

  head do
    url "https://github.com/ldc-developers/ldc.git", :shallow => false

    resource "ldc-lts" do
      url "https://github.com/ldc-developers/ldc.git", :shallow => false, :branch => "ltsmaster"
    end
  end

  needs :cxx11

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "libconfig"

  def install
    ENV.cxx11
    (buildpath/"ldc-lts").install resource("ldc-lts")
    cd "ldc-lts" do
      mkdir "build" do
        args = std_cmake_args + %W[
          -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        ]
        system "cmake", "..", *args
        system "make"
      end
    end
    mkdir "build" do
      args = std_cmake_args + %W[
        -DLLVM_ROOT_DIR=#{Formula["llvm"].opt_prefix}
        -DINCLUDE_INSTALL_DIR=#{include}/dlang/ldc
        -DD_COMPILER=#{buildpath}/ldc-lts/build/bin/ldmd2
      ]

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.d").write <<-EOS.undent
      import std.stdio;
      void main() {
        writeln("Hello, world!");
      }
    EOS

    system bin/"ldc2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
    system bin/"ldmd2", "test.d"
    assert_match "Hello, world!", shell_output("./test")
  end
end
