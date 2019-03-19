class Openrct2 < Formula
  desc "Open source re-implementation of RollerCoaster Tycoon 2"
  homepage "https://openrct2.io/"
  url "https://github.com/OpenRCT2/OpenRCT2.git",
      :tag      => "v0.2.2",
      :revision => "298c9f5238fe2ead4c319dd0699cdebf9fe390cb"
  head "https://github.com/OpenRCT2/OpenRCT2.git", :branch => "develop"

  bottle do
    cellar :any
    sha256 "d6c869c40a8e2b130b974fcd904d023480a801ec189f2ded6f213199d2f6f2d8" => :mojave
    sha256 "23a8a95a75981e14cbbcdc8d0f2fde2a0483353a0ebe793e1e0ac5e4675a7019" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype" # for sdl2_ttf
  depends_on "icu4c"
  depends_on "jansson"
  depends_on "libpng"
  depends_on "libzip"
  depends_on :macos => :high_sierra # "missing: Threads_FOUND" on Sierra
  depends_on "openssl"
  depends_on "sdl2"
  depends_on "sdl2_ttf"
  depends_on "speexdsp"

  resource "title-sequences" do
    url "https://github.com/OpenRCT2/title-sequences/releases/download/v0.1.2/title-sequence-v0.1.2.zip",
        :using => :nounzip
    sha256 "dcb1648739b351e857e2d19fed1626bec561d5e9f4b49201568f42c475ee7e61"
  end

  resource "objects" do
    url "https://github.com/OpenRCT2/objects/releases/download/v1.0.6/objects.zip",
        :using => :nounzip
    sha256 "714257dcf6dc4af8761ecda1b313bfa63b3ef93ab7e46572a3e499fe4bf26e02"
  end

  def install
    # Avoid letting CMake download things during the build process.
    (buildpath/"data/title").install resource("title-sequences")
    (buildpath/"data/object").install resource("objects")
    tversion = resource("title-sequences").version
    mv buildpath/"data/title/title-sequence-v#{tversion}.zip", "title-sequences.zip"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end

    # By default macOS build only looks up data in app bundle Resources
    libexec.install bin/"openrct2"
    (bin/"openrct2").write <<~EOS
      #!/bin/bash
      exec "#{libexec}/openrct2" "$@" "--openrct-data-path=#{pkgshare}"
    EOS
  end

  test do
    assert_match "OpenRCT2, v#{version}", shell_output("#{bin}/openrct2 -v")
  end
end
