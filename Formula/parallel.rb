class Parallel < Formula
  desc "GNU parallel shell command"
  homepage "https://savannah.gnu.org/projects/parallel/"
  url "https://ftpmirror.gnu.org/parallel/parallel-20161122.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/parallel/parallel-20161122.tar.bz2"
  sha256 "e2595011494b557822134bd6ad73c8d455764cdf51d148005346a4564626ac7c"
  head "http://git.savannah.gnu.org/r/parallel.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6192d6eb299ced5a0a5ef854f3d889b6819e507319c8a6c32e1057f971ab3532" => :sierra
    sha256 "6192d6eb299ced5a0a5ef854f3d889b6819e507319c8a6c32e1057f971ab3532" => :el_capitan
    sha256 "6192d6eb299ced5a0a5ef854f3d889b6819e507319c8a6c32e1057f971ab3532" => :yosemite
  end

  conflicts_with "moreutils", :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "test\ntest\n",
                 shell_output("#{bin}/parallel --will-cite echo ::: test test")
  end
end
