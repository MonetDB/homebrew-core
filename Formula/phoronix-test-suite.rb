class PhoronixTestSuite < Formula
  desc "Open-source automated testing/benchmarking software"
  homepage "https://www.phoronix-test-suite.com/"
  url "https://github.com/phoronix-test-suite/phoronix-test-suite/archive/v8.6.1.tar.gz"
  sha256 "0e270f019c28d07132e848a29d8876ccf588d17c42639cef52332b8d3d015828"
  head "https://github.com/phoronix-test-suite/phoronix-test-suite.git"

  bottle :unneeded

  def install
    ENV["DESTDIR"] = buildpath/"dest"
    system "./install-sh", prefix
    prefix.install (buildpath/"dest/#{prefix}").children
    bash_completion.install "dest/#{prefix}/../etc/bash_completion.d/phoronix-test-suite"
  end

  # 7.4.0 installed files in the formula's rack so clean up the mess.
  def post_install
    rm_rf [prefix/"../etc", prefix/"../usr"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/phoronix-test-suite version")
  end
end
