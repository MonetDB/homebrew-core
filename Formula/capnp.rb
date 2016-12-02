class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.5.3.tar.gz"
  sha256 "cdb17c792493bdcd4a24bcd196eb09f70ee64c83a3eccb0bc6534ff560536afb"

  bottle do
    cellar :any_skip_relocation
    sha256 "d614f361c80a3218d4f5bed478f98a97f00d816dbd53730bd17cbc5ccb517166" => :el_capitan
    sha256 "bd5a6b2c7961bad80928fdcf612619495e0c9208fe69ba5c207b797cd9fc8bb2" => :yosemite
    sha256 "f99f439becc2eb9bf12e60cb8af0245fffee9aecf9ed07dc460196fe3f2d5f6e" => :mavericks
    sha256 "9c11b6174a97e022be4ebe5e05435818234dedc11c194afe09bce81fbf8f9a50" => :mountain_lion
  end

  needs :cxx11
  depends_on "cmake" => :build

  resource "gtest" do
    url "https://github.com/google/googletest/archive/release-1.7.0.tar.gz"
    sha256 "f73a6546fdf9fce9ff93a5015e0333a8af3062a152a9ad6bcb772c96687016cc"
  end

  def install
    ENV.cxx11

    gtest = resource("gtest")
    gtest.verify_download_integrity(gtest.fetch)
    inreplace "src/CMakeLists.txt" do |s|
      s.gsub! "http://googletest.googlecode.com/files/gtest-1.7.0.zip",
              gtest.cached_download
      s.gsub! "URL_MD5 2d6ec8ccdf5c46b05ba54a9fd1d130d7",
              "URL_HASH SHA256=#{gtest.checksum}"
    end

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/capnp", "--version"
  end
end
