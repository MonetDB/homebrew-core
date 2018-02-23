class Leaps < Formula
  desc "Collaborative web-based text editing service written in Golang"
  homepage "https://github.com/jeffail/leaps"
  url "https://github.com/Jeffail/leaps.git",
      :tag => "v0.9.0",
      :revision => "89d8ab9e9130238e56a0df283edbcd1115ec9225"

  bottle do
    cellar :any_skip_relocation
    sha256 "508d51af88cd4c58e7419cb9d20eaa59de7707dca575ed400473516920340d8e" => :high_sierra
    sha256 "57ede69ad725659397a5512dda8753b76c45149f786cbf49f2ffd2e0f5de82b4" => :sierra
    sha256 "bf1a3568ece6cc069f5528cae7b4d426dbcb831ce7fea39b0dec1d5eaeb4b348" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jeffail/leaps").install buildpath.children
    cd buildpath/"src/github.com/jeffail/leaps" do
      system "dep", "ensure"
      system "go", "build", "-o", bin/"leaps", "./cmd/leaps"
      prefix.install_metafiles
    end
  end

  test do
    begin
      port = ":8080"

      # Start the server in a fork
      leaps_pid = fork do
        exec "#{bin}/leaps", "-address", port
      end

      # Give the server some time to start serving
      sleep(1)

      # Check that the server is responding correctly
      assert_match "You are alone", shell_output("curl -o- http://localhost#{port}")
    ensure
      # Stop the server gracefully
      Process.kill("HUP", leaps_pid)
    end
  end
end
