class Ppss < Formula
  desc "Shell script to execute commands in parallel"
  homepage "https://github.com/louwrentius/PPSS"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ppss/ppss-2.97.tgz"
  sha256 "25d819a97d8ca04a27907be4bfcc3151712837ea12a671f1a3c9e58bc025360f"

  bottle :unneeded

  def install
    bin.install "ppss"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ppss --version")
  end
end
