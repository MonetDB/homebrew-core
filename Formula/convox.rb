class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20170925221816.tar.gz"
  sha256 "557d700c34dce238eb263fe0ea1970cc9a639d0146a092a4dfa2bcf2f8b56304"

  bottle do
    cellar :any_skip_relocation
    sha256 "79e4443c91d1b3063ef59108d74ff72ecde409c21a2b18dd60b294e8e1bab04c" => :high_sierra
    sha256 "9e398fc3b0585a3091fcb62dc49c3b829ed61e87c595941df27d0694bad4da79" => :sierra
    sha256 "0541aa043e77c10b1525ac673600739c3b04dcd6e1132f6e453bc1270008d5c3" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
