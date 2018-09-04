class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180903202725.tar.gz"
  sha256 "8885c19be8c32a05f5e26acdd3de778f68c2aba14577cd78cb989a45d8e1635c"

  bottle do
    cellar :any_skip_relocation
    sha256 "09a9b20d48ea3541d7711ffd380bff4f087bb7fe3f5a13bf20c3ce2903b52b94" => :mojave
    sha256 "3c8e464fdd3282c4af8997e8e66e7ec57cf8b2004d4fe83ae25a73ca3d1e426a" => :high_sierra
    sha256 "f3a1d1ee7dafa3601c7bcbbd198810abacee0ce5e3e07f2aca5ca34fde4ee06a" => :sierra
    sha256 "ea8dd65ef5adaac03ab17aaf93e465df72da0820da4c93df68fd95a7ed767578" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
