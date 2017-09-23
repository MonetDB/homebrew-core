class Xa < Formula
  desc "6502 cross assembler"
  homepage "http://www.floodgap.com/retrotech/xa/"
  url "http://www.floodgap.com/retrotech/xa/dists/xa-2.3.8.tar.gz"
  sha256 "3b97d2fe8891336676ca28ff127b69e997f0b5accf2c7009b4517496929b462a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ce34c302b13f53cf12ae5b5b86c96ce410fccc4b4cefd84e7d94ef42b58f2e1" => :sierra
    sha256 "078254b88c6c70bed9212dad2767e1b6cb03976426e2ae8c58564a4eb22a5a3f" => :el_capitan
    sha256 "7e6d166991991c31e57269bdd84ec77ac5b4df241361b999ec8d04e977d47e66" => :yosemite
    sha256 "dc934d679ade0e6180334b746c2bff510b0388ed9908d5388bb9bdd4f61e69c5" => :mavericks
    sha256 "4c529953faecfdd9386f2065b5b189388b5710d1b99f995b72003d4bed0502c6" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "DESTDIR=#{prefix}",
                   "install"
  end

  test do
    (testpath/"foo.a").write "jsr $ffd2\n"

    system "#{bin}/xa", "foo.a"
    code = File.open("a.o65", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x20, 0xd2, 0xff], code
  end
end
