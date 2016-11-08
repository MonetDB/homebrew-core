class Wdc < Formula
  desc "WebDAV Client provides easy and convenient to work with WebDAV-servers."
  homepage "https://designerror.github.io/webdav-client-cpp"
  url "https://github.com/designerror/webdav-client-cpp/archive/v1.0.1.tar.gz"
  sha256 "64b01de188032cb9e09f5060965bd90ed264e7c0b4ceb62bfc036d0caec9fd82"

  bottle do
    cellar :any_skip_relocation
    sha256 "8bdef781390ff6d3e18669ccad5d6504c0d25c647d47a991c7adfa9baa6f4fcb" => :sierra
    sha256 "303461ad224414e8a1065ddd61e1d16570fd02fbb647f8fb24122996f2f2e34b" => :el_capitan
    sha256 "0465537d25d7130987911e298575a1e0517cd7283ca081a1462ff59bdfadd92d" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "openssl"
  depends_on "pugixml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <webdav/client.hpp>
      #include <cassert>
      #include <string>
      #include <memory>
      #include <map>
      int main(int argc, char *argv[]) {
        std::map<std::string, std::string> options =
        {
          {"webdav_hostname", "https://webdav.example.com"},
          {"webdav_login",    "webdav_login"},
          {"webdav_password", "webdav_password"}
        };
        std::shared_ptr<WebDAV::Client> client(WebDAV::Client::Init(options));
        auto check_connection = client->check();
        assert(!check_connection);
      }
    EOS
    system ENV.cc,  "test.cpp", "-L#{lib}", "-L/usr/local/lib",
                    "-lwdc", "-lpthread", "-lpugixml",
                    "-lm", "-lcurl", "-lssl", "-lcrypto",
                    "-lstdc++", "-std=c++11", "-o", "test"
    system "./test"
  end
end
