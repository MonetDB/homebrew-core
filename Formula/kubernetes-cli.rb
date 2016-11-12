class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  url "https://github.com/kubernetes/kubernetes/archive/v1.4.6.tar.gz"
  sha256 "dcbbf24ca664f55e40d539a167143f2e0ea0f3ff40e7df6e25887ca10bb2e185"
  head "https://github.com/kubernetes/kubernetes.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29c0e2d2b58e6e6a631f3c7c13cd7bfd103fae3ee31381eb4726710c0dbd436a" => :sierra
    sha256 "f582b31dd63befc350b949b4c68e8f8fdc4749468d136f85a48908f09b27de29" => :el_capitan
    sha256 "61bf7c24520fb9a6b688ded9667740f5991692d3867f9928d36207c5386226f5" => :yosemite
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.5.0-beta.0.tar.gz"
    sha256 "5453d3402e13fbab163f12bd00bdf143ea982aad64900a0f6b3b3a65e182dd99"
    version "1.5.0-beta.0"
  end

  depends_on "go" => :build

  def install
    # Patch needed to avoid vendor dependency on github.com/jteeuwen/go-bindata
    # Build will otherwise fail with missing dep
    # Raised in https://github.com/kubernetes/kubernetes/issues/34067
    rm "./test/e2e/framework/gobindata_util.go"

    # Race condition still exists in OSX Yosemite
    # Filed issue: https://github.com/kubernetes/kubernetes/issues/34635
    ENV.deparallelize { system "make", "generated_files" }
    system "make", "kubectl", "GOFLAGS=-v"

    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"
    bin.install "_output/local/bin/darwin/#{arch}/kubectl"

    output = Utils.popen_read("#{bin}/kubectl completion bash")
    (bash_completion/"kubectl").write output
  end

  test do
    output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", output
  end
end
