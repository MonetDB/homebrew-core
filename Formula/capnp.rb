class Capnp < Formula
  desc "Data interchange format and capability-based RPC system"
  homepage "https://capnproto.org/"
  url "https://capnproto.org/capnproto-c++-0.7.0.tar.gz"
  sha256 "c9a4c0bd88123064d483ab46ecee777f14d933359e23bff6fb4f4dbd28b4cd41"
  head "https://github.com/capnproto/capnproto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bef9feb71e7b29a5e4635358440a11cc9558b4d565665f0a4af50254a9316404" => :mojave
    sha256 "dd976dfecf6bb362aa6f4471722b7a66c9dede1b231a77b56231ed31a66660ad" => :high_sierra
    sha256 "02d729a3d9c6267ff0bea777ade442da70410f04f4f478e789d6f02ca4ad8069" => :sierra
    sha256 "2393cf083cccf35613b7bd293d87a52f201a4f0cd48bce8d0cd60300808ee203" => :el_capitan
    sha256 "726278b97a0fab5be359b604b08dc8ea9b5cd7a8a1e350e6724aaa40b7bbd5a2" => :yosemite
  end

  depends_on "cmake" => :build

  needs :cxx14

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    file = testpath/"test.capnp"
    text = "\"Is a happy little duck\""

    file.write Utils.popen_read("#{bin}/capnp id").chomp + ";\n"
    file.append_lines "const dave :Text = #{text};"
    assert_match text, shell_output("#{bin}/capnp eval #{file} dave")
  end
end
