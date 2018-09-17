class Ld64 < Formula
  desc "Updated version of the ld shipped by Apple"
  homepage "https://opensource.apple.com/"
  # Latest is 134.9, but it no longer supports building for PPC.
  # 127.2 won't build on Tiger, at least without some patching.
  # Leopard users: if you like, add a 127.2 option or fix the build
  # on Tiger.
  url "https://opensource.apple.com/tarballs/ld64/ld64-97.17.tar.gz"
  sha256 "02bd46af0809eaa415d096d7d41c3e8e7d80f7d8d181840866fb87f036b4e089"

  bottle do
    sha256 "8a0d5cdd74392a9c3b35b5ac46825e3bab03480ec6af828280322916862eb872" => :snow_leopard
    sha256 "e8da7e6c25c4966420cb0aaf2b2b144f769b8e974365e102c7afa9b3bda70488" => :leopard
  end

  keg_only :provided_by_macos,
    "ld64 is an updated version of the ld shipped by Apple"

  # Tiger either includes old versions of these headers,
  # or doesn't ship them at all
  depends_on "cctools-headers" => :build
  depends_on "dyld-headers" => :build
  depends_on "libunwind-headers" => :build
  depends_on MaximumMacOSRequirement => :snow_leopard
  depends_on "openssl"

  resource "makefile" do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b073fca/ld64/Makefile-97"
    sha256 "48e3475bd73f9501d17b7d334d3bf319f5664f2d5ab9d13378e37c2519ae2a3a"
  end

  fails_with :gcc_4_0 do
    build 5370
  end

  # Fixes logic on PPC branch islands
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b073fca/ld64/ld64-97-ppc-branch-island.patch"
    sha256 "a6bbf25c6e4fa348eee3d4756ad65f42ba42b78922dc0f75669023cdf9c25d72"
  end

  # Remove LTO support
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b073fca/ld64/ld64-97-no-LTO.patch"
    sha256 "2596cc25118981cbc31e82ddcb70508057f1946c46c3d6d6845ab7bd01ff1433"
  end

  # Fix version number
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/3b073fca/ld64/ld64-version.patch"
    sha256 "3753b6877641648017eab2bb391361840fe887a2b3eb2e5ef689272a28c374fc"
  end

  def install
    buildpath.install resource("makefile")
    mv "Makefile-97", "Makefile"
    inreplace "src/ld/Options.cpp", "@@VERSION@@", version

    args = %W[
      CC=#{ENV.cc}
      CXX=#{ENV.cxx}
      OTHER_CPPFLAGS=#{ENV.cppflags}
      OTHER_LDFLAGS=#{ENV.ldflags}
    ]

    args << 'RC_SUPPORTED_ARCHS="armv6 armv7 i386 x86_64"' if MacOS.version >= :lion

    # Macports makefile hardcodes optimization
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
      s.change_make_var! "CXXFLAGS", ENV.cxxflags
    end

    system "make", *args
    system "make", "install", "PREFIX=#{prefix}"
  end
end
