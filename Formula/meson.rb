class Meson < Formula
  desc "Fast and user friendly build system"
  homepage "https://mesonbuild.com/"
  url "https://github.com/mesonbuild/meson/releases/download/0.47.1/meson-0.47.1.tar.gz"
  sha256 "d673de79f7bab064190a5ea06140eaa8415efb386d0121ba549f6d66c555ada6"
  head "https://github.com/mesonbuild/meson.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b3e52a4c70de23c46c0c535aac407fc4e0ec9c1796d1e5ea161dfcf0945b841" => :mojave
    sha256 "9bdf153903e78a320b5b22805f9f920e7b407966f6b045f241cae54236ccdbec" => :high_sierra
    sha256 "9bdf153903e78a320b5b22805f9f920e7b407966f6b045f241cae54236ccdbec" => :sierra
    sha256 "9bdf153903e78a320b5b22805f9f920e7b407966f6b045f241cae54236ccdbec" => :el_capitan
  end

  depends_on "python"
  depends_on "ninja"

  def install
    version = Language::Python.major_minor_version("python3")
    ENV["PYTHONPATH"] = lib/"python#{version}/site-packages"

    system "python3", *Language::Python.setup_install_args(prefix)

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    (testpath/"helloworld.c").write <<~EOS
      main() {
        puts("hi");
        return 0;
      }
    EOS
    (testpath/"meson.build").write <<~EOS
      project('hello', 'c')
      executable('hello', 'helloworld.c')
    EOS

    mkdir testpath/"build" do
      system "#{bin}/meson", ".."
      assert_predicate testpath/"build/build.ninja", :exist?
    end
  end
end
