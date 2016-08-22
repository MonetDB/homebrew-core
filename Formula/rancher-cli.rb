class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.1.0.tar.gz"
  sha256 "3fad04522eb4b689de191da6322907c79a6ef41b057e6cf34f1570ad0f58de00"

  bottle do
    cellar :any_skip_relocation
    sha256 "bc054ef653fd409a27f7439b551f630c2fcc7aca92f3365bfad9df14d12003f8" => :el_capitan
    sha256 "8b648da416cdecab158c82cccd2df4598444356faad7f86feabbec51f78fbf35" => :yosemite
    sha256 "eb2e2bfebd5211e72432e4bb977ed0ab6fef50e9ff13cf157a92fba36bcdc17e" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/rancher/cli/").install Dir["*"]
    system "go", "build", "-ldflags",
           "-w -X github.com/rancher/cli/version.VERSION=#{version}",
           "-o", "#{bin}/rancher",
           "-v", "github.com/rancher/cli/"
  end

  test do
    system bin/"rancher", "help"
  end
end
