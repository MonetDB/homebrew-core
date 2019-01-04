class Recutils < Formula
  desc "Tools to work with human-editable, plain text data files"
  homepage "https://www.gnu.org/software/recutils/"
  url "https://ftp.gnu.org/gnu/recutils/recutils-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnu/recutils/recutils-1.8.tar.gz"
  sha256 "df8eae69593fdba53e264cbf4b2307dfb82120c09b6fab23e2dad51a89a5b193"

  bottle do
    cellar :any
    sha256 "e27983655f55a523db7775de1b86728ba2b4ff289d608f64bcf99e0dc224714d" => :mojave
    sha256 "577f81582b338d44b2b231ab7a353ceaa0b01cf899b9a5042924568d95b20ec5" => :high_sierra
    sha256 "13ded271da7be4d07cce7f454d5c6ad871151c08b319f5a1670bdefd882a62da" => :sierra
    sha256 "e11f1ef2e988f963ddf52088c8d50626c4179b4065b19e254315ae75486439c1" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{elisp}"
    system "make", "install"
  end

  test do
    (testpath/"test.csv").write <<~EOS
      a,b,c
      1,2,3
    EOS
    system "#{bin}/csv2rec", "test.csv"

    (testpath/"test.rec").write <<~EOS
      %rec: Book
      %mandatory: Title

      Title: GNU Emacs Manual
    EOS
    system "#{bin}/recsel", "test.rec"
  end
end
