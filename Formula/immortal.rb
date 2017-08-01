require "language/go"

class Immortal < Formula
  desc "OS agnostic (*nix) cross-platform supervisor"
  homepage "https://immortal.run/"
  url "https://github.com/immortal/immortal/archive/0.15.0.tar.gz"
  sha256 "bf0fa8f16f8045211a43f42001ed685959a28427a970f50db79c1a9176603b7b"
  head "https://github.com/immortal/immortal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1b662f66f20f7653a7524310fdc34a6e34471253a9e317fb59703db3a95b454" => :sierra
    sha256 "1526ff90b73b777895f341eca82ef1639b627a5b69e28745f7550f9dc07caa61" => :el_capitan
    sha256 "5d9e7c4f1894fa27b6e341d7ad50aac67081962c51cf6ee8b9c6b8d9eee5328f" => :yosemite
  end

  depends_on "go" => :build

  go_resource "github.com/go-yaml/yaml" do
    url "https://github.com/go-yaml/yaml.git",
        :revision => "25c4ec802a7d637f88d584ab26798e94ad14c13b"
  end

  go_resource "github.com/nbari/violetear" do
    url "https://github.com/nbari/violetear.git",
        :revision => "13cb9a63c0cb68977810a7f38ced9f93178d5d62"
  end

  go_resource "github.com/immortal/logrotate" do
    url "https://github.com/immortal/logrotate.git",
        :revision => "859105169067e6c76e08f888fb76cf4929fe9064"
  end

  go_resource "github.com/immortal/multiwriter" do
    url "https://github.com/immortal/multiwriter.git",
        :revision => "2555774a03ac1d12b5bb4392858959ee50f78884"
  end

  go_resource "github.com/immortal/natcasesort" do
    url "https://github.com/immortal/natcasesort.git",
        :revision => "69368b73881a69041466dd2b4fc0373f8e47db15"
  end

  go_resource "github.com/immortal/xtime" do
    url "https://github.com/immortal/xtime.git",
        :revision => "fb1aca1146ea82769e8433f5bb22f373765e7ecc"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/immortal/immortal").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"
    cd "src/github.com/immortal/immortal" do
      ldflags = "-s -w -X main.version=#{version}"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortal", "cmd/immortal/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortalctl", "cmd/immortalctl/main.go"
      system "go", "build", "-ldflags", ldflags, "-o", "#{bin}/immortaldir", "cmd/immortaldir/main.go"
      man8.install Dir["man/*.8"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"immortal", "-v"
    system bin/"immortalctl", "-v"
    system bin/"immortaldir", "-v"
  end
end
