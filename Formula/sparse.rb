class Sparse < Formula
  desc "Static C code analysis tool"
  homepage "https://sparse.wiki.kernel.org/"
  url "https://www.kernel.org/pub/software/devel/sparse/dist/sparse-0.5.2.tar.xz"
  sha256 "4632b7b74af72214247f982f976ba44206933bab3a2717e09df166fb5b8abe7a"
  head "https://git.kernel.org/pub/scm/devel/sparse/sparse.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "679d2e51c1f0ee786339d2715bfe85b24f563318b4b2c1a5873606b0aeb12217" => :high_sierra
    sha256 "bf8ccfa445389a6f69dbb6a58660b2228b58560e8ecc7a8045a07538c3702a88" => :sierra
    sha256 "78bc3435fd4818f38848fb1b6c57bfb70f540adf527f71390274d0d2a31efbac" => :el_capitan
    sha256 "be1693a0ec2050625898d960ffd99468d4ce7471785fe1ae6d6f373da2416b11" => :yosemite
    sha256 "4c33d0589d81abda44fef8904892dc7f6361e96caa82012a71101e9fefe4425c" => :mavericks
    sha256 "6dac58ce04e796731ea3f0ed3a239cbe6334ab54648f4238baf60d64c1d04437" => :mountain_lion
  end

  def install
    inreplace "Makefile", /PREFIX=\$\(HOME\)/, "PREFIX=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.C").write("int main(int a) {return a;}\n")
    system "#{bin}/sparse", testpath/"test.C"
  end
end
