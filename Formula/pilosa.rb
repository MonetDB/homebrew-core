require "language/go"

class Pilosa < Formula
  desc "Distributed bitmap index that queries across data sets"
  homepage "https://www.pilosa.com"
  url "https://github.com/pilosa/pilosa/archive/v0.7.1.tar.gz"
  sha256 "c889b774b78c85fb1a23984e362e0201444b8b3d7baa38d3507dbd9ad675de04"

  bottle do
    cellar :any_skip_relocation
    sha256 "09cbbcab9e53cc7ac8f21b6ca42bed4e5a9890fb89a6546c4011bc5d2eb7b648" => :high_sierra
    sha256 "d07e11df5d448dacee09141347b214f89196769ccf892e0d563830d867564d15" => :sierra
    sha256 "b866a9991db42d554b5bf0fd223e490e98393dc0bbd6ffd50b86a93684e108a4" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "dep" => :build

  go_resource "github.com/rakyll/statik" do
    url "https://github.com/rakyll/statik.git",
        :tag => "v0.1.1"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_path "PATH", "#{buildpath}/bin"

    (buildpath/"src/github.com/pilosa/pilosa").install buildpath.children
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/rakyll/statik" do
      system "go", "install"
    end
    cd "src/github.com/pilosa/pilosa" do
      system "make", "generate-statik", "pilosa", "FLAGS=-o #{bin}/pilosa", "VERSION=v#{version}"
    end
  end

  plist_options :manual => "pilosa server"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/pilosa</string>
            <string>server</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <dict>
            <key>SuccessfulExit</key>
            <false/>
        </dict>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
    EOS
  end

  test do
    begin
      server = fork do
        exec "#{bin}/pilosa", "server"
      end
      sleep 0.5
      assert_match("Welcome. Pilosa is running.", shell_output("curl localhost:10101"))
      assert_match("<!DOCTYPE html>", shell_output("curl --user-agent NotCurl localhost:10101"))
    ensure
      Process.kill "TERM", server
      Process.wait server
    end
  end
end
