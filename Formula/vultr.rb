require "language/go"

class Vultr < Formula
  desc "Command-line tool for Vultr"
  homepage "https://jamesclonk.github.io/vultr"
  url "https://github.com/JamesClonk/vultr/archive/1.11.0.tar.gz"
  sha256 "a6af3e4e88cf45f2a6ccfac5530bfebbd1c347c18568932c51c0c28c82e953e8"
  revision 1
  head "https://github.com/JamesClonk/vultr.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ae34af28c07318e5c2ff49ccf0309a87c95716650bd632d292883abfe87d49f" => :sierra
    sha256 "9be61aef914af56459ef1467f97da2bab7ec7ccdd5338ff8f28bb3afe9e9681a" => :el_capitan
    sha256 "8b33b925e839a4af87edbe31b43de3ef6f348a394d6a8a5214667b8ec317a430" => :yosemite
  end

  depends_on "go" => :build
  depends_on "godep" => :build
  depends_on "gdm" => :build

  go_resource "github.com/jawher/mow.cli" do
    url "https://github.com/jawher/mow.cli.git",
        :revision => "0de3d3b4ed00f261460d12ecde4efa90fbfcd8ed"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "77ed1c8a01217656d2080ad51981f6e99adaa177"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/JamesClonk").mkpath
    ln_s buildpath, buildpath/"src/github.com/JamesClonk/vultr"
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", bin/"vultr"
  end

  test do
    system bin/"vultr", "version"
  end
end
