class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20190130162938.tar.gz"
  sha256 "7952de1483630c467b20d06532be43d4224ce26a92e932bf666db141ee80fa0b"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6934336f0dacfe9a8ed4e6f49c6dfca53bc8e78f004e0abe4a414b911f6c2f3" => :mojave
    sha256 "a6fe060a980a91bcda447f4ce2fb29a58387e1d01e51aa4bfad6dd3d2c4ae440" => :high_sierra
    sha256 "ff4ac106a94a63a4c0001410733a69a1440656ef565ab449340447ecce77f2aa" => :sierra
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
