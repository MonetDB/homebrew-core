class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.9.tar.gz"
  sha256 "96bdf91686eb2686326155a5af74540299a68352418d81ae6c8aaeca699c27b4"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<-EOS.undent
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
