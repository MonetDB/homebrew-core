class Igv < Formula
  desc "Interactive Genomics Viewer"
  homepage "https://www.broadinstitute.org/software/igv"
  url "https://data.broadinstitute.org/igv/projects/downloads/2.4/IGV_2.4.15.zip"
  sha256 "f095735b8d9b2fd1f119ffd5121a0634d748e8d3da3bb48f96892e392d4c1400"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    inreplace "igv.sh", /^prefix=.*/, "prefix=#{libexec}"
    libexec.install "igv.sh", "lib"
    (bin/"igv").write_env_script libexec/"igv.sh", Language::Java.java_home_env("1.8")
  end

  test do
    (testpath/"script").write "exit"
    assert_match "Version", shell_output("#{bin}/igv -b script")
  end
end
