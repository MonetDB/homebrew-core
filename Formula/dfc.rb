class Dfc < Formula
  desc "Display graphs and colors of file system space/usage"
  homepage "https://projects.gw-computing.net/projects/dfc"
  url "https://projects.gw-computing.net/attachments/download/615/dfc-3.1.1.tar.gz"
  sha256 "962466e77407dd5be715a41ffc50a54fce758a78831546f03a6bb282e8692e54"

  head "https://github.com/Rolinh/dfc.git"

  bottle do
    sha256 "b001963ac2219517ef02feab362d1438ebbd2e294079dafa9c526e49e6ca763e" => :sierra
    sha256 "55eabadcaf7c107b2d23d6bee876948c24caabc26ac011ecbcabb2e72d622d63" => :el_capitan
    sha256 "123863a4a8f25dd0bcc28a3b23d98639126ba838e11192d867ddaabc0f7553a5" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "gettext"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system bin/"dfc", "-T"
    assert_match ",%USED,", shell_output("#{bin}/dfc -e csv")
  end
end
