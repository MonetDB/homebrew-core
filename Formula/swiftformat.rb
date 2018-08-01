class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https://github.com/nicklockwood/SwiftFormat"
  url "https://github.com/nicklockwood/SwiftFormat/archive/0.34.1.tar.gz"
  sha256 "685bb4d064fb53c00f4b76c774e4daa751251bfc573479bda45ddaa98db49bb6"
  head "https://github.com/nicklockwood/SwiftFormat.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "8923d8965e4f115dd8e2c10edb740fea830e140ff803aebfe67602f2efb29117" => :high_sierra
    sha256 "4d79678f877906e63f6eff20ee759844fe0506c670c1b4250ff30c527a803a36" => :sierra
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
