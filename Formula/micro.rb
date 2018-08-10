class Micro < Formula
  desc "Modern and intuitive terminal-based text editor"
  homepage "https://github.com/zyedidia/micro"
  url "https://github.com/zyedidia/micro/releases/download/v1.4.1/micro-1.4.1-src.tar.gz"
  sha256 "0b516826226cf1ddf2fbb274f049cab456a5c162efe3d648f0871564fadcf812"
  head "https://github.com/zyedidia/micro.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "b62c650de130a9e69dd4aacf8aa1e7b20773bac9ca383a9247fb2226592ac0e5" => :high_sierra
    sha256 "85c7bf65bf8ba26161536ba05f57b794ccb600719afdad98296080701bda7412" => :sierra
    sha256 "9e6d1a33a9641b2aadc3cc2ca2886d785b2fbeda20299c509ca47928ee6a20de" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/zyedidia/micro").install buildpath.children

    cd "src/github.com/zyedidia/micro" do
      system "make", "build-quick"
      bin.install "micro"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/micro -version")
  end
end
