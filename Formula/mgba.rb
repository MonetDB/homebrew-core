class Mgba < Formula
  desc "Game Boy Advance emulator"
  homepage "https://mgba.io/"
  url "https://github.com/mgba-emu/mgba/archive/0.6.3.tar.gz"
  sha256 "35c8906c01206adae714fee9c2bc39698c514a4adb32c9c4a5a3fa58b2d10f9a"
  head "https://github.com/mgba-emu/mgba.git"

  bottle do
    cellar :any
    sha256 "225961abcc72b538b35be18e5348a5af0c0f6fe46b0daef9b581594b26a6b0d0" => :high_sierra
    sha256 "79d5e25543474d0715a369cfbe862f1c8d79b79c260a7cecdba2f38f6031f42d" => :sierra
    sha256 "9b7ad131ba17d492c53af30d996aeaac3814acd810aa5f3f9a73bfe098727ca4" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "libepoxy"
  depends_on "libpng"
  depends_on "libzip"
  depends_on "qt"
  depends_on "sdl2"

  def install
    # Fix "error: 'future<void>' is unavailable: introduced in macOS 10.8"
    # Reported 11 Dec 2017 https://github.com/mgba-emu/mgba/issues/944
    if MacOS.version <= :el_capitan
      ENV["MACOSX_DEPLOYMENT_TARGET"] = MacOS.version
    end

    # Install .app bundle into prefix, not prefix/Applications
    inreplace "src/platform/qt/CMakeLists.txt", "Applications", "."

    system "cmake", ".", *std_cmake_args
    system "make", "install"

    # Replace SDL frontend binary with a script for running Qt frontend
    # -DBUILD_SDL=OFF would be easier, but disable joystick support in Qt frontend
    rm bin/"mgba"
    bin.write_exec_script "#{prefix}/mGBA.app/Contents/MacOS/mGBA"
  end

  test do
    system "#{bin}/mGBA", "-h"
  end
end
