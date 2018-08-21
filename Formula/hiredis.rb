class Hiredis < Formula
  desc "Minimalistic client for Redis"
  homepage "https://github.com/redis/hiredis"
  url "https://github.com/redis/hiredis/archive/v0.13.3.tar.gz"
  sha256 "717e6fc8dc2819bef522deaca516de9e51b9dfa68fe393b7db5c3b6079196f78"
  head "https://github.com/redis/hiredis.git"

  bottle do
    cellar :any
    sha256 "00bb6068241b8ebd326d6f1e4ebdb97e2441a25b0b63175d4f87962a3f6b5200" => :mojave
    sha256 "de253e88983ee372b611e7c9343987cd486dd19d5878a07935b265e7b651634f" => :high_sierra
    sha256 "93ea600964980acca0d01e7bcf34630280ce88edb01e2cd385e19e8a4e9d33cd" => :sierra
    sha256 "9c5dd3b595179560b3a22c685b87b32466edbfaea059659c72399e6b8c86b181" => :el_capitan
    sha256 "f038cdff672abde1099b34daac067172cf9545e04b49248f6a580732d242183d" => :yosemite
    sha256 "70fed127330cd583478cef89d89d34af112b60e5341cc7f42aa5d06f4b9575ce" => :mavericks
  end

  def install
    # Architecture isn't detected correctly on 32bit Snow Leopard without help
    ENV["OBJARCH"] = "-arch #{MacOS.preferred_arch}"

    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples"
  end

  test do
    # running `./test` requires a database to connect to, so just make
    # sure it compiles
    system ENV.cc, "-I#{include}/hiredis", "-L#{lib}", "-lhiredis",
           pkgshare/"examples/example.c", "-o", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
