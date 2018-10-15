require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.5.13.tar.gz"
  sha256 "aac903c372324b1e57b0c61ba28d2c631ed81cb0e04f085661f2b6c0763ec818"
  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0982f5488c0c8149b4c52b062648e789df7e195354404507bb877d8c40ebd3be" => :mojave
    sha256 "2db64264ae9e6504462a08a74daaff6e0d7c69a841480f29c1344a3932203dd4" => :high_sierra
    sha256 "61814289da81d43fccef906d3ecf0069d370beb6a0cf1dccb61d46a551b5b501" => :sierra
    sha256 "52012e56ffb7738241774572e61c9b8ce9006121bee3d2a5e3af6522949686f2" => :el_capitan
  end

  depends_on "go" => :build

  go_resource "github.com/FiloSottile/gvt" do
    url "https://github.com/FiloSottile/gvt.git",
        :revision => "50d83ea21cb0405e81efd284951e111b3a68d701"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    cd("src/github.com/FiloSottile/gvt") { system "go", "install" }
    (buildpath/"src/github.com/zquestz").mkpath
    ln_s buildpath, "src/github.com/zquestz/s"
    system buildpath/"bin/gvt", "restore"
    system "go", "build", "-o", bin/"s"
  end

  test do
    output = shell_output("#{bin}/s -p bing -b echo homebrew")
    assert_equal "https://www.bing.com/search?q=homebrew", output.chomp
  end
end
