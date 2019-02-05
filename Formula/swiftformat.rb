class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.39.0.tar.gz"
  sha256 "a5d8eba27c8d8c80f735eab83c9292b4d691fe36b6bad8005d2a6d2092f66192"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "49820305d74e8047820b81d54cbed6a3bb2ea8d17e98f7fe4d33421891743fba" => :mojave
    sha256 "1bf4744195109ac073d98d088aaceeea6f71431c43f3d10ece9ea83ae2038336" => :high_sierra
    sha256 "c193e5e1397775e2d6f4a10cce598f3442db65c185eeaa25ab380ab0ff565a74" => :sierra
  end

  depends_on :xcode => ["9.2", :build]

  def install
    xcodebuild "-project",
        "SwiftFormat.xcodeproj",
        "-scheme", "SwiftFormat (Command Line Tool)",
        "CODE_SIGN_IDENTITY=",
        "SYMROOT=build", "OBJROOT=build"
    bin.install "build/Release/swiftformat"
  end

  test do
    (testpath/"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}/swiftformat", "#{testpath}/potato.swift"
  end
end
