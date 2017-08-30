class RancherCli < Formula
  desc "The Rancher CLI is a unified tool to manage your Rancher server"
  homepage "https://github.com/rancher/cli"
  url "https://github.com/rancher/cli/archive/v0.6.4.tar.gz"
  sha256 "c880f237c8bb9f331585a558dbb9c67c95bb67ed07eef5511aae4494a2902c2f"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e368e63e5a2261daa416894a0159af0cd51a5947ba9e6aba905f31eaae9c4dc" => :sierra
    sha256 "80c946cbfb4fff164acea7ef9656503e4a43fcfaf8ee5f583a6fb1abbf012105" => :el_capitan
    sha256 "4ce9b913963116892d5bb92ebf110229d62a3c441df2b17550d3556a6f27fc85" => :yosemite
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
