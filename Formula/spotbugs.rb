class Spotbugs < Formula
  desc "Tool for Java static analysis (FindBugs's successor)"
  homepage "https://spotbugs.github.io/"
  url "https://repo.maven.apache.org/maven2/com/github/spotbugs/spotbugs/3.1.8/spotbugs-3.1.8.tgz"
  sha256 "2cafeea4d28955f00f541fb05296e7c8ae6f555241e827dd260ac1fa04159c4e"

  head do
    url "https://github.com/spotbugs/spotbugs.git"

    depends_on "gradle" => :build
  end

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    if build.head?
      system "gradle", "build"
      system "gradle", "installDist"
      libexec.install Dir["spotbugs/build/install/spotbugs/*"]
    else
      libexec.install Dir["*"]
    end
    bin.install_symlink "#{libexec}/bin/spotbugs"
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      public class HelloWorld {
        private double[] myList;
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
        public double[] getList() {
          return myList;
        }
      }
    EOS
    system "javac", "HelloWorld.java"
    system "jar", "cvfe", "HelloWorld.jar", "HelloWorld", "HelloWorld.class"
    output = shell_output("#{bin}/spotbugs -textui HelloWorld.jar")
    assert_match /M V EI.*\nM C UwF.*\n/, output
  end
end
