class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/v2.2.2.tar.gz"
  sha256 "67a04fcebb017f49769ea5fd9215031f8902f1a8db30a7e1fff9a001e2e33e4d"

  bottle do
    cellar :any_skip_relocation
    sha256 "76be50b1c6f66922c3db4df4359142b9b3cdd522f8c8821e612be6a9a3a60778" => :el_capitan
    sha256 "275610aa85be815de959dafceab7d8245d2dd22690a8205b147b4ed91676d120" => :yosemite
    sha256 "0da6663a58c1235bfeb1b338b050bde51edb011cb517a32b384e33815901caa8" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
