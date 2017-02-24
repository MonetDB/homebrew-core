class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v17.2.8.74.tar.gz"
  sha256 "703095b28cc2985494976b708853566225dd70d4beb1359a1eb7f7038332c221"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "1fa9255c72b1a142ac977d720dd019b3e7dfc4561ee9cbe492d90dfa29fe5079" => :sierra
    sha256 "bd68637074468e4afe579c992c6bae0043565267b04f1c1856fb434a06219a01" => :el_capitan
    sha256 "52d01f736ac16bc878b5f92b01915b7219d3e366f85689fd55dbaafba13550d3" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-manual-generation",
                          "--enable-html-generation",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    File.exist? testpath/".roswell/config"
  end
end
