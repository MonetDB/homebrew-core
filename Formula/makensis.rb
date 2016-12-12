class Makensis < Formula
  desc "System to create Windows installers"
  homepage "http://nsis.sourceforge.net/"

  stable do
    url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.01/nsis-3.01-src.tar.bz2"
    sha256 "604c011593be484e65b2141c50a018f1b28ab28c994268e4ecd377773f3ffba1"

    resource "nsis" do
      url "https://downloads.sourceforge.net/project/nsis/NSIS%203/3.01/nsis-3.01.zip"
      sha256 "daa17556c8690a34fb13af25c87ced89c79a36a935bf6126253a9d9a5226367c"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7e26c00822172892a80ab04c2408dc30b3f5844a87c8788ca169f310c0417154" => :sierra
    sha256 "b1b91ef9a80cd5857cc9e600ddf29c6ff26b5e8d95d7ed1b362519f6aa15d798" => :el_capitan
    sha256 "3424dc5147485d37deb1c4c5569a07ab370424268bf841c77b235cc85e96d248" => :yosemite
    sha256 "0901ab2f047cdebbabbcd4fbb382a90dcd8398a4817579548a727f1952cdf07d" => :mavericks
  end

  depends_on "scons" => :build

  # scons appears to have no builtin way to override the compiler selection,
  # and the only options supported on macOS are 'gcc' and 'g++'.
  # Use the right compiler by forcibly altering the scons config to set these
  patch :DATA

  def install
    # makensis fails to build under libc++; since it's just a binary with
    # no Homebrew dependencies, we can just use libstdc++
    # https://sourceforge.net/p/nsis/bugs/1085/
    ENV.libstdcxx if ENV.compiler == :clang

    # Don't strip, see https://github.com/Homebrew/homebrew/issues/28718
    scons "STRIP=0", "SKIPUTILS=all", "makensis"
    bin.install "build/urelease/makensis/makensis"
    (share/"nsis").install resource("nsis")
  end

  test do
    system "#{bin}/makensis", "-VERSION"
  end
end

__END__
diff --git a/SCons/config.py b/SCons/config.py
index a344456..37c575b 100755
--- a/SCons/config.py
+++ b/SCons/config.py
@@ -1,3 +1,5 @@
+import os
+
 Import('defenv')
 
 ### Configuration options
@@ -440,6 +442,9 @@ Help(cfg.GenerateHelpText(defenv))
 env = Environment()
 cfg.Update(env)
 
+defenv['CC'] = os.environ['CC']
+defenv['CXX'] = os.environ['CXX']
+
 def AddValuedDefine(define):
   defenv.Append(NSIS_CPPDEFINES = [(define, env[define])])
