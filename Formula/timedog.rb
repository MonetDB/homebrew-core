class Timedog < Formula
  desc "Lists files that were saved by a backup of the macOS Time Machine"
  homepage "https://github.com/nlfiedler/timedog"
  url "https://github.com/nlfiedler/timedog/archive/v1.4.tar.gz"
  sha256 "169ab408fe5c6b292a7d4adf0845c42160108fd43d6a392b95210204de49cb52"
  head "https://github.com/nlfiedler/timedog.git"

  bottle :unneeded

  def install
    bin.install "timedog"
  end

  test do
    assert_match "No machine directory found for host", shell_output("#{bin}/timedog 2>&1", 1)
  end
end
