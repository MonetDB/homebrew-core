class Bzrtools < Formula
  desc "Bazaar plugin that supplies useful additional utilities"
  homepage "http://wiki.bazaar.canonical.com/BzrTools"
  url "https://launchpad.net/bzrtools/stable/2.6.0/+download/bzrtools-2.6.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/b/bzrtools/bzrtools_2.6.0.orig.tar.gz"
  sha256 "8b17fbba61dafc8dbefe1917a2ce084a8adc7650dee60add340615270dfb7f58"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bzrtools").install Dir["*"]
  end

  test do
    system "bzr", "whoami", "Homebrew"
    system "bzr", "init-repo", "sample"
    system "bzr", "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"

    cd "sample/trunk" do
      msg = "my commit"
      system "bzr", "add", "test.txt"
      system "bzr", "commit", "-m", msg
      assert_match msg, shell_output("bzr heads")
    end
  end
end
