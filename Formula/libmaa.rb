class Libmaa < Formula
  desc "Low-level data structures including hash tables, sets, lists"
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.4.2/libmaa-1.4.2.tar.gz"
  sha256 "63de331c97a40efe8b64534fee4b7b7df161645b92636572ad248b0f13abc0db"

  bottle do
    cellar :any
    rebuild 1
    sha256 "0eb30db4ae358164bcd4d438be80a868b39f0f8d86447e5985971ee738082de4" => :high_sierra
    sha256 "53d74fbf998dc538eef1240cb27809a82389410324ce8917339481677dcdb3a0" => :sierra
    sha256 "55e856349d9523de82f4ded30f4b5065e355b627ac53e8a7ae1599ee01d312d2" => :el_capitan
    sha256 "2187eee3e1d3b9dd54fabbf1be63c388458af7986f0f470f31a6111d47212227" => :yosemite
    sha256 "c0919efec1d1e0661a8228914a90c0f482b720622f31033841631819c6c4d1df" => :mavericks
    sha256 "60bd1424f0ef468d95248fa6c3bf4845f2b5b649829623160c1b85b82be3ad57" => :mountain_lion
  end

  depends_on "bmake" => :build
  depends_on "mk-configure" => :build

  def install
    # not parallel safe, errors surrounding generated arggram.c
    # https://github.com/cheusov/libmaa/issues/2
    ENV.deparallelize
    system "mkcmake", "install", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
  end
end
