class Xmrig < Formula
  desc "Monero (XMR) CPU miner"
  homepage "https://github.com/xmrig/xmrig"
  url "https://github.com/xmrig/xmrig/archive/v2.5.2.tar.gz"
  sha256 "809592cd70335e7984a16738b435e9a08071bda938b251c48258a8f946f0bdb3"

  bottle do
    cellar :any
    sha256 "d0db6ce3b516a92c48a68a0e269696345267ed9d050dc39109270503fd8740ef" => :high_sierra
    sha256 "7f886124955464d0eb3577e4fcaf819b6555753c8ab9d971e34a3eac64045168" => :sierra
    sha256 "0de4ef4360fb67e3f1a7021be77b95a6cc3f126cafcd4fc6d13f30eb30ec568e" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "libmicrohttpd"
  depends_on "libuv"

  def install
    mkdir "build" do
      system "cmake", "..", "-DUV_LIBRARY=#{Formula["libuv"].opt_lib}/libuv.dylib",
                            *std_cmake_args
      system "make"
      bin.install "xmrig"
    end
    pkgshare.install "src/config.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/xmrig -V", 2)
    test_server="donotexist.localhost:65535"
    timeout=10
    begin
      read, write = IO.pipe
      pid = fork do
        exec "#{bin}/xmrig", "--no-color", "--max-cpu-usage=1", "--print-time=1",
             "--threads=1", "--retries=1", "--url=#{test_server}", :out => write
      end
      start_time=Time.now
      loop do
        assert (Time.now - start_time <= timeout), "No server connect after timeout"
        break if read.gets.include? "\] \[#{test_server}\] DNS error: \"unknown node or service\""
      end
    ensure
      Process.kill("SIGINT", pid)
    end
  end
end
