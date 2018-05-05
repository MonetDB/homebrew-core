require "language/node"

class Heroku < Formula
  desc "Command-line client for the cloud PaaS"
  homepage "https://cli.heroku.com"
  url "https://registry.npmjs.org/heroku/-/heroku-7.0.26.tgz"
  sha256 "6d3ec6ad1890e68284a3f3d3b70730312cefcb5660196cb70fe27840d66d6c8c"
  head "https://github.com/heroku/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ab0da4da6e54b0b4bf6cd5857f2b82d93642951e8f9c1f73829354497fc28002" => :high_sierra
    sha256 "f53b9696e1d3c2b47434998daec9bb57a5366156336284612b6523c86b56bc2f" => :sierra
    sha256 "05d14d9bac7e5288723906cbf9402a45160bb72250dd84b56d34f58f549fe64f" => :el_capitan
  end

  depends_on "node"

  def install
    inreplace "bin/run", "#!/usr/bin/env node",
                         "#!#{Formula["node"].opt_bin}/node"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"heroku", "version"
  end
end
